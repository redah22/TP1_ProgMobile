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
    final theme = Theme.of(context);
    final texte = theme.textTheme;
    final aujourdhui = DateTime.now();
    final enRetard = estEnRetard(tache, aujourdhui: aujourdhui);

    final (colorPrio, iconPrio) = switch (tache.priorite) {
      Priorite.haute => (Colors.deepOrange, Icons.keyboard_double_arrow_up),
      Priorite.normale => (Colors.blueGrey, Icons.remove),
      Priorite.basse => (Colors.teal, Icons.keyboard_double_arrow_down),
    };

    return Scaffold(
      appBar: AppBar(title: Text(tache.titre)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Carte principale
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Titre
                      Text(
                        tache.titre,
                        style: texte.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                          decoration: tache.faite
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Statut + Priorité
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: tache.faite
                                  ? Colors.green.shade50
                                  : Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: tache.faite
                                    ? Colors.green.shade300
                                    : Colors.blue.shade200,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  tache.faite
                                      ? Icons.check_circle
                                      : Icons.pending,
                                  size: 16,
                                  color: tache.faite
                                      ? Colors.green.shade700
                                      : Colors.blue.shade700,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  tache.faite ? '✓ Faite' : 'À faire',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: tache.faite
                                        ? Colors.green.shade700
                                        : Colors.blue.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: colorPrio.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: colorPrio.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(iconPrio, size: 16, color: colorPrio),
                                const SizedBox(width: 6),
                                Text(
                                  tache.priorite.libelle,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: colorPrio,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),

                      // Échéance
                      Row(
                        children: [
                          Icon(
                            enRetard
                                ? Icons.warning_amber_rounded
                                : Icons.calendar_today,
                            size: 20,
                            color: enRetard
                                ? theme.colorScheme.error
                                : const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            libelleEcheance(tache.echeance),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: enRetard
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: enRetard
                                  ? theme.colorScheme.error
                                  : const Color(0xFF334155),
                            ),
                          ),
                          if (enRetard)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.error.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '(en retard)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Note
                      const Text(
                        'Note :',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          tache.note ?? 'Aucune note',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: tache.note == null
                                ? FontStyle.italic
                                : FontStyle.normal,
                            color: tache.note == null
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF334155),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Bouton d'action
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(tache.faite ? Icons.undo : Icons.check),
                    label: Text(
                      tache.faite ? 'Marquer à faire' : 'Marquer comme faite',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pop(tache.copyWith(faite: !tache.faite));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
