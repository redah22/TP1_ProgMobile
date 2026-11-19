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

  /// La date d'aujourd'hui, calculée par le parent, pour permettre les tests
  /// avec une date fixe (C2 — indice du sujet).
  final DateTime aujourdhui;

  final VoidCallback? onCocher;
  final VoidCallback? onOuvrir;

  @override
  Widget build(BuildContext context) {
    final enRetard = estEnRetard(tache, aujourdhui: aujourdhui);
    final couleurEcheance = enRetard
        ? Theme.of(context).colorScheme.error
        : null;

    final indicateurPrio = switch (tache.priorite) {
      Priorite.haute => Icons.keyboard_double_arrow_up,
      Priorite.normale => Icons.remove,
      Priorite.basse => Icons.keyboard_double_arrow_down,
    };

    return Card(
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: tache.faite,
              onChanged: onCocher != null ? (_) => onCocher!() : null,
            ),
            Icon(indicateurPrio, size: 18),
          ],
        ),
        title: Text(
          tache.titre,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: tache.faite
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null,
        ),
        subtitle: Text(
          libelleEcheance(tache.echeance),
          style: couleurEcheance != null
              ? TextStyle(color: couleurEcheance)
              : null,
        ),
        onTap: onOuvrir,
      ),
    );
  }
}
