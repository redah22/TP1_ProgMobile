// Données fictives : l'application tourne sans service ni base de données.
// Le CM 02 montrera comment les obtenir d'un service web, derrière un
// dépôt (repository), sans changer les écrans.
import '../modele/biblio.dart';

const catalogue = [
  Livre(
    titre: 'Dune',
    auteur: 'Frank Herbert',
    annee: 1965,
    genre: Genre.scienceFiction,
    serie: 'Le Cycle de Dune',
    lecture: EnCours(page: 212, pages: 412),
  ),
  Livre(
    titre: "L'Étranger",
    auteur: 'Albert Camus',
    annee: 1942,
    genre: Genre.roman,
    lecture: Terminee(note: 4),
  ),
  Livre(
    titre: 'Fondation',
    auteur: 'Isaac Asimov',
    annee: 1951,
    genre: Genre.scienceFiction,
    serie: 'Le Cycle de Fondation',
  ),
  Livre(
    titre: 'Le Nom de la rose',
    auteur: 'Umberto Eco',
    annee: 1980,
    genre: Genre.policier,
    lecture: Terminee(note: 5),
  ),
  Livre(
    titre: 'Sapiens',
    auteur: 'Yuval Noah Harari',
    annee: 2011,
    genre: Genre.essai,
    lecture: EnCours(page: 80, pages: 512),
  ),
  Livre(
    titre: 'Le Petit Prince',
    auteur: 'Antoine de Saint-Exupéry',
    annee: 1943,
    genre: Genre.roman,
  ),
];
