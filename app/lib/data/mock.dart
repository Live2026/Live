import 'package:flutter/material.dart';

/// Données fictives du prototype. Aucune donnée réelle, aucun appel réseau.

enum Verticale { market, immo, services }

class Vendeur {
  const Vendeur(
    this.nom, {
    this.note = 4.8,
    this.ventes = 0,
    this.verifie = true,
    this.badge = 'Identité vérifiée',
  });
  final String nom;
  final double note;
  final int ventes;
  final bool verifie;
  final String badge;
}

class Produit {
  const Produit({
    required this.id,
    required this.titre,
    required this.prix,
    required this.quartier,
    required this.vendeur,
    required this.couleur,
    required this.icone,
    this.etat = 'Très bon état',
    this.negociable = true,
    this.livraison = 2000,
    this.description = '',
    this.details = const {},
  });
  final String id;
  final String titre;
  final int prix;
  final String quartier;
  final Vendeur vendeur;
  final Color couleur;
  final IconData icone;
  final String etat;
  final bool negociable;
  final int livraison;
  final String description;
  final Map<String, String> details;
}

class Bien {
  const Bien({
    required this.id,
    required this.titre,
    required this.quartier,
    required this.loyer,
    required this.moisAvance,
    required this.moisCaution,
    required this.commissionMois,
    required this.fraisVisite,
    required this.annonceur,
    required this.couleur,
    required this.caracteristiques,
    this.repere = '',
    this.confirmeIlYa = 5,
  });
  final String id;
  final String titre;
  final String quartier;
  final int loyer;
  final int moisAvance;
  final int moisCaution;
  final int commissionMois;
  final int fraisVisite;
  final Vendeur annonceur;
  final Color couleur;
  final List<String> caracteristiques;
  final String repere;
  final int confirmeIlYa;

  int get avance => loyer * moisAvance;
  int get caution => loyer * moisCaution;
  int get commission => loyer * commissionMois;
  int get coutEntree => avance + caution + commission;
}

class Prestataire {
  const Prestataire({
    required this.id,
    required this.nom,
    required this.metier,
    required this.note,
    required this.avis,
    required this.zone,
    required this.couleur,
  });
  final String id;
  final String nom;
  final String metier;
  final double note;
  final int avis;
  final String zone;
  final Color couleur;
}

class Devis {
  const Devis({
    required this.prestataire,
    required this.mainOeuvre,
    required this.materiel,
    required this.acompte,
    required this.quand,
  });
  final Prestataire prestataire;
  final int mainOeuvre;
  final int materiel;
  final int acompte;
  final String quand;
  int get total => mainOeuvre + materiel;
}

class Publication {
  const Publication({
    required this.auteur,
    required this.texte,
    required this.verticale,
    required this.cibleId,
    required this.couleur,
    required this.likes,
    this.distance,
  });
  final String auteur;
  final String texte;
  final Verticale verticale;
  final String cibleId;
  final Color couleur;
  final String likes;
  final String? distance;
}

const graceMode = Vendeur(
  'Grâce Mode',
  note: 4.8,
  ventes: 214,
  badge: 'Pro vérifié',
);
const electroPlus = Vendeur(
  'ÉlectroPlus',
  note: 4.6,
  ventes: 96,
  badge: 'Pro vérifié',
);
const patrick = Vendeur('Patrick N.', note: 4.2, ventes: 25);
const palmiers = Vendeur(
  'Agence Les Palmiers',
  note: 4.7,
  ventes: 38,
  badge: 'Agence vérifiée',
);
const mbemba = Vendeur('M. Mbemba (propriétaire)', note: 4.9, ventes: 3);

const produits = <Produit>[
  Produit(
    id: 'p1',
    titre: 'iPhone 11 64 Go',
    prix: 85000,
    quartier: 'Moungali',
    vendeur: graceMode,
    couleur: Color(0xFF334155),
    icone: Icons.phone_iphone,
    description: 'Batterie 86 %, aucune rayure, avec chargeur. Vendu car changement de téléphone.',
    details: {'Stockage': '64 Go', 'Couleur': 'Noir', 'Quantité': '1'},
  ),
  Produit(
    id: 'p2',
    titre: 'Robe wax longue',
    prix: 15000,
    quartier: 'Moungali',
    vendeur: graceMode,
    couleur: Color(0xFFB45309),
    icone: Icons.checkroom,
    etat: 'Neuf',
    negociable: false,
    description: 'Nouvel arrivage. Tailles S à XL.',
    details: {'Tailles': 'S, M, L, XL', 'Tissu': 'Wax 100 % coton'},
  ),
  Produit(
    id: 'p3',
    titre: 'Climatiseur split 1,5 CV',
    prix: 185000,
    quartier: 'Poto-Poto',
    vendeur: electroPlus,
    couleur: Color(0xFF0E7490),
    icone: Icons.ac_unit,
    etat: 'Neuf',
    livraison: 5000,
    description:
        'Garantie vendeur 6 mois. Installation possible par un pro Live.',
    details: {'Marque': 'LG', 'Puissance': '1,5 CV'},
  ),
  Produit(
    id: 'p4',
    titre: 'Climatiseur 1 CV occasion',
    prix: 90000,
    quartier: 'Ouenzé',
    vendeur: patrick,
    couleur: Color(0xFF475569),
    icone: Icons.ac_unit,
    etat: 'Bon état',
    description: 'Fonctionne très bien, vendu car déménagement.',
    details: {'Puissance': '1 CV'},
  ),
  Produit(
    id: 'p5',
    titre: 'Galaxy A14 128 Go',
    prix: 75000,
    quartier: 'Bacongo',
    vendeur: electroPlus,
    couleur: Color(0xFF1E3A5F),
    icone: Icons.smartphone,
    etat: 'Neuf',
    description: 'Neuf sous emballage, garantie vendeur 3 mois.',
    details: {'Stockage': '128 Go', 'Couleur': 'Bleu'},
  ),
  Produit(
    id: 'p6',
    titre: 'Pagne wax 6 yards',
    prix: 18000,
    quartier: 'Poto-Poto',
    vendeur: graceMode,
    couleur: Color(0xFF9A3412),
    icone: Icons.texture,
    etat: 'Neuf',
    negociable: false,
    description: 'Motifs de la nouvelle collection.',
    details: {'Longueur': '6 yards'},
  ),
  Produit(
    id: 'p7',
    titre: 'Ventilateur sur pied',
    prix: 22000,
    quartier: 'Ouenzé',
    vendeur: patrick,
    couleur: Color(0xFF0F766E),
    icone: Icons.air,
    etat: 'Comme neuf',
    description: 'Utilisé deux mois, trois vitesses.',
    details: {'Vitesses': '3'},
  ),
  Produit(
    id: 'p8',
    titre: 'Sac à main cuir',
    prix: 25000,
    quartier: 'Moungali',
    vendeur: graceMode,
    couleur: Color(0xFF7C2D12),
    icone: Icons.shopping_bag,
    etat: 'Neuf',
    description: 'Cuir véritable, fabrication locale.',
    details: {'Matière': 'Cuir'},
  ),
];

const biens = <Bien>[
  Bien(
    id: 'b1',
    titre: 'Appartement 2 chambres',
    quartier: 'Moungali',
    loyer: 90000,
    moisAvance: 3,
    moisCaution: 1,
    commissionMois: 1,
    fraisVisite: 2000,
    annonceur: palmiers,
    couleur: Color(0xFF166534),
    repere: 'Derrière le marché Total',
    caracteristiques: [
      '2 chambres · 1 salon · 1 douche int.',
      'Eau : forage',
      'Électricité : compteur individuel',
      'Clôturé · Gardien · Parking',
      'Zone inondable : non',
    ],
  ),
  Bien(
    id: 'b2',
    titre: 'Studio',
    quartier: 'Plateau',
    loyer: 45000,
    moisAvance: 3,
    moisCaution: 1,
    commissionMois: 0,
    fraisVisite: 1000,
    annonceur: mbemba,
    couleur: Color(0xFF7C2D12),
    repere: 'Face à la pharmacie du Plateau',
    confirmeIlYa: 2,
    caracteristiques: [
      '1 pièce · douche interne',
      'Eau : réseau public',
      'Électricité : compteur prépayé',
      'Zone inondable : non',
    ],
  ),
  Bien(
    id: 'b3',
    titre: 'Maison 3 chambres',
    quartier: 'Bacongo',
    loyer: 150000,
    moisAvance: 3,
    moisCaution: 1,
    commissionMois: 1,
    fraisVisite: 3000,
    annonceur: palmiers,
    couleur: Color(0xFF1E3A8A),
    repere: 'Près du rond-point de la Coupole',
    confirmeIlYa: 9,
    caracteristiques: [
      '3 chambres · 1 salon · 2 douches',
      'Eau : forage',
      'Électricité : compteur individuel',
      'Cour · Parking 2 voitures',
    ],
  ),
  Bien(
    id: 'b4',
    titre: 'Studio meublé',
    quartier: 'Poto-Poto',
    loyer: 60000,
    moisAvance: 3,
    moisCaution: 1,
    commissionMois: 0,
    fraisVisite: 1500,
    annonceur: mbemba,
    couleur: Color(0xFF334155),
    repere: "Près du marché de Poto-Poto",
    confirmeIlYa: 1,
    caracteristiques: [
      "1 pièce meublée · douche interne",
      "Eau : réseau public",
      "Électricité : compteur prépayé",
    ],
  ),
  Bien(
    id: 'b5',
    titre: 'Appartement 3 chambres',
    quartier: 'Plateau',
    loyer: 180000,
    moisAvance: 3,
    moisCaution: 1,
    commissionMois: 1,
    fraisVisite: 3000,
    annonceur: palmiers,
    couleur: Color(0xFF0E4D64),
    repere: "Avenue principale, face à la banque",
    confirmeIlYa: 3,
    caracteristiques: [
      "3 chambres · 2 salons · 2 douches",
      "Eau : forage",
      "Groupe électrogène",
      "Parking",
    ],
  ),
  Bien(
    id: 'b6',
    titre: 'Chambre salon',
    quartier: 'Talangaï',
    loyer: 35000,
    moisAvance: 3,
    moisCaution: 1,
    commissionMois: 0,
    fraisVisite: 1000,
    annonceur: mbemba,
    couleur: Color(0xFF6B4F2A),
    repere: "Derrière l'église",
    confirmeIlYa: 6,
    caracteristiques: ["1 chambre · 1 salon", "Douche externe", "Eau : puits"],
  ),
  Bien(
    id: 'b7',
    titre: 'Maison 2 chambres',
    quartier: 'Mfilou',
    loyer: 80000,
    moisAvance: 3,
    moisCaution: 1,
    commissionMois: 1,
    fraisVisite: 2000,
    annonceur: palmiers,
    couleur: Color(0xFF3F6212),
    repere: "À 200 m du rond-point",
    confirmeIlYa: 4,
    caracteristiques: ["2 chambres · 1 salon", "Cour clôturée", "Eau : forage"],
  ),
  Bien(
    id: 'b8',
    titre: 'Local commercial',
    quartier: 'Moungali',
    loyer: 120000,
    moisAvance: 3,
    moisCaution: 1,
    commissionMois: 1,
    fraisVisite: 2000,
    annonceur: palmiers,
    couleur: Color(0xFF1F2937),
    repere: "Sur l'avenue, forte affluence",
    confirmeIlYa: 2,
    caracteristiques: [
      "Surface 40 m²",
      "Rideau métallique",
      "Électricité triphasée",
    ],
  ),
];

const prestataires = <Prestataire>[
  Prestataire(
    id: 's1',
    nom: 'Serge',
    metier: 'Plombier',
    note: 4.9,
    avis: 71,
    zone: 'Moungali, Ouenzé',
    couleur: Color(0xFF0369A1),
  ),
  Prestataire(
    id: 's2',
    nom: 'Paul',
    metier: 'Plombier',
    note: 4.6,
    avis: 22,
    zone: 'Moungali, Poto-Poto',
    couleur: Color(0xFF4D7C0F),
  ),
  Prestataire(
    id: 's3',
    nom: 'Didier',
    metier: 'Plombier',
    note: 4.2,
    avis: 9,
    zone: 'Talangaï',
    couleur: Color(0xFF9D174D),
  ),
  Prestataire(
    id: 's4',
    nom: 'Bruno',
    metier: 'Frigoriste',
    note: 4.8,
    avis: 57,
    zone: 'Talangaï, Djiri',
    couleur: Color(0xFF155E75),
  ),
  Prestataire(
    id: 's5',
    nom: 'Sandra',
    metier: 'Tresses',
    note: 4.9,
    avis: 120,
    zone: 'Bacongo · à domicile',
    couleur: Color(0xFF86198F),
  ),
];

final devisRecus = <Devis>[
  Devis(
    prestataire: prestataires[1],
    mainOeuvre: 12000,
    materiel: 6000,
    acompte: 5000,
    quand: 'Mardi',
  ),
  Devis(
    prestataire: prestataires[0],
    mainOeuvre: 17000,
    materiel: 8000,
    acompte: 10000,
    quand: "Aujourd'hui 16:00",
  ),
  Devis(
    prestataire: prestataires[2],
    mainOeuvre: 15000,
    materiel: 0,
    acompte: 0,
    quand: 'Demain',
  ),
];

const publications = <Publication>[
  Publication(
    auteur: '@grace.mode',
    texte: 'Nouvel arrivage de robes en wax !',
    verticale: Verticale.market,
    cibleId: 'p2',
    couleur: Color(0xFFB45309),
    likes: '1,2k',
  ),
  Publication(
    auteur: '@agence.palmiers',
    texte: 'Appartement 2 chambres, forage, parking.',
    verticale: Verticale.immo,
    cibleId: 'b1',
    couleur: Color(0xFF166534),
    likes: '842',
    distance: 'à 1,2 km',
  ),
  Publication(
    auteur: '@serge.plombier',
    texte: 'Fuite réparée en 30 minutes à Moungali.',
    verticale: Verticale.services,
    cibleId: 's1',
    couleur: Color(0xFF0369A1),
    likes: '310',
  ),
  Publication(
    auteur: '@grace.mode',
    texte: 'iPhone 11 comme neuf, batterie 86 %.',
    verticale: Verticale.market,
    cibleId: 'p1',
    couleur: Color(0xFF334155),
    likes: '96',
  ),
];

Produit produitParId(String id) => produits.firstWhere((p) => p.id == id);
Bien bienParId(String id) => biens.firstWhere((b) => b.id == id);
Prestataire prestataireParId(String id) =>
    prestataires.firstWhere((p) => p.id == id);
