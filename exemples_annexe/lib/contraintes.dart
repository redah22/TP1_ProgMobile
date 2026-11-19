// Une liste défilante sous un en-tête, et des textes trop longs pour leur place.
import 'package:flutter/material.dart';

const participants = [
  'Ada Lovelace',
  'Grace Hopper',
  'Alan Turing',
  'Barbara Liskov',
  'Edsger Wybe Dijkstra, qui a un nom bien trop long pour une seule ligne',
  'Margaret Hamilton',
  'Donald Knuth',
  'Frances Allen',
];

class ListeParticipants extends StatelessWidget {
  const ListeParticipants({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Participants')),
      // region annexe-contraintes
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // L'en-tête prend la hauteur de son texte.
          const Padding(padding: EdgeInsets.all(16), child: Text('8 inscrits')),
          // Sans Expanded, la ListView recevrait une hauteur NON BORNÉE
          // de la Column et on obtiendrait l'erreur « Vertical viewport was given unbounded
          // height ». Expanded lui donne exactement l'espace restant.
          Expanded(
            child: ListView.builder(
              itemCount: participants.length,
              itemBuilder: (context, i) => ListTile(
                leading: CircleAvatar(child: Text(participants[i][0])),
                // Une ligne au plus, puis « ... », donc pas de débordement,
                // quelle que soit la largeur de l'écran.
                title: Text(
                  participants[i],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
      // endregion annexe-contraintes
    );
  }
}
