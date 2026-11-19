/// Modèle de domaine de « Mes tâches » — HAI912I, TP 1 (2026-2027).
///
/// Ce fichier ne dépend que du SDK Dart (aucun import Flutter).
/// Il exporte tous les types et fonctions du contrat public (§ 4.1 du sujet).
library;

// ─────────────────────────────────────────────────────────────────────────────
// Priorité
// ─────────────────────────────────────────────────────────────────────────────

/// Priorité d'une tâche. L'ordre de déclaration définit l'ordre naturel :
/// basse < normale < haute (Priorite.values est ordonné ainsi).
enum Priorite {
  basse('Basse'),
  normale('Normale'),
  haute('Haute');

  const Priorite(this.libelle);
  final String libelle;
}

/// Renvoie la [Priorite] désignée par [code] ('low', 'normal', 'high'),
/// ou null pour tout autre valeur (la correspondance est sensible à la casse).
Priorite? prioriteDepuisCode(String code) => switch (code) {
  'low' => Priorite.basse,
  'normal' => Priorite.normale,
  'high' => Priorite.haute,
  _ => null,
};

// ─────────────────────────────────────────────────────────────────────────────
// Échéance
// ─────────────────────────────────────────────────────────────────────────────

/// Hiérarchie scellée des échéances. Le compilateur vérifie l'exhaustivité
/// des switch (aucun `_` ni `default` requis).
sealed class Echeance {
  const Echeance();
}

/// Pas d'échéance.
final class SansEcheance extends Echeance {
  const SansEcheance();
}

/// Échéance à une date précise (seuls jour, mois et année comptent).
final class EcheanceDatee extends Echeance {
  const EcheanceDatee(this.date);
  final DateTime date;
}

/// Échéance hebdomadaire : un jour de la semaine (1 = lundi … 7 = dimanche).
final class EcheanceHebdo extends Echeance {
  EcheanceHebdo(this.jourSemaine) {
    if (jourSemaine < 1 || jourSemaine > 7) {
      throw ArgumentError.value(
        jourSemaine,
        'jourSemaine',
        'Doit être compris entre 1 (lundi) et 7 (dimanche).',
      );
    }
  }
  final int jourSemaine;
}

// Noms des jours pour libelleEcheance.
const _nomsJours = [
  '', // index 0 non utilisé
  'lundi',
  'mardi',
  'mercredi',
  'jeudi',
  'vendredi',
  'samedi',
  'dimanche',
];

/// Libellé affichable d'une échéance.
/// Le switch est exhaustif : ajouter une sous-classe sans traiter le cas
/// provoque une erreur de compilation.
String libelleEcheance(Echeance echeance) => switch (echeance) {
  SansEcheance() => 'sans échéance',
  EcheanceDatee(:final date) => 'pour le ${date.day}/${date.month}',
  EcheanceHebdo(:final jourSemaine) => 'chaque ${_nomsJours[jourSemaine]}',
};

// ─────────────────────────────────────────────────────────────────────────────
// Tâche
// ─────────────────────────────────────────────────────────────────────────────

/// Une tâche est immuable : tous ses champs sont `final`.
/// « Modifier » une tâche = construire une nouvelle instance avec [copyWith].
class Tache {
  const Tache({
    required this.id,
    required this.titre,
    this.priorite = Priorite.normale,
    this.echeance = const SansEcheance(),
    this.note,
    this.faite = false,
  });

  final String id;
  final String titre;
  final Priorite priorite;
  final Echeance echeance;
  final String? note;
  final bool faite;

  /// Renvoie une nouvelle [Tache] avec les champs spécifiés modifiés ;
  /// l'identifiant reste inchangé. Pour effacer la note, passer [note] = null
  /// ET [effacerNote] = true (pour distinguer "pas fourni" de "effacer").
  Tache copyWith({
    String? titre,
    Priorite? priorite,
    Echeance? echeance,
    String? note,
    bool effacerNote = false,
    bool? faite,
  }) {
    return Tache(
      id: id,
      titre: titre ?? this.titre,
      priorite: priorite ?? this.priorite,
      echeance: echeance ?? this.echeance,
      note: effacerNote ? null : (note ?? this.note),
      faite: faite ?? this.faite,
    );
  }

  @override
  String toString() => '$titre [$priorite${faite ? ", faite" : ""}]';
}

/// Construit une [Tache] à partir d'un document JSON déjà décodé.
///
/// Clés obligatoires : "id" (String non vide), "title" (String non vide),
/// "priority" (code reconnu), "done" (bool).
/// Clé optionnelle "due" : absent/null → [SansEcheance], sinon AAAA-MM-JJ.
/// Clé optionnelle "note" : absent/null → pas de note, sinon String.
///
/// Lève [FormatException] si le document ne respecte pas ces règles.
Tache tacheDepuisJson(Map<String, Object?> json) {
  // Clés obligatoires
  final id = json['id'];
  final title = json['title'];
  final priorityCode = json['priority'];
  final done = json['done'];

  if (id is! String || id.isEmpty) {
    throw FormatException('Champ "id" manquant ou invalide : $json');
  }
  if (title is! String || title.isEmpty) {
    throw FormatException('Champ "title" manquant ou invalide : $json');
  }
  if (priorityCode is! String) {
    throw FormatException('Champ "priority" manquant ou invalide : $json');
  }
  if (done is! bool) {
    throw FormatException('Champ "done" manquant ou invalide : $json');
  }

  final priorite = prioriteDepuisCode(priorityCode);
  if (priorite == null) {
    throw FormatException('Priorité inconnue : "$priorityCode"');
  }

  // Échéance optionnelle
  Echeance echeance = const SansEcheance();
  final due = json['due'];
  if (due != null) {
    if (due is! String) {
      throw FormatException('Champ "due" invalide : $json');
    }
    final date = DateTime.tryParse(due);
    if (date == null) {
      throw FormatException('Date "due" illisible : "$due"');
    }
    echeance = EcheanceDatee(date);
  }

  // Note optionnelle
  String? note;
  final noteJson = json['note'];
  if (noteJson != null) {
    if (noteJson is! String) {
      throw FormatException('Champ "note" invalide : $json');
    }
    note = noteJson;
  }

  return Tache(
    id: id,
    titre: title,
    priorite: priorite,
    echeance: echeance,
    note: note,
    faite: done,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Fonctions utilitaires
// ─────────────────────────────────────────────────────────────────────────────

/// Vrai si et seulement si [tache] n'est pas faite et que son échéance est une
/// date strictement antérieure à [aujourdhui] (l'heure est ignorée).
bool estEnRetard(Tache tache, {required DateTime aujourdhui}) {
  if (tache.faite) return false;
  return switch (tache.echeance) {
    EcheanceDatee(:final date) =>
      date.year < aujourdhui.year ||
          (date.year == aujourdhui.year && date.month < aujourdhui.month) ||
          (date.year == aujourdhui.year &&
              date.month == aujourdhui.month &&
              date.day < aujourdhui.day),
    SansEcheance() || EcheanceHebdo() => false,
  };
}

/// Renvoie un record `(faites, total)` : nombre de tâches faites et total.
/// Une collection vide donne `(faites: 0, total: 0)`.
({int faites, int total}) bilan(Iterable<Tache> taches) {
  var total = 0;
  var faites = 0;
  for (final t in taches) {
    total++;
    if (t.faite) faites++;
  }
  return (faites: faites, total: total);
}

/// Renvoie une nouvelle liste des tâches non faites dont la priorité vaut
/// au moins [auMoins], triées par priorité décroissante puis par titre.
/// La collection source n'est jamais modifiée.
List<Tache> aFaire(
  Iterable<Tache> taches, {
  Priorite auMoins = Priorite.basse,
}) {
  final resultat = [
    for (final t in taches)
      if (!t.faite && t.priorite.index >= auMoins.index) t,
  ];
  resultat.sort((a, b) {
    final cmpPrio = b.priorite.index.compareTo(a.priorite.index);
    if (cmpPrio != 0) return cmpPrio;
    return a.titre.compareTo(b.titre);
  });
  return resultat;
}
