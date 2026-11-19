// « Mes tâches », un gestionnaire de tâches personnel — HAI912I TP1.
// Point d'entrée : runApp() attache la racine de l'arbre de widgets à l'écran.
import 'package:flutter/material.dart';

import 'ecrans/liste_taches.dart';

void main() => runApp(const MesTachesApp());

class MesTachesApp extends StatelessWidget {
  const MesTachesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mes tâches',
      debugShowCheckedModeBanner: false,
      // Material 3 : tout le thème dérive d'une couleur seed.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const ListeTaches(), // B1 : écran principal
    );
  }
}
