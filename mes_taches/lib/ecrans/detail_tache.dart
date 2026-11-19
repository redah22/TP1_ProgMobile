import 'package:flutter/material.dart';

import '../modele/taches.dart';

/// Écran de détail d'une tâche.
/// Il reçoit sa [tache] en paramètre et peut renvoyer une tâche modifiée
/// au parent via Navigator.pop(tacheModifiee).
class DetailTache extends StatelessWidget {
  const DetailTache({super.key, required this.tache});

  final Tache tache;

  @override
  Widget build(BuildContext context) {
    final texte = Theme.of(context).textTheme;
    final aujourdhui = DateTime.now();
    final enRetard = estEnRetard(tache, aujourdhui: aujourdhui);

    return Scaffold(
      appBar: AppBar(title: Text(tache.titre)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre complet (sans ellipsis ici)
            Text(tache.titre, style: texte.headlineMedium),
            const SizedBox(height: 8),

            // Priorité
            Chip(label: Text(tache.priorite.libelle)),
            const SizedBox(height: 8),

            // Échéance
            Row(
              children: [
                Text(libelleEcheance(tache.echeance), style: texte.bodyLarge),
                if (enRetard)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      '(en retard)',
                      style: texte.bodyMedium?.copyWith(color: Colors.red),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Note
            Text(
              tache.note ?? 'Aucune note',
              style: texte.bodyLarge?.copyWith(
                fontStyle: tache.note == null
                    ? FontStyle.italic
                    : FontStyle.normal,
              ),
            ),
            const SizedBox(height: 16),

            // État
            Text(tache.faite ? '✓ Faite' : 'À faire', style: texte.bodyLarge),
            const SizedBox(height: 24),

            // Bouton d'action
            FilledButton.icon(
              icon: Icon(tache.faite ? Icons.undo : Icons.check),
              label: Text(
                tache.faite ? 'Marquer à faire' : 'Marquer comme faite',
              ),
              onPressed: () {
                // On renvoie la tâche modifiée au parent (D2).
                Navigator.of(context).pop(tache.copyWith(faite: !tache.faite));
              },
            ),
          ],
        ),
      ),
    );
  }
}
