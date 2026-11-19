import 'package:flutter/material.dart';

import '../modele/biblio.dart';

/// Deuxième écran : il reçoit ses données en paramètre et n'en possède
/// aucune. Revenir en arrière (flèche de l'AppBar) dépile la route.
class DetailLivre extends StatelessWidget {
  const DetailLivre({super.key, required this.livre});

  final Livre livre;

  @override
  Widget build(BuildContext context) {
    final texte = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(livre.titre)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(livre.titre, style: texte.headlineMedium),
            Text('${livre.auteur}, ${livre.annee}', style: texte.titleMedium),
            if (livre.serie case final serie?) Text('Série : $serie'),
            const SizedBox(height: 16),
            Chip(label: Text(livre.genre.libelle)),
            const SizedBox(height: 16),
            Text(decrire(livre.lecture), style: texte.bodyLarge),
            if (livre.lecture case EnCours(:final page, :final pages))
              LinearProgressIndicator(value: page / pages),
          ],
        ),
      ),
    );
  }
}
