import 'package:flutter/material.dart';

import 'modeles.dart';
import 'modeles_savoirs.dart';

/// Organisations et opportunités fictives (bourses, concours, stages…).

const fondationMbongui = Vendeur(
  'Fondation Mbongui',
  id: 'mbongui',
  badge: 'Organisation vérifiée',
  couleur: Color(0xFF7C3AED),
  abonnes: 9800,
  quartier: 'Centre-ville',
  bio: 'Bourses d’études pour les bacheliers méritants du Congo.',
);
const brasseriePool = Vendeur(
  'Brasserie du Pool',
  id: 'pool',
  badge: 'Organisation vérifiée',
  couleur: Color(0xFF7C2D12),
  abonnes: 14100,
  quartier: 'Mpila',
  bio: 'Stages et emplois dans la production et la logistique.',
);
const ecoleAdministration = Vendeur(
  'École nationale d’administration (démo)',
  id: 'ena',
  badge: 'Organisme public vérifié',
  couleur: Color(0xFF13385C),
  abonnes: 30500,
  quartier: 'Centre-ville',
  bio: 'Concours d’entrée dans la fonction publique.',
);
const cliniqueCardio = Vendeur(
  'Clinique Cardio Brazza',
  id: 'cardio',
  badge: 'Organisation vérifiée',
  couleur: Color(0xFFBE123C),
  abonnes: 3200,
  quartier: 'Plateau',
  bio: 'Soins cardiologiques. Recrute infirmiers et secrétaires médicaux.',
);
const institutNumerique = Vendeur(
  'Institut numérique de Pointe-Noire',
  id: 'inp',
  badge: 'Organisation vérifiée',
  couleur: Color(0xFF0369A1),
  abonnes: 6100,
  quartier: 'Pointe-Noire',
  bio: 'Formations gratuites au numérique pour les 18-30 ans.',
);

const opportunites = <Opportunite>[
  Opportunite(
    id: 'o1',
    type: TypeOpportunite.bourse,
    titre: 'Bourse d’excellence 2027 : études supérieures',
    organisation: fondationMbongui,
    lieu: 'Brazzaville et Pointe-Noire',
    dateLimite: '15 octobre 2026',
    joursRestants: 20,
    places: 40,
    candidats: 1260,
    niveau: 'Bacheliers 2026, mention Bien',
    remuneration: '75 000 FCFA / mois pendant 3 ans',
    description:
        'La Fondation finance les études de 40 bacheliers méritants : frais '
        'd’inscription, allocation mensuelle et ordinateur portable.',
    conditions: [
      'BAC 2026 avec mention Bien ou Très bien',
      'Avoir moins de 21 ans au 31 décembre 2026',
      'Être inscrit dans un établissement du Congo',
    ],
    pieces: [
      'Relevé de notes du BAC',
      'Pièce d’identité',
      'Lettre de motivation',
      'CV',
    ],
    avantages: [
      'Frais d’inscription payés',
      'Allocation mensuelle',
      'Ordinateur portable',
      'Mentorat',
    ],
  ),
  Opportunite(
    id: 'o2',
    type: TypeOpportunite.concours,
    titre: 'Concours d’entrée 2027 : cycle A',
    organisation: ecoleAdministration,
    lieu: 'Brazzaville',
    dateLimite: '30 novembre 2026',
    joursRestants: 66,
    places: 120,
    candidats: 5400,
    niveau: 'Licence ou équivalent',
    frais: 15000,
    fraisPayesA: 'au Trésor public, contre quittance officielle',
    description:
        'Concours de recrutement des futurs administrateurs. Épreuves écrites '
        'en février, oral en avril.',
    conditions: [
      'Nationalité congolaise',
      'Licence ou équivalent',
      'Moins de 35 ans',
    ],
    pieces: [
      'Diplôme',
      'Acte de naissance',
      'Casier judiciaire',
      'Quittance des frais',
    ],
    avantages: ['Formation rémunérée de 2 ans', 'Poste dans l’administration'],
  ),
  Opportunite(
    id: 'o3',
    type: TypeOpportunite.stage,
    titre: 'Stage logistique et qualité (6 mois)',
    organisation: brasseriePool,
    lieu: 'Brazzaville, Mpila',
    dateLimite: '10 octobre 2026',
    joursRestants: 15,
    places: 8,
    candidats: 310,
    niveau: 'BTS, licence',
    remuneration: '80 000 FCFA / mois',
    description:
        'Stage dans l’entrepôt et le laboratoire qualité, avec tuteur.',
    conditions: [
      'BTS ou licence en logistique, chimie ou gestion',
      'Disponible dès novembre',
    ],
    pieces: ['CV', 'Lettre de motivation', 'Attestation d’inscription'],
    avantages: ['Gratification', 'Transport', 'Attestation de stage'],
  ),
  Opportunite(
    id: 'o4',
    type: TypeOpportunite.emploi,
    titre: 'Infirmier ou infirmière diplômé(e)',
    organisation: cliniqueCardio,
    lieu: 'Brazzaville, Plateau',
    dateLimite: '5 octobre 2026',
    joursRestants: 10,
    places: 3,
    candidats: 94,
    niveau: 'Diplôme d’État infirmier',
    remuneration: '250 000 à 320 000 FCFA / mois',
    description: 'CDI, gardes rémunérées, formation continue en cardiologie.',
    conditions: ['Diplôme d’État', '2 ans d’expérience'],
    pieces: ['CV', 'Diplôme', 'Pièce d’identité'],
    avantages: ['CDI', 'Assurance santé', 'Formation continue'],
  ),
  Opportunite(
    id: 'o5',
    type: TypeOpportunite.formation,
    titre: 'Formation gratuite : développeur web (4 mois)',
    organisation: institutNumerique,
    lieu: 'Pointe-Noire et en ligne',
    dateLimite: '20 octobre 2026',
    joursRestants: 25,
    places: 60,
    candidats: 880,
    niveau: '18-30 ans, BAC',
    description:
        'Formation intensive avec ordinateur prêté et stage en entreprise.',
    conditions: ['Avoir entre 18 et 30 ans', 'BAC', 'Disponible à plein temps'],
    pieces: ['Pièce d’identité', 'Lettre de motivation'],
    avantages: ['100 % gratuit', 'Ordinateur prêté', 'Stage garanti'],
  ),
];

Opportunite opportuniteParId(String id) => opportunites.firstWhere(
  (o) => o.id == id,
  orElse: () => opportunites.first,
);
