# biblio_flutter — exemple du CM 01 (HAI912I)
« Ma bibliothèque » : six livres fictifs, des favoris, un filtre « Favoris uniquement », un écran de détail.
Les données sont codés en dur ici, mais le CM 02 montrera comment les obtenir d'un service web, derrière un dépôt, sans changer les écrans.

| Fichier                        | Ce qu'il montre                                                                                                     | Diapositives du CM 01      |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `lib/main.dart`                | `runApp`, `MaterialApp`, thème Material 3 dérivé d'une couleur                                                      | 22                         |
| `lib/modele/biblio.dart`       | le modèle Dart                                                                                                      | 13 à 19                    |
| `lib/widgets/carte_livre.dart` | un `StatelessWidget` réutilisable (callbacks reçus du parent)                                                       | 24                         |
| `lib/ecrans/liste_livres.dart` | un `StatefulWidget`, `setState`, collection-for/if, record + `if-case`, `Expanded` + `ListView.builder`, navigation | 14, 16, 18, 23, 25, 27, 28 |
| `lib/ecrans/detail_livre.dart` | un écran qui reçoit ses données ; `if-case` sur un `String?` et sur la classe scellée                               | 28                         |
| `test/widget_test.dart`        | quatre tests de widgets                                                                                             | 29                         |

## Lancer
Prérequis : Flutter **3.47 ou plus récent** (Dart 3.13) et Google Chrome.
Les dossiers de plateforme (`web/`, `android/`…) ne sont pas fournis et se régénèrent en une commande, sans toucher à `lib/`.
Copiez d'abord le dossier dans un chemin **court et sans accents** (par exemple `C:\dev\biblio_flutter`).
Sous Windows, avec Flutter 3.47 :

- un chemin de plus de 200 caractères environ fait échouer `flutter run`, `flutter build` et même `flutter test`.
- un chemin qui contient une lettre accentuée fait planter `flutter analyze`, alors que `dart analyze` fait la même analyse et fonctionne.

Si `flutter test` a déjà échoué ainsi, supprimez le dossier `build/` après avoir déplacé le projet.

```
flutter create --platforms=web,android .
flutter run -d chrome
```

Pendant l'exécution : `r` recharge à chaud (l'état est conservé), `R`
redémarre (l'état est perdu), `q` quitte.

## Vérifier

```
flutter analyze
flutter test
```

Les deux commandes doivent se terminer sans erreur.
