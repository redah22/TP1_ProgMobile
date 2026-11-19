// HAI912I · CM 01 — exemple du cours : une petite bibliothèque personnelle.
//
// Point d'entrée : runApp() attache la racine de l'arbre de widgets à
// l'écran. Tout le reste est une composition de widgets.
import 'package:flutter/material.dart';

import 'ecrans/liste_livres.dart';

void main() => runApp(const BiblioApp());

class BiblioApp extends StatelessWidget {
  const BiblioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ma bibliothèque',
      debugShowCheckedModeBanner: false,
      // Material 3 est le défaut et tout le thème dérive d'une couleur.
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.indigo)),
      home: const ListeLivres(),
    );
  }
}
