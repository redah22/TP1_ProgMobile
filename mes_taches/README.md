# HAI912I — TP 1 : Fondamentaux de Dart et Flutter

Application « **Mes tâches** », un gestionnaire de tâches personnel réalisé dans le cadre de l'UE **HAI912I** (Développement mobile avancé, IoT et embarqué — Master 2, 2026–2027).

---

## 1. Description du projet

L'application permet de gérer une liste de tâches personnelles en mémoire :
- **Affichage et compteur :** Consultation des tâches avec indicateur de priorité, échéance et compteur dynamique « *n* à faire ».
- **Filtrage :** Sélecteur à trois vues (« Toutes », « À faire », « Faites »).
- **Interactions :** Cocher/décocher une tâche depuis la liste ou son écran de détail (mise à jour immédiate).
- **Navigation :** Consultation détaillée d'une tâche avec calcul dynamique des retards.
- **Formulaire validé :** Création d'une nouvelle tâche avec validation (titre obligatoire ≤ 60 car., note facultative ≤ 200 car., échéance datée non passée).
- **Architecture & Immuabilité :** Modèle Dart pur sans dépendance d'interface, instances immuables via `copyWith`, séparation stricte entre état et composants de présentation sans état (`StatelessWidget`).

---

## 2. Structure du projet

```text
mes_taches/
├── lib/
│   ├── main.dart                 # Point d'entrée de l'application et configuration du thème
│   ├── donnees/
│   │   └── exemples.dart         # Données d'exemple fournies au format JSON
│   ├── modele/
│   │   └── taches.dart           # Modèle de domaine : Priorite, Echeance (sealed), Tache (immuable)
│   ├── widgets/
│   │   └── tuile_tache.dart      # Tuile de tâche réutilisable et sans état (StatelessWidget)
│   └── ecrans/
│       ├── liste_taches.dart     # Écran principal avec état local (StatefulWidget), filtre et compteur
│       ├── detail_tache.dart     # Écran de consultation détaillée et action
│       └── formulaire_tache.dart # Formulaire de création avec validation
├── test/
│   └── widget_test.dart          # 32 tests unitaires (modèle Dart) et de widgets (UI & interactions)
├── analysis_options.yaml         # Configuration des règles de qualité et du linter officiel
└── pubspec.yaml                  # Métadonnées et dépendances du projet
```

---

## 3. Prérequis et Environnement

- **Flutter SDK :** version 3.47+ (testé avec Flutter 3.50.0 stable, Dart 3.14.0)
- **Google Chrome** (pour l'exécution Web)
- macOS (Apple Silicon ARM64 / Intel) ou Linux / Windows

---

## 4. Démarrage rapide

### Installation des dépendances
```bash
cd mes_taches
flutter pub get
```

### Lancement de l'application (Cible Web Chrome)
```bash
flutter run -d chrome
```
*Astuce lors de l'exécution : tapez `r` dans le terminal pour déclencher le **Hot Reload**, ou `R` pour le **Hot Restart**.*

---

## 5. Qualité du code et Tests

### Analyse statique (0 avertissement attendu)
```bash
flutter analyze
```

### Formatage officiel du code
```bash
dart format lib test
```

### Exécution des tests unitaires et de widgets
Tous les tests (32 tests au total) doivent être au vert :
```bash
flutter test
```

### Compilation Web de production
```bash
flutter build web
```

---

## 6. Récapitulatif des parties implémentées

- [x] **Partie A : Modèle de « Mes tâches »**
  - Enum `Priorite`, classes scellées `Echeance`, classe immuable `Tache`.
  - Fonctions : `prioriteDepuisCode`, `tacheDepuisJson`, `libelleEcheance`, `estEnRetard`, `bilan`, `aFaire`.
- [x] **Partie B : Premières interactions**
  - Chargement du JSON, affichage de la liste, compteur global et bascule d'état immuable via `setState`.
- [x] **Partie C : Composition de l'écran principal**
  - Filtrage à 3 états, composant `TuileTache` réutilisable sans état, mise en page sans débordement (360px–1280px).
- [x] **Partie D : Navigation entre les écrans**
  - Écran `DetailTache`, transmission de données, retour de résultat via `Navigator.pop`.
- [x] **Partie E : Formulaire de création**
  - `FormulaireTache` avec contrôleurs, date picker, validation des règles métiers et assignation d'un identifiant unique.
- [x] **Partie F : Tests et qualité**
  - Suite de tests complète (`test/widget_test.dart`), 0 avertissement `flutter analyze`, code formaté avec `dart format`.
