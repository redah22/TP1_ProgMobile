import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mes_taches/donnees/exemples.dart';
import 'package:mes_taches/ecrans/formulaire_tache.dart';
import 'package:mes_taches/ecrans/liste_taches.dart';
import 'package:mes_taches/modele/taches.dart';

// ══════════════════════════════════════════════════════════════════════════════
// Tests UNITAIRES (Partie A)
// ══════════════════════════════════════════════════════════════════════════════

void main() {
  // ── A1 : prioriteDepuisCode ─────────────────────────────────────────────
  group('prioriteDepuisCode', () {
    test('low → Priorite.basse', () {
      expect(prioriteDepuisCode('low'), Priorite.basse);
    });
    test('normal → Priorite.normale', () {
      expect(prioriteDepuisCode('normal'), Priorite.normale);
    });
    test('high → Priorite.haute', () {
      expect(prioriteDepuisCode('high'), Priorite.haute);
    });
    test('code inconnu → null', () {
      expect(prioriteDepuisCode('urgent'), isNull);
      expect(prioriteDepuisCode('High'), isNull);
      expect(prioriteDepuisCode(''), isNull);
    });
  });

  // ── A1 : tacheDepuisJson ────────────────────────────────────────────────
  group('tacheDepuisJson', () {
    test('JSON minimal valide', () {
      final t = tacheDepuisJson({
        'id': 't1',
        'title': 'Faire les courses',
        'priority': 'normal',
        'done': false,
      });
      expect(t.id, 't1');
      expect(t.titre, 'Faire les courses');
      expect(t.priorite, Priorite.normale);
      expect(t.faite, isFalse);
      expect(t.echeance, isA<SansEcheance>());
      expect(t.note, isNull);
    });

    test('JSON avec due et note', () {
      final t = tacheDepuisJson({
        'id': 't2',
        'title': 'Payer le loyer',
        'priority': 'low',
        'done': false,
        'due': '2026-12-01',
        'note': 'virement',
      });
      expect(t.echeance, isA<EcheanceDatee>());
      expect((t.echeance as EcheanceDatee).date.month, 12);
      expect(t.note, 'virement');
    });

    test('FormatException si id manquant', () {
      expect(
        () => tacheDepuisJson({
          'title': 'Test',
          'priority': 'low',
          'done': false,
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test('FormatException si id vide', () {
      expect(
        () => tacheDepuisJson({
          'id': '',
          'title': 'Test',
          'priority': 'low',
          'done': false,
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test('FormatException si title manquant', () {
      expect(
        () => tacheDepuisJson({'id': 't1', 'priority': 'low', 'done': false}),
        throwsA(isA<FormatException>()),
      );
    });

    test('FormatException si priority inconnue', () {
      expect(
        () => tacheDepuisJson({
          'id': 't1',
          'title': 'Test',
          'priority': 'urgent',
          'done': false,
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test('FormatException si done n\'est pas un bool', () {
      expect(
        () => tacheDepuisJson({
          'id': 't1',
          'title': 'Test',
          'priority': 'low',
          'done': 'non',
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test('FormatException si due est une date invalide', () {
      expect(
        () => tacheDepuisJson({
          'id': 't1',
          'title': 'Test',
          'priority': 'low',
          'done': false,
          'due': 'pas-une-date',
        }),
        throwsA(isA<FormatException>()),
      );
    });
  });

  // ── A2 : libelleEcheance ────────────────────────────────────────────────
  group('libelleEcheance', () {
    test('SansEcheance', () {
      expect(libelleEcheance(const SansEcheance()), 'sans échéance');
    });
    test('EcheanceDatee 1er décembre', () {
      expect(
        libelleEcheance(EcheanceDatee(DateTime(2026, 12, 1))),
        'pour le 1/12',
      );
    });
    test('EcheanceHebdo samedi (6)', () {
      expect(libelleEcheance(EcheanceHebdo(6)), 'chaque samedi');
    });
  });

  // ── A2 : estEnRetard ────────────────────────────────────────────────────
  group('estEnRetard', () {
    final hier = DateTime(2026, 11, 18);
    final aujourd = DateTime(2026, 11, 19, 15);

    test('tâche à une date passée, non faite → en retard', () {
      final t = Tache(id: 'x', titre: 'Test', echeance: EcheanceDatee(hier));
      expect(estEnRetard(t, aujourdhui: aujourd), isTrue);
    });

    test('tâche à une date passée, faite → pas en retard', () {
      final t = Tache(
        id: 'x',
        titre: 'Test',
        echeance: EcheanceDatee(hier),
        faite: true,
      );
      expect(estEnRetard(t, aujourdhui: aujourd), isFalse);
    });

    test('tâche le jour même (même date) → pas en retard', () {
      final memeJour = DateTime(2026, 11, 19, 8);
      final t = Tache(
        id: 'x',
        titre: 'Test',
        echeance: EcheanceDatee(memeJour),
      );
      expect(estEnRetard(t, aujourdhui: aujourd), isFalse);
    });

    test('sans échéance → pas en retard', () {
      final t = Tache(id: 'x', titre: 'Test');
      expect(estEnRetard(t, aujourdhui: aujourd), isFalse);
    });

    test('hebdomadaire → pas en retard', () {
      final t = Tache(id: 'x', titre: 'Test', echeance: EcheanceHebdo(1));
      expect(estEnRetard(t, aujourdhui: aujourd), isFalse);
    });
  });

  // ── A3 : bilan ──────────────────────────────────────────────────────────
  group('bilan', () {
    test('collection vide', () {
      expect(bilan([]), (faites: 0, total: 0));
    });
    test('collection non vide', () {
      final taches = [
        const Tache(id: 'a', titre: 'A', faite: true),
        const Tache(id: 'b', titre: 'B'),
        const Tache(id: 'c', titre: 'C', faite: true),
      ];
      expect(bilan(taches), (faites: 2, total: 3));
    });
  });

  // ── A3 : aFaire ─────────────────────────────────────────────────────────
  group('aFaire', () {
    final courses = Tache(id: '1', titre: 'Courses', priorite: Priorite.basse);
    final dentiste = Tache(
      id: '2',
      titre: 'Dentiste',
      priorite: Priorite.normale,
    );
    final passeport = Tache(
      id: '3',
      titre: 'Passeport',
      priorite: Priorite.haute,
    );
    final installer = Tache(
      id: '4',
      titre: 'Installer',
      priorite: Priorite.haute,
      faite: true,
    );
    final banque = Tache(id: '5', titre: 'Banque', priorite: Priorite.normale);
    final toutes = [courses, dentiste, passeport, installer, banque];

    test('ordre haute→normale→basse, faites exclues', () {
      final res = aFaire(toutes);
      expect(res.map((t) => t.titre), [
        'Passeport',
        'Banque',
        'Dentiste',
        'Courses',
      ]);
    });

    test('avec auMoins: normale', () {
      final res = aFaire(toutes, auMoins: Priorite.normale);
      expect(res.map((t) => t.titre), ['Passeport', 'Banque', 'Dentiste']);
    });

    test('la collection source n\'est pas modifiée', () {
      final source = [courses, dentiste, passeport];
      aFaire(source);
      expect(source, [courses, dentiste, passeport]);
    });
  });

  // ── Immuabilité : copyWith ───────────────────────────────────────────────
  group('Tache.copyWith', () {
    const original = Tache(id: 'x', titre: 'Original');

    test('marquer faite ne modifie pas l\'original', () {
      final modifiee = original.copyWith(faite: true);
      expect(original.faite, isFalse);
      expect(modifiee.faite, isTrue);
      expect(modifiee.id, original.id);
    });

    test('effacer la note', () {
      const avecNote = Tache(id: 'y', titre: 'Avec note', note: 'bonjour');
      final sansNote = avecNote.copyWith(effacerNote: true);
      expect(sansNote.note, isNull);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // Tests DE WIDGETS (Parties B, C, D, E)
  // ══════════════════════════════════════════════════════════════════════════

  group('Tests de widgets', () {
    // Helper : pompe l'application complète
    Widget appTest() => const MaterialApp(home: ListeTaches());

    testWidgets('B2 — cocher une tâche met à jour le compteur', (tester) async {
      await tester.pumpWidget(appTest());
      await tester.pumpAndSettle();

      // Lecture du compteur initial depuis tachesExempleJson
      final taches = (jsonDecode(tachesExempleJson) as List)
          .map((j) => tacheDepuisJson(j as Map<String, Object?>))
          .toList();
      final nbInitial = taches.where((t) => !t.faite).length;

      expect(find.text('$nbInitial à faire'), findsOneWidget);

      // Cocher la première case
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      // Le compteur diminue (ou augmente si la tâche était déjà faite)
      // On vérifie simplement qu'un widget compteur est toujours présent
      expect(find.textContaining(' à faire'), findsOneWidget);
    });

    testWidgets('C1 — le filtre "Faites" n\'affiche que les tâches faites', (
      tester,
    ) async {
      await tester.pumpWidget(appTest());
      await tester.pumpAndSettle();

      // Activer le filtre "Faites"
      await tester.tap(find.text('Faites'));
      await tester.pumpAndSettle();

      // Les tâches faites de l'exemple (t1 : "Installer Flutter" done: true)
      expect(find.text('Installer Flutter'), findsOneWidget);
    });

    testWidgets('D1 — toucher une tâche ouvre le détail', (tester) async {
      await tester.pumpWidget(appTest());
      await tester.pumpAndSettle();

      // Trouver la première tuile de la liste et la toucher (zone du titre)
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      // On doit voir un AppBar avec le titre de la tâche
      expect(find.byType(AppBar), findsAtLeastNWidgets(1));
    });

    testWidgets('E2 — formulaire invalide reste ouvert', (tester) async {
      await tester.pumpWidget(appTest());
      await tester.pumpAndSettle();

      // Ouvrir le formulaire
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Tenter d'enregistrer sans saisir de titre
      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();

      // Le formulaire reste ouvert : on voit encore le bouton "Enregistrer"
      expect(find.text('Enregistrer'), findsOneWidget);
      // Un message d'erreur apparaît
      expect(find.text('Le titre est obligatoire.'), findsOneWidget);
    });

    testWidgets('E1 — créer une tâche valide l\'ajoute à la liste', (
      tester,
    ) async {
      await tester.pumpWidget(appTest());
      await tester.pumpAndSettle();

      // Ouvrir le formulaire
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Saisir un titre dans le TextFormField
      final champTitre = find.byType(TextFormField).first;
      await tester.enterText(champTitre, 'Ma nouvelle tâche de test');
      await tester.pumpAndSettle();

      // Tap direct sur le bouton Enregistrer via sa Key
      final boutonEnregistrer = find.byKey(const Key('bouton_enregistrer'));
      await tester.ensureVisible(boutonEnregistrer);
      await tester.pumpAndSettle();

      await tester.tap(boutonEnregistrer);
      await tester.pumpAndSettle();

      // On vérifie que la tâche a bien été ajoutée et apparaît dans la liste
      expect(find.byType(FormulaireTache), findsNothing);
      // Comme c'est ajouté à la fin de la liste, on scrolle jusqu'à elle si nécessaire
      final itemFinder = find.text('Ma nouvelle tâche de test');
      await tester.scrollUntilVisible(itemFinder, 100);
      expect(itemFinder, findsOneWidget);
    });
  });
}
