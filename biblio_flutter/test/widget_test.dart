// Tests de widgets de l'exemple du cours : on construit l'application dans
// un environnement de test, on agit (tap), on reconstruit (pump), on vérifie.
import 'package:biblio_flutter/ecrans/detail_livre.dart';
import 'package:biblio_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('la liste affiche les livres et leur période', (tester) async {
    await tester.pumpWidget(const BiblioApp());

    expect(find.text('Dune'), findsOneWidget);
    expect(find.text('6 livre(s), publiés de 1942 à 2011'), findsOneWidget);
  });

  testWidgets('toucher le cœur ajoute un favori (setState)', (tester) async {
    await tester.pumpWidget(const BiblioApp());
    expect(find.byIcon(Icons.favorite), findsNothing);

    await tester.tap(find.byIcon(Icons.favorite_border).first);
    await tester.pump();

    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });

  testWidgets('le filtre ne garde que les favoris', (tester) async {
    await tester.pumpWidget(const BiblioApp());

    await tester.tap(find.byIcon(Icons.favorite_border).first); // Dune
    await tester.tap(find.byType(Switch));
    await tester.pump();

    expect(find.text('Dune'), findsOneWidget);
    expect(find.text('Fondation'), findsNothing);
    expect(find.text('1 livre(s), publiés de 1965 à 1965'), findsOneWidget);
  });

  testWidgets('toucher un livre ouvre son détail', (tester) async {
    await tester.pumpWidget(const BiblioApp());

    await tester.tap(find.text('Dune'));
    await tester.pumpAndSettle(); // laisse finir l'animation de transition

    expect(find.byType(DetailLivre), findsOneWidget);
    expect(find.text('Série : Le Cycle de Dune'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });
}
