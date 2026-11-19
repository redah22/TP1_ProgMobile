import 'package:flutter/material.dart';

import '../donnees/catalogue.dart';
import '../modele/biblio.dart';
import '../widgets/carte_livre.dart';
import 'detail_livre.dart';

/// Écran principal. Il possède un état qui change pendant l'exécution
/// (les favoris, le filtre) : c'est un StatefulWidget.
class ListeLivres extends StatefulWidget {
  const ListeLivres({super.key});

  @override
  State<ListeLivres> createState() => _ListeLivresState();
}

class _ListeLivresState extends State<ListeLivres> {
  // L'état vit dans l'objet State, qui survit aux reconstructions.
  final Set<Livre> _favoris = {};
  bool _favorisSeulement = false;

  void _basculerFavori(Livre livre) {
    setState(() {
      if (!_favoris.remove(livre)) _favoris.add(livre);
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibles = [
      for (final livre in catalogue)
        if (!_favorisSeulement || _favoris.contains(livre)) livre,
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Ma bibliothèque')),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Favoris uniquement'),
            value: _favorisSeulement,
            onChanged: (v) => setState(() => _favorisSeulement = v),
          ),
          if (periode(visibles) case (:final debut, :final fin))
            Text('${visibles.length} livre(s), publiés de $debut à $fin'),
          Expanded(
            child: ListView.builder(
              itemCount: visibles.length,
              itemBuilder: (context, i) {
                final livre = visibles[i];
                return CarteLivre(
                  livre: livre,
                  favori: _favoris.contains(livre),
                  onFavori: () => _basculerFavori(livre),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => DetailLivre(livre: livre),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
