# Exemples de l'annexe du TP 1

Petit projet Flutter qui accompagne l'annexe « Flutter : workflow, widgets, navigation et débogage ».
Il montre des mécanismes de base de Flutter : inscriptions à un atelier, choix d'une couleur, navigation.

| Fichier                 | Ce qu'il montre                                                         | Section de l'annexe |
| ----------------------- | ----------------------------------------------------------------------- | ------------------- |
| `lib/contraintes.dart`  | une liste défilante sous un en-tête fixe (`Expanded`), textes longs     | 2                   |
| `lib/navigation.dart`   | rapporter une information : valeur de retour ou fonction de rappel      | 4                   |
| `lib/formulaire.dart`   | `Form`, validateurs, liste déroulante, `showDatePicker`, résultat rendu | 5                   |
| `test/widget_test.dart` | tests unitaires et tests de widgets de tout ce qui précède              | 6                   |

## Lancer

Dans un dossier au chemin **court** (par exemple `C:\dev\exemples_annexe` sous Windows) :

```
flutter create --platforms=web .
flutter pub get
flutter run -d chrome
flutter test
```

Les 6 tests passent et `flutter analyze` ne signale aucun problème.