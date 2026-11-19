// Un petit catalogue de démonstrations (inscriptions à un atelier, choix d'une couleur).
import 'package:flutter/material.dart';

import 'contraintes.dart';
import 'formulaire.dart';
import 'navigation.dart';

void main() => runApp(const ExemplesAnnexe());

class ExemplesAnnexe extends StatelessWidget {
  const ExemplesAnnexe({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemples de l\'annexe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.indigo)),
      home: const Sommaire(),
    );
  }
}

/// L'écran d'accueil : une entrée par démonstration.
class Sommaire extends StatelessWidget {
  const Sommaire({super.key});

  @override
  Widget build(BuildContext context) {
    void ouvrir(Widget ecran) =>
        Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (_) => ecran));

    return Scaffold(
      appBar: AppBar(title: const Text('Exemples de l\'annexe')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.view_agenda),
            title: const Text('Contraintes : une liste sous un en-tête'),
            onTap: () => ouvrir(const ListeParticipants()),
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Navigation : rapporter un résultat'),
            onTap: () => ouvrir(const ApercuCouleur()),
          ),
          ListTile(
            leading: const Icon(Icons.edit_note),
            title: const Text('Formulaire : s\'inscrire à un atelier'),
            onTap: () => ouvrir(const PageInscriptions()),
          ),
        ],
      ),
    );
  }
}
