import 'package:flutter/material.dart';

import '../modele/taches.dart';

/// Widget réutilisable représentant une tâche dans la liste (partie C2).
///
/// Sans état : il n'appelle jamais setState.
/// L'information descend par le constructeur ;
/// les événements remontent par les fonctions de rappel.
class TuileTache extends StatelessWidget {
  const TuileTache({
    super.key,
    required this.tache,
    required this.aujourdhui,
    this.onCocher,
    this.onOuvrir,
  });

  final Tache tache;
  final DateTime aujourdhui;
  final VoidCallback? onCocher;
  final VoidCallback? onOuvrir;

  @override
  Widget build(BuildContext context) {
    final enRetard = estEnRetard(tache, aujourdhui: aujourdhui);
    final theme = Theme.of(context);

    // Configuration des icônes et couleurs selon la priorité
    final (iconPrio, colorPrio) = switch (tache.priorite) {
      Priorite.haute => (Icons.keyboard_double_arrow_up, Colors.deepOrange),
      Priorite.normale => (Icons.remove, Colors.blueGrey),
      Priorite.basse => (Icons.keyboard_double_arrow_down, Colors.teal),
    };

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onOuvrir,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  activeColor: theme.colorScheme.primary,
                  value: tache.faite,
                  onChanged: onCocher != null ? (_) => onCocher!() : null,
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colorPrio.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(iconPrio, size: 18, color: colorPrio),
                ),
              ],
            ),
            title: Text(
              tache.titre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: tache.faite
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF1E293B),
                decoration: tache.faite
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Icon(
                    enRetard ? Icons.error_outline : Icons.schedule,
                    size: 14,
                    color: enRetard
                        ? theme.colorScheme.error
                        : const Color(0xFF64748B),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    libelleEcheance(tache.echeance),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: enRetard
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: enRetard
                          ? theme.colorScheme.error
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              size: 20,
              color: Color(0xFFCBD5E1),
            ),
          ),
        ),
      ),
    );
  }
}
