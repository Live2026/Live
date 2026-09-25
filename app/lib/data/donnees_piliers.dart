import 'package:flutter/material.dart';

/// Données de démonstration des piliers « référence » (docs/21) : tontines,
/// achats groupés, factures, diaspora, points relais.

/// Tontine (likelemba) : cotisation fixe à date fixe, un bénéficiaire par
/// tour. Live garde les cotisations et verse la cagnotte le jour du tour.
class Tontine {
  const Tontine({
    required this.id,
    required this.nom,
    required this.montant,
    required this.frequence,
    required this.membres,
    required this.tour,
    required this.moi,
    required this.prochaine,
    required this.couleur,
  });
  final String id;
  final String nom;
  final int montant;
  final String frequence;

  /// Membres dans l'ordre des tours, avec « a cotisé ce tour-ci ».
  final List<(String, bool)> membres;

  /// Rang du tour en cours (0 = premier bénéficiaire).
  final int tour;

  /// Rang de l'utilisateur dans l'ordre des tours.
  final int moi;
  final String prochaine;
  final Color couleur;

  int get cagnotte => montant * membres.length;
  String get beneficiaire => membres[tour].$1;
}

const tontines = [
  Tontine(
    id: 't1',
    nom: 'Mamans de Moungali',
    montant: 10000,
    frequence: 'Chaque samedi',
    membres: [
      ('Mama Ngudi', true),
      ('Nadège L.', true),
      ('Grâce M.', false),
      ('Merveille K.', true),
      ('Clarisse B.', false),
      ('Aurore T.', true),
      ('Bénédicte O.', true),
      ('Sylvie N.', false),
    ],
    tour: 3,
    moi: 2,
    prochaine: 'Samedi 27 septembre',
    couleur: Color(0xFFDB2777),
  ),
  Tontine(
    id: 't2',
    nom: 'Collègues du Plateau',
    montant: 50000,
    frequence: 'Le 5 de chaque mois',
    membres: [
      ('Junior K.', true),
      ('Grâce M.', true),
      ('Patrick D.', true),
      ('Aïcha N.', false),
      ('Brice O.', true),
      ('Christelle M.', true),
    ],
    tour: 1,
    moi: 1,
    prochaine: 'Dimanche 5 octobre',
    couleur: Color(0xFF0F766E),
  ),
];

Tontine tontineParId(String id) => tontines.firstWhere((t) => t.id == id);

/// Achat groupé : le prix de gros est débloqué quand l'objectif de
/// participants est atteint ; sinon chacun est remboursé.
class AchatGroupe {
  const AchatGroupe({
    required this.id,
    required this.titre,
    required this.vendeur,
    required this.prix,
    required this.prixGroupe,
    required this.objectif,
    required this.inscrits,
    required this.fin,
    required this.icone,
    required this.couleur,
  });
  final String id;
  final String titre;
  final String vendeur;
  final int prix;
  final int prixGroupe;
  final int objectif;
  final int inscrits;
  final String fin;
  final IconData icone;
  final Color couleur;
}

const achatsGroupes = [
  AchatGroupe(
    id: 'ag1',
    titre: 'Sac de riz 25 kg',
    vendeur: 'Grossiste Marché Total',
    prix: 21000,
    prixGroupe: 17500,
    objectif: 20,
    inscrits: 14,
    fin: 'Dans 2 jours',
    icone: Icons.rice_bowl_rounded,
    couleur: Color(0xFFB45309),
  ),
  AchatGroupe(
    id: 'ag2',
    titre: 'Bouteille de gaz 12,5 kg',
    vendeur: 'Congo Gaz Services',
    prix: 9500,
    prixGroupe: 8200,
    objectif: 30,
    inscrits: 27,
    fin: 'Ce soir',
    icone: Icons.propane_tank_rounded,
    couleur: Color(0xFF0369A1),
  ),
  AchatGroupe(
    id: 'ag3',
    titre: 'Panneau solaire 200 W',
    vendeur: 'Soleil du Congo',
    prix: 145000,
    prixGroupe: 118000,
    objectif: 10,
    inscrits: 4,
    fin: 'Dans 6 jours',
    icone: Icons.solar_power_rounded,
    couleur: Color(0xFF15803D),
  ),
];

/// Facture ou abonnement du quotidien.
class Facture {
  const Facture({
    required this.id,
    required this.fournisseur,
    required this.objet,
    required this.reference,
    required this.montant,
    required this.echeance,
    required this.icone,
    required this.couleur,
  });
  final String id;
  final String fournisseur;
  final String objet;
  final String reference;
  final int montant;
  final String echeance;
  final IconData icone;
  final Color couleur;
}

const factures = [
  Facture(
    id: 'f1',
    fournisseur: 'E2C',
    objet: 'Électricité · septembre',
    reference: 'Compteur 0412 88 17',
    montant: 18450,
    echeance: 'Avant le 5 octobre',
    icone: Icons.bolt_rounded,
    couleur: Color(0xFFCA8A04),
  ),
  Facture(
    id: 'f2',
    fournisseur: 'LCDE',
    objet: 'Eau · août-septembre',
    reference: 'Abonné 77 102 45',
    montant: 9800,
    echeance: 'Avant le 12 octobre',
    icone: Icons.water_drop_rounded,
    couleur: Color(0xFF0284C7),
  ),
  Facture(
    id: 'f3',
    fournisseur: 'Canal+',
    objet: 'Bouquet Évasion · 1 mois',
    reference: 'Décodeur 3321 0098',
    montant: 10000,
    echeance: 'Renouvellement le 1er octobre',
    icone: Icons.tv_rounded,
    couleur: Color(0xFF111827),
  ),
];

/// Proche au pays, pour qui la diaspora paie.
const proches = [
  ('Maman Céline', 'Moungali, Brazzaville', '06 555 12 34', Color(0xFFDB2777)),
  ('Frère Jordy', 'Talangaï, Brazzaville', '05 444 98 76', Color(0xFF0369A1)),
  ('Tante Rose', 'Tié-Tié, Pointe-Noire', '06 777 45 45', Color(0xFF15803D)),
];

/// Point relais : dépôt et retrait de colis, espèces vers Mobile Money.
const pointsRelais = [
  (
    'Boutique Chez Ya Mado',
    'Moungali · marché',
    'Ouvert jusqu’à 21 h',
    Offset(0.45, 0.47),
  ),
  (
    'Pharmacie du Plateau',
    'Plateau · avenue Foch',
    'Ouvert jusqu’à 20 h',
    Offset(0.66, 0.64),
  ),
  (
    'Kiosque Talangaï',
    'Talangaï · rond-point',
    'Ouvert 24 h / 24',
    Offset(0.61, 0.22),
  ),
  (
    'Station Total Bacongo',
    'Bacongo · avenue Matsoua',
    'Ouvert jusqu’à 22 h',
    Offset(0.39, 0.71),
  ),
];
