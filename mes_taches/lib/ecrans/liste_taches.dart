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
      body: Column(
        children: [
          // En-tête fixe : compteur + filtre
          _Entete(
            nbAFaire: _nbAFaire,
            filtre: _filtre,
            onFiltreChange: (f) => setState(() => _filtre = f),
          ),
          // Corps : liste ou message si vide
          Expanded(
            child: visibles.isEmpty
                ? Center(
                    child: Text(switch (_filtre) {
                      Filtre.toutes => 'Aucune tâche',
                      Filtre.aFaireSeulement => 'Aucune tâche à faire',
                      Filtre.faitesSeulement => 'Aucune tâche faite',
                    }, style: Theme.of(context).textTheme.bodyLarge),
                  )
                : ListView.builder(
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
      floatingActionButton: FloatingActionButton(
        onPressed: _ouvrirFormulaire,
        tooltip: 'Ajouter',
        child: const Icon(Icons.add),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Text(
            '$nbAFaire à faire',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          SegmentedButton<Filtre>(
            segments: const [
              ButtonSegment(value: Filtre.toutes, label: Text('Toutes')),
              ButtonSegment(
                value: Filtre.aFaireSeulement,
                label: Text('À faire'),
              ),
              ButtonSegment(
                value: Filtre.faitesSeulement,
                label: Text('Faites'),
              ),
            ],
            selected: {filtre},
            onSelectionChanged: (s) => onFiltreChange(s.first),
          ),
        ],
      ),
    );
  }
}
