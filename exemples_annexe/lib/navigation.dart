// Faire remonter une information d'un écran vers celui qui l'a ouvert avec deux techniques à comparer.
import 'package:flutter/material.dart';

/// Les couleurs proposées, avec leur nom.
const nuancier = <(String, Color)>[
  ('Indigo', Colors.indigo),
  ('Sarcelle', Colors.teal),
  ('Ambre', Colors.amber),
];

/// L'écran qui ouvre le choix, puis affiche la couleur retenue.
class ApercuCouleur extends StatefulWidget {
  const ApercuCouleur({super.key});

  @override
  State<ApercuCouleur> createState() => _ApercuCouleurState();
}

class _ApercuCouleurState extends State<ApercuCouleur> {
  String _nom = 'aucune';
  Color _couleur = Colors.grey;

  // region annexe-navigation-resultat
  // Technique 1 : l'écran ouvert renvoie une valeur en se fermant.
  // push renvoie un Future, complété au moment du pop.
  Future<void> _choisir() async {
    final choix = await Navigator.of(context).push<(String, Color)>(
      MaterialPageRoute(builder: (_) => const ChoixCouleur()),
    );
    // Après un await, l'écran a pu être retiré (retour système, etc.).
    if (!mounted || choix == null) return; // Retour sans choisir
    final (nom, couleur) = choix;
    setState(() {
      _nom = nom;
      _couleur = couleur;
    });
  }
  // endregion annexe-navigation-resultat

  // region annexe-navigation-rappel
  // Technique 2 : on transmet une fonction au nouvel écran, qui l'appelle.
  // Pas de valeur de retour : c'est l'appelant qui décide quoi en faire.
  void _choisirParRappel() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChoixCouleur(
          onChoisie: (nom, couleur) => setState(() {
            _nom = nom;
            _couleur = couleur;
          }),
        ),
      ),
    );
  }
  // endregion annexe-navigation-rappel

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Couleur du badge')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 32, backgroundColor: _couleur),
            const SizedBox(height: 12),
            Text('Couleur : $_nom'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _choisir,
              child: const Text('Choisir (valeur de retour)'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _choisirParRappel,
              child: const Text('Choisir (fonction de rappel)'),
            ),
          ],
        ),
      ),
    );
  }
}

// L'écran ouvert ne possède rien et reçoit tout par son constructeur
// (ici, une fonction de rappel facultative).
class ChoixCouleur extends StatelessWidget {
  const ChoixCouleur({super.key, this.onChoisie});

  final void Function(String nom, Color couleur)? onChoisie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choisir une couleur')),
      body: ListView(
        children: [
          // region annexe-navigation-pop
          for (final (nom, couleur) in nuancier)
            ListTile(
              leading: CircleAvatar(backgroundColor: couleur),
              title: Text(nom),
              onTap: () {
                onChoisie?.call(nom, couleur); // technique 2
                Navigator.of(context).pop((nom, couleur)); // technique 1
              },
            ),
          // endregion annexe-navigation-pop
        ],
      ),
    );
  }
}
