import 'package:flutter/material.dart';

import 'donnees_apprendre.dart';
import 'donnees_immo.dart';
import 'donnees_market.dart';
import 'modeles.dart';

/// Données des modules des phases 2 et 3 (document 04, section 5) : directs,
/// cadeaux, abonnements de fans, séjours meublés, livraison, publicité.

/// Direct vidéo (Live Direct) : en cours ou programmé, avec produits épinglés.
class Direct {
  const Direct({
    required this.id,
    required this.titre,
    required this.hote,
    required this.couleur,
    required this.spectateurs,
    this.produits = const [],
    this.enCours = true,
    this.quand = '',
    this.bien,
  });
  final String id;
  final String titre;
  final Vendeur hote;
  final Color couleur;
  final int spectateurs;

  /// Identifiants des produits épinglés (live shopping).
  final List<String> produits;
  final bool enCours;

  /// Heure prévue d'un direct à venir.
  final String quand;

  /// Visite immobilière en direct.
  final String? bien;
}

const directs = <Direct>[
  Direct(
    id: 'd1',
    titre: 'Nouvel arrivage wax : -20 % pendant le direct',
    hote: graceMode,
    couleur: Color(0xFFB45309),
    spectateurs: 1240,
    produits: ['p2', 'p6', 'p8'],
  ),
  Direct(
    id: 'd2',
    titre: 'Révisions BAC : les dérivées en 30 min',
    hote: profKimbembe,
    couleur: Color(0xFF1D4ED8),
    spectateurs: 3120,
  ),
  Direct(
    id: 'd3',
    titre: 'Visite en direct : villa avec piscine à Djiri',
    hote: palmiers,
    couleur: Color(0xFF166534),
    spectateurs: 420,
    bien: 'b9',
  ),
  Direct(
    id: 'd4',
    titre: 'Téléphones reconditionnés garantis',
    hote: electroPlus,
    couleur: Color(0xFF0E7490),
    spectateurs: 0,
    produits: ['p5', 'p3'],
    enCours: false,
    quand: 'Ce soir · 19:00',
  ),
  Direct(
    id: 'd5',
    titre: 'Cuisine : saka-saka comme à Bacongo',
    hote: mamaNgudi,
    couleur: Color(0xFF9D174D),
    spectateurs: 0,
    produits: ['p9'],
    enCours: false,
    quand: 'Samedi · 11:00',
  ),
];

Direct directParId(String id) =>
    directs.firstWhere((d) => d.id == id, orElse: () => directs.first);

/// Cadeau virtuel envoyé pendant un direct ou sous une vidéo.
/// Le créateur reçoit 75 % (commission de 25 %, document 02, section 3).
class Cadeau {
  const Cadeau(this.nom, this.prix, this.icone, this.couleur);
  final String nom;
  final int prix;
  final IconData icone;
  final Color couleur;
}

const cadeaux = [
  Cadeau('Rose', 100, Icons.local_florist_rounded, Color(0xFFE11D48)),
  Cadeau('Cœur', 250, Icons.favorite_rounded, Color(0xFFDB2777)),
  Cadeau('Pagne', 500, Icons.texture_rounded, Color(0xFFB45309)),
  Cadeau('Couronne', 1000, Icons.workspace_premium_rounded, Color(0xFFCA8A04)),
  Cadeau('Fusée', 2500, Icons.rocket_launch_rounded, Color(0xFF7C3AED)),
  Cadeau('Lion', 5000, Icons.pets_rounded, Color(0xFFEA580C)),
];

/// Formule d'abonnement de fan à un créateur.
class OffreFan {
  const OffreFan(this.nom, this.prix, this.avantages);
  final String nom;
  final int prix;
  final List<String> avantages;
}

const offresFan = [
  OffreFan('Fan', 500, [
    'Badge de fan dans les commentaires',
    'Vidéos réservées aux fans',
  ]),
  OffreFan('Super fan', 1500, [
    'Tout de la formule Fan',
    'Directs privés chaque mois',
    'Réponse prioritaire aux questions',
  ]),
];

/// Logement meublé loué à la nuit (location de courte durée, P2).
class Sejour {
  const Sejour({
    required this.id,
    required this.titre,
    required this.quartier,
    required this.nuit,
    required this.couleur,
    required this.hote,
    this.voyageurs = 2,
    this.note = 4.8,
    this.equipements = const [],
  });
  final String id;
  final String titre;
  final String quartier;
  final int nuit;
  final Color couleur;
  final Vendeur hote;
  final int voyageurs;
  final double note;
  final List<String> equipements;
}

const sejours = <Sejour>[
  Sejour(
    id: 's1',
    titre: 'Studio meublé climatisé, vue fleuve',
    quartier: 'Plateau',
    nuit: 25000,
    couleur: Color(0xFF0E7490),
    hote: palmiers,
    equipements: ['Climatisation', 'Wi-Fi', 'Groupe électrogène', 'Parking'],
  ),
  Sejour(
    id: 's2',
    titre: 'Appartement 2 chambres, calme',
    quartier: 'Bacongo',
    nuit: 40000,
    couleur: Color(0xFF166534),
    hote: congoHabitat,
    voyageurs: 4,
    note: 4.6,
    equipements: ['Climatisation', 'Cuisine équipée', 'Forage', 'Gardien'],
  ),
  Sejour(
    id: 's3',
    titre: 'Chambre d’hôte près du CHU',
    quartier: 'Moungali',
    nuit: 15000,
    couleur: Color(0xFF9A3412),
    hote: mbemba,
    voyageurs: 1,
    note: 4.9,
    equipements: ['Ventilateur', 'Petit-déjeuner', 'Wi-Fi'],
  ),
];

Sejour sejourParId(String id) =>
    sejours.firstWhere((s) => s.id == id, orElse: () => sejours.first);
