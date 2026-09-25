import 'package:flutter/material.dart';

import 'modeles.dart';

/// Prestataires et devis fictifs de Live Services.

const metiers = <(IconData, String)>[
  (Icons.plumbing_rounded, 'Plombier'),
  (Icons.electrical_services_rounded, 'Électricien'),
  (Icons.ac_unit_rounded, 'Clim / Froid'),
  (Icons.phone_android_rounded, 'Réparation tél.'),
  (Icons.car_repair_rounded, 'Mécanicien'),
  (Icons.content_cut_rounded, 'Coiffure'),
  (Icons.brush_rounded, 'Maquillage'),
  (Icons.restaurant_rounded, 'Traiteur'),
  (Icons.format_paint_rounded, 'Peintre'),
  (Icons.cleaning_services_rounded, 'Ménage'),
  (Icons.school_rounded, 'Cours à domicile'),
  (Icons.photo_camera_rounded, 'Photo / Vidéo'),
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
    prixDepuis: 5000,
    interventions: 186,
    bio: '12 ans de métier. Fuites, installations, chauffe-eau. Garantie 72 h.',
    services: [
      ServiceFixe('sf1', 'Déboucher un évier', 7000, '45 min'),
      ServiceFixe('sf2', 'Changer un robinet', 10000, '1 h'),
      ServiceFixe('sf3', 'Installer un chauffe-eau', 25000, '3 h'),
    ],
  ),
  Prestataire(
    id: 's2',
    nom: 'Paul',
    metier: 'Plombier',
    note: 4.6,
    avis: 22,
    zone: 'Moungali, Poto-Poto',
    couleur: Color(0xFF4D7C0F),
    prixDepuis: 4000,
    interventions: 48,
    bio: 'Plomberie générale, intervention rapide.',
    services: [ServiceFixe('sf4', 'Déboucher un évier', 6000, '45 min')],
  ),
  Prestataire(
    id: 's3',
    nom: 'Didier',
    metier: 'Plombier',
    note: 4.2,
    avis: 9,
    zone: 'Talangaï',
    couleur: Color(0xFF9D174D),
    prixDepuis: 4000,
    interventions: 15,
  ),
  Prestataire(
    id: 's4',
    nom: 'Bruno',
    metier: 'Frigoriste',
    note: 4.8,
    avis: 57,
    zone: 'Talangaï, Djiri',
    couleur: Color(0xFF155E75),
    prixDepuis: 10000,
    interventions: 132,
    bio: 'Climatiseurs et réfrigérateurs : installation, recharge, entretien.',
    services: [
      ServiceFixe('sf5', 'Entretien climatiseur', 12000, '1 h'),
      ServiceFixe('sf6', 'Recharge de gaz', 20000, '1 h 30'),
    ],
  ),
  Prestataire(
    id: 's5',
    nom: 'Sandra',
    metier: 'Coiffure',
    note: 4.9,
    avis: 120,
    zone: 'Bacongo · à domicile',
    couleur: Color(0xFF86198F),
    prixDepuis: 8000,
    interventions: 340,
    bio: 'Tresses, nattes, tissages. Je me déplace à domicile.',
    services: [
      ServiceFixe('sf7', 'Nattes collées', 8000, '2 h'),
      ServiceFixe('sf8', 'Tresses longues', 15000, '4 h'),
      ServiceFixe('sf9', 'Tissage', 12000, '2 h 30'),
    ],
  ),
  Prestataire(
    id: 's6',
    nom: 'Arnaud',
    metier: 'Électricien',
    note: 4.7,
    avis: 44,
    zone: 'Plateau, Bacongo',
    couleur: Color(0xFFB45309),
    prixDepuis: 6000,
    interventions: 97,
    bio: 'Installation, dépannage, compteurs prépayés.',
    services: [ServiceFixe('sf10', 'Poser une prise', 6000, '30 min')],
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

/// Interventions du prestataire (vue « Mes interventions », E-SRV-09).
const interventions = <(String, String, String, int, String)>[
  // (client, travail, quand, montant, statut)
  ('Grâce M.', 'Fuite évier cuisine', "Aujourd'hui 16:00", 25000, 'À venir'),
  ('Rodrigue O.', 'Chauffe-eau', 'Demain 09:00', 25000, 'À venir'),
  (
    'Estelle N.',
    'Robinet salle de bain',
    "Aujourd'hui 11:00",
    10000,
    'En cours',
  ),
  ('Brice K.', 'Débouchage', 'Hier', 7000, 'Terminée'),
  ('Clarisse M.', 'Installation lavabo', 'Lundi', 18000, 'Terminée'),
];
