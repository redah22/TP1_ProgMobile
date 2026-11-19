/// Modèle de domaine de l'exemple du CM 01 (HAI912I, 2026-2027).
///
/// Une petite bibliothèque personnelle : des livres, leur genre et l'état de
/// leur lecture. Ce fichier ne dépend que du SDK Dart ; l'application Flutter
/// de démonstration (biblio_flutter) en reprend une copie conforme.
library;

/// Genre d'un livre. Un `enum` « enrichi » peut porter des champs, un
/// constructeur `const` et des méthodes.
enum Genre {
  roman('Roman'),
  scienceFiction('Science-fiction'),
  policier('Policier'),
  essai('Essai');

  const Genre(this.libelle);

  final String libelle;

  bool get estFiction => this != Genre.essai;
}

/// Un livre est une valeur immuable : tous ses champs sont `final`, et son
/// constructeur est `const`.
class Livre {
  const Livre({
    required this.titre,
    required this.auteur,
    required this.annee,
    required this.genre,
    this.serie, // facultatif : null par défaut
    this.lecture = const NonCommencee(),
  });

  final String titre;
  final String auteur;
  final int annee;
  final Genre genre;
  final String? serie;
  final Lecture lecture;

  /// Construit un livre depuis un document JSON déjà décodé.
  ///
  /// Le `switch` sur un motif de map vérifie EN MÊME TEMPS la présence des
  /// clés et leur type : un document mal formé est rejeté explicitement, au
  /// lieu de provoquer une erreur plus loin dans l'application.
  factory Livre.fromJson(Map<String, Object?> json) => switch (json) {
    {
      'titre': String t,
      'auteur': String a,
      'annee': int an,
      'genre': String g,
    } =>
      Livre(titre: t, auteur: a, annee: an, genre: Genre.values.byName(g)),
    _ => throw FormatException('Livre mal formé : $json'),
  };

  @override
  String toString() => '$titre ($auteur, $annee)';
}

/// Où en est la lecture d'un livre. Une hiérarchie `sealed` est fermée : le
/// compilateur connaît toutes ses sous-classes et vérifie qu'un `switch` les
/// traite.
sealed class Lecture {
  const Lecture();
}

final class NonCommencee extends Lecture {
  const NonCommencee();
}

final class EnCours extends Lecture {
  const EnCours({required this.page, required this.pages});

  final int page;
  final int pages;
}

final class Terminee extends Lecture {
  const Terminee({required this.note}); // note sur 5

  final int note;
}

/// Texte affichable pour l'état d'une lecture. Ajouter une sous-classe à
/// `Lecture` sans compléter ce `switch` est une ERREUR de compilation, et non
/// un oubli découvert à l'exécution.
String decrire(Lecture lecture) => switch (lecture) {
  NonCommencee() => 'à lire',
  EnCours(:final page, :final pages) => 'page $page sur $pages',
  Terminee(:final note) => 'lu, noté $note/5',
};

/// Années de publication extrêmes d'une sélection. Un *record* renvoie
/// plusieurs valeurs nommées sans déclarer de classe ; le `?` final signale
/// qu'une sélection vide donne `null`.
({int debut, int fin})? periode(Iterable<Livre> livres) {
  if (livres.isEmpty) return null;
  final annees = livres.map((l) => l.annee);
  return (
    debut: annees.reduce((a, b) => a < b ? a : b),
    fin: annees.reduce((a, b) => a > b ? a : b),
  );
}
