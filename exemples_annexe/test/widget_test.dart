// Tests des exemples de l'annexe.
// Ils montrent les gestes de base d'un test de widget
// (pumpWidget, find, tap, enterText, pump, pumpAndSettle).
import 'package:exemples_annexe/contraintes.dart';
import 'package:exemples_annexe/formulaire.dart';
import 'package:exemples_annexe/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Monte un écran seul, dans un MaterialApp (thème, Navigator, textes).
Widget enApp(Widget ecran) => MaterialApp(home: ecran);

void main() {
  // region annexe-test-validateurs
  test('les validateurs sont des fonctions ordinaires', () {
    expect(validerNom('   '), 'Le nom est obligatoire');
    expect(validerNom('Ada'), isNull);
    expect(validerCourriel('ada@exemple.fr'), isNull);
    expect(validerCourriel('ada@'), 'Adresse invalide');
  });
  // endregion annexe-test-validateurs

  // region annexe-test-formulaire
  testWidgets('un formulaire vide affiche les erreurs et reste ouvert', (
    tester,
  ) async {
    await tester.pumpWidget(enApp(const PageInscriptions()));
    await tester.tap(find.byTooltip('Nouvelle inscription'));
    await tester.pumpAndSettle(); // attendre la fin de l'animation de push

    await tester.tap(find.text('S\'inscrire'));
    await tester.pump(); // reconstruire avec les messages d'erreur

    expect(find.text('Le nom est obligatoire'), findsOneWidget);
    expect(find.text('Adresse invalide'), findsOneWidget);
    expect(find.text('Inscription'), findsOneWidget); // toujours affiché
  });

  testWidgets('une saisie valide revient à la liste et l\'enrichit', (
    tester,
  ) async {
    await tester.pumpWidget(enApp(const PageInscriptions()));
    await tester.tap(find.byTooltip('Nouvelle inscription'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Nom'), 'Ada');
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Courriel'),
      'ada@exemple.fr',
    );
    await tester.tap(find.text('S\'inscrire'));
    await tester.pumpAndSettle(); // animation de pop

    expect(find.text('Ada'), findsOneWidget);
    expect(find.text('Aucune inscription pour le moment'), findsNothing);
  });
  // endregion annexe-test-formulaire

  testWidgets('les deux techniques de navigation rapportent la couleur', (
    tester,
  ) async {
    await tester.pumpWidget(enApp(const ApercuCouleur()));
    expect(find.text('Couleur : aucune'), findsOneWidget);

    await tester.tap(find.text('Choisir (valeur de retour)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sarcelle'));
    await tester.pumpAndSettle();
    expect(find.text('Couleur : Sarcelle'), findsOneWidget);

    await tester.tap(find.text('Choisir (fonction de rappel)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ambre'));
    await tester.pumpAndSettle();
    expect(find.text('Couleur : Ambre'), findsOneWidget);
  });

  testWidgets('retour sans choisir : rien ne change', (tester) async {
    await tester.pumpWidget(enApp(const ApercuCouleur()));
    await tester.tap(find.text('Choisir (valeur de retour)'));
    await tester.pumpAndSettle();
    await tester.pageBack(); // bouton « retour » de l'AppBar
    await tester.pumpAndSettle();
    expect(find.text('Couleur : aucune'), findsOneWidget);
  });

  // region annexe-test-largeur
  testWidgets('aucun débordement sur un écran étroit (320 px)', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset); // rendre la taille par défaut ensuite

    await tester.pumpWidget(enApp(const ListeParticipants()));
    // Un débordement (bandes jaunes et noires) lève une exception que le
    // test récupère ici (il n'y en a aucune).
    expect(tester.takeException(), isNull);
    expect(find.textContaining('Edsger'), findsOneWidget);
  });
  // endregion annexe-test-largeur
}
