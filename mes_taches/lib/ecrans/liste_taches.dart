import 'dart:convert';

import 'package:flutter/material.dart';

import '../donnees/exemples.dart';
import '../modele/taches.dart';
import '../widgets/tuile_tache.dart';
import 'detail_tache.dart';
import 'formulaire_tache.dart';

/// Écran principal : liste des tâches avec filtre et compteur.
/// C'est un StatefulWidget car son état change pendant l'exécution.
class ListeTaches extends StatefulWidget {
  const ListeTaches({super.key});

  @override
  State<ListeTaches> createState() => _ListeTachesState();
}

/// Les valeurs possibles du filtre.
enum Filtre { toutes, aFaireSeulement, faitesSeulement }

class _ListeTachesState extends State<ListeTaches> {
  // ── État de l'écran ────────────────────────────────────────────────────────
  late List<Tache> _taches;
  Filtre _filtre = Filtre.toutes;

  @override
  void initState() {
    super.initState();
    // Lecture des données d'exemple au démarrage
    final liste = jsonDecode(tachesExempleJson) as List<dynamic>;
    _taches = [
      for (final item in liste) tacheDepuisJson(item as Map<String, Object?>),
    ];
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  List<Tache> get _tachesVisibles => switch (_filtre) {
    Filtre.toutes => _taches,
    Filtre.aFaireSeulement => [
      for (final t in _taches)
        if (!t.faite) t,
    ],
    Filtre.faitesSeulement => [
      for (final t in _taches)
        if (t.faite) t,
    ],
  };

  int get _nbAFaire => _taches.where((t) => !t.faite).length;

  /// Remplace la tâche d'identifiant [id] par [nouvelleVersion].
  void _remplacerTache(String id, Tache nouvelleVersion) {
    setState(() {
      _taches = [for (final t in _taches) (t.id == id ? nouvelleVersion : t)];
    });
  }

  Future<void> _ouvrirDetail(Tache tache) async {
    // On attend un éventuel résultat (tâche modifiée) renvoyé par le détail.
    final modifiee = await Navigator.of(context).push<Tache>(
      MaterialPageRoute<Tache>(builder: (_) => DetailTache(tache: tache)),
    );
    // Vérification mounted obligatoire après un await (CM 01, cycle de vie).
    if (modifiee != null && mounted) {
      _remplacerTache(modifiee.id, modifiee);
    }
  }

  Future<void> _ouvrirFormulaire() async {
    final nouvelle = await Navigator.of(context).push<Tache>(
      MaterialPageRoute<Tache>(builder: (_) => const FormulaireTache()),
    );
    if (nouvelle != null && mounted) {
      setState(() => _taches = [..._taches, nouvelle]);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final visibles = _tachesVisibles;
    final aujourdhui = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: const Text('Mes tâches')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              // En-tête fixe : compteur + filtre
              _Entete(
                nbAFaire: _nbAFaire,
                filtre: _filtre,
                onFiltreChange: (f) => setState(() => _filtre = f),
              ),
              const SizedBox(height: 8),
              // Corps : liste ou message si vide
              Expanded(
                child: visibles.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.task_alt,
                              size: 56,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              switch (_filtre) {
                                Filtre.toutes => 'Aucune tâche',
                                Filtre.aFaireSeulement =>
                                  'Aucune tâche à faire',
                                Filtre.faitesSeulement => 'Aucune tâche faite',
                              },
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: visibles.length,
                        itemBuilder: (context, i) {
                          final tache = visibles[i];
                          return TuileTache(
                            tache: tache,
                            aujourdhui: aujourdhui,
                            onCocher: () => _remplacerTache(
                              tache.id,
                              tache.copyWith(faite: !tache.faite),
                            ),
                            onOuvrir: () => _ouvrirDetail(tache),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _ouvrirFormulaire,
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle tâche'),
      ),
    );
  }
}

/// En-tête fixe : compteur « n à faire » + sélecteur de filtre.
class _Entete extends StatelessWidget {
  const _Entete({
    required this.nbAFaire,
    required this.filtre,
    required this.onFiltreChange,
  });

  final int nbAFaire;
  final Filtre filtre;
  final ValueChanged<Filtre> onFiltreChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Statut des tâches',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$nbAFaire à faire',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<Filtre>(
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
                segments: const [
                  ButtonSegment(
                    value: Filtre.toutes,
                    label: Text('Toutes'),
                    icon: Icon(Icons.list),
                  ),
                  ButtonSegment(
                    value: Filtre.aFaireSeulement,
                    label: Text('À faire'),
                    icon: Icon(Icons.radio_button_unchecked),
                  ),
                  ButtonSegment(
                    value: Filtre.faitesSeulement,
                    label: Text('Faites'),
                    icon: Icon(Icons.check_circle_outline),
                  ),
                ],
                selected: {filtre},
                onSelectionChanged: (s) => onFiltreChange(s.first),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
