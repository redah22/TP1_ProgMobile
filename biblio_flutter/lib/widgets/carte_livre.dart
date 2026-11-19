import 'package:flutter/material.dart';

import '../modele/biblio.dart';

/// Un widget réutilisable : il ne possède aucun état, il affiche ce qu'on
/// lui donne. Toute l'information arrive par le constructeur.
class CarteLivre extends StatelessWidget {
  const CarteLivre({
    super.key,
    required this.livre,
    required this.favori,
    this.onTap,
    this.onFavori,
  });

  final Livre livre;
  final bool favori;
  final VoidCallback? onTap;
  final VoidCallback? onFavori;

  @override
  Widget build(BuildContext context) {
    final etat = decrire(livre.lecture);
    final coeur = favori ? Icons.favorite : Icons.favorite_border;
    return Card(
      child: ListTile(
        leading: Icon(switch (livre.genre) {
          Genre.roman => Icons.menu_book,
          Genre.scienceFiction => Icons.rocket_launch,
          Genre.policier => Icons.search,
          Genre.essai => Icons.lightbulb,
        }),
        title: Text(livre.titre),
        subtitle: Text('${livre.auteur} · $etat'),
        trailing: IconButton(
          icon: Icon(coeur),
          tooltip: 'Favori',
          onPressed: onFavori,
        ),
        onTap: onTap,
      ),
    );
  }
}
