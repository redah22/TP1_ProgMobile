// S'inscrire à un atelier.
// Un Form avec des champs validés, un choix dans une liste, une date,
// et un résultat renvoyé à l'écran appelant.
import 'package:flutter/material.dart';

enum Niveau {
  debutant('Débutant'),
  confirme('Confirmé');

  const Niveau(this.libelle);
  final String libelle;
}

// Une inscription : une valeur immuable, construite à la validation.
class Inscription {
  const Inscription({
    required this.nom,
    required this.courriel,
    required this.niveau,
    this.date,
  });

  final String nom;
  final String courriel;
  final Niveau niveau;
  final DateTime? date;
}

// region annexe-validateurs
// Un validateur reçoit le texte saisi et renvoie le message d'erreur à
// afficher sous le champ, ou null si la saisie est correcte.
// Ce sont des fonctions ordinaires testables sans interface.
String? validerNom(String? saisie) {
  final nom = saisie?.trim() ?? '';
  if (nom.isEmpty) return 'Le nom est obligatoire';
  if (nom.length > 40) return '40 caractères au plus';
  return null;
}

String? validerCourriel(String? saisie) {
  final texte = saisie?.trim() ?? '';
  final forme = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  return forme.hasMatch(texte) ? null : 'Adresse invalide';
}
// endregion annexe-validateurs

class FormulaireInscription extends StatefulWidget {
  const FormulaireInscription({super.key});

  @override
  State<FormulaireInscription> createState() => _FormulaireInscriptionState();
}

class _FormulaireInscriptionState extends State<FormulaireInscription> {
  // region annexe-formulaire-etat
  // La clé donne accès à l'état du Form : validate(), save(), reset().
  final _cle = GlobalKey<FormState>();

  // Les contrôleurs gardent le texte des champs.
  // Ils appartiennent au State, qui doit les libérer dans dispose().
  final _nom = TextEditingController();
  final _courriel = TextEditingController();
  Niveau _niveau = Niveau.debutant;
  DateTime? _date;

  @override
  void dispose() {
    _nom.dispose();
    _courriel.dispose();
    super.dispose();
  }
  // endregion annexe-formulaire-etat

  // region annexe-date
  Future<void> _choisirDate() async {
    final maintenant = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(maintenant.year, maintenant.month, maintenant.day),
      lastDate: DateTime(maintenant.year + 1),
    );
    if (!mounted || date == null) return; // null (boîte fermée sans choix)
    setState(() => _date = date);
  }
  // endregion annexe-date

  // region annexe-valider
  void _enregistrer() {
    // validate() appelle tous les validateurs et affiche leurs messages ;
    // il renvoie false si l'un d'eux a renvoyé un texte.
    if (!_cle.currentState!.validate()) return;
    Navigator.of(context).pop(
      Inscription(
        nom: _nom.text.trim(),
        courriel: _courriel.text.trim(),
        niveau: _niveau,
        date: _date,
      ),
    );
  }
  // endregion annexe-valider

  @override
  Widget build(BuildContext context) {
    final date = _date;
    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      // region annexe-formulaire-champs
      body: Form(
        key: _cle,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nom,
              decoration: const InputDecoration(labelText: 'Nom'),
              validator: validerNom,
              textInputAction: TextInputAction.next,
            ),
            TextFormField(
              controller: _courriel,
              decoration: const InputDecoration(labelText: 'Courriel'),
              keyboardType: TextInputType.emailAddress,
              validator: validerCourriel,
            ),
            DropdownButtonFormField<Niveau>(
              initialValue: _niveau,
              decoration: const InputDecoration(labelText: 'Niveau'),
              items: [
                for (final n in Niveau.values)
                  DropdownMenuItem(value: n, child: Text(n.libelle)),
              ],
              onChanged: (n) => setState(() => _niveau = n ?? _niveau),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                date == null
                    ? 'Date souhaitée : indifférente'
                    : 'Date souhaitée : ${date.day}/${date.month}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_month),
                tooltip: 'Choisir une date',
                onPressed: _choisirDate,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _enregistrer,
              child: const Text('S\'inscrire'),
            ),
          ],
        ),
      ),
      // endregion annexe-formulaire-champs
    );
  }
}

// La liste des inscriptions, qui ouvre le formulaire et attend son résultat.
class PageInscriptions extends StatefulWidget {
  const PageInscriptions({super.key});

  @override
  State<PageInscriptions> createState() => _PageInscriptionsState();
}

class _PageInscriptionsState extends State<PageInscriptions> {
  final List<Inscription> _inscriptions = [];

  Future<void> _nouvelle() async {
    final inscription = await Navigator.of(context).push<Inscription>(
      MaterialPageRoute(builder: (_) => const FormulaireInscription()),
    );
    if (!mounted || inscription == null) return;
    setState(() => _inscriptions.add(inscription));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Atelier Flutter')),
      body: _inscriptions.isEmpty
          ? const Center(child: Text('Aucune inscription pour le moment'))
          : ListView(
              children: [
                for (final i in _inscriptions)
                  ListTile(
                    title: Text(i.nom),
                    subtitle: Text('${i.courriel} · ${i.niveau.libelle}'),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _nouvelle,
        tooltip: 'Nouvelle inscription',
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
