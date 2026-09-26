import 'package:flutter/material.dart';

/// Appels passés par Live (audio, vidéo, en groupe) : fictifs.
///
/// Les appels passent par internet (WebRTC, service géré type LiveKit,
/// docs/20) : ni le numéro de l'un ni celui de l'autre n'est montré, et rien
/// n'est facturé à la minute par l'opérateur.
enum SensAppel { entrant, sortant, manque }

class Appel {
  const Appel({
    required this.nom,
    required this.couleur,
    required this.sens,
    required this.heure,
    this.jour = 0,
    this.video = false,
    this.duree = 0,
    this.groupe,
    this.participants = 2,
    this.enLigne = false,
  });

  final String nom;
  final Color couleur;
  final SensAppel sens;

  /// Heure de l'appel (« 10:42 ») et nombre de jours écoulés (0 : aujourd'hui).
  final String heure;
  final int jour;
  final bool video;

  /// Durée en secondes (0 pour un appel manqué ou sans réponse).
  final int duree;

  /// Identifiant de la conversation de groupe, pour un appel en groupe.
  final String? groupe;
  final int participants;
  final bool enLigne;
}

const appelsRecents = <Appel>[
  Appel(
    nom: 'Grâce Mode',
    couleur: Color(0xFFB45309),
    sens: SensAppel.sortant,
    heure: '10:48',
    video: true,
    duree: 214,
    enLigne: true,
  ),
  Appel(
    nom: 'Agence Les Palmiers',
    couleur: Color(0xFF0F766E),
    sens: SensAppel.manque,
    heure: '09:15',
  ),
  Appel(
    nom: 'Terminale C · Révisions BAC',
    couleur: Color(0xFF1D4ED8),
    sens: SensAppel.entrant,
    heure: '20:30',
    jour: 1,
    video: true,
    duree: 3120,
    groupe: 'g1',
    participants: 6,
  ),
  Appel(
    nom: 'Maman',
    couleur: Color(0xFF9D174D),
    sens: SensAppel.entrant,
    heure: '18:02',
    jour: 1,
    duree: 1260,
    enLigne: true,
  ),
  Appel(
    nom: 'Plomberie Kimbembe',
    couleur: Color(0xFF0369A1),
    sens: SensAppel.sortant,
    heure: '11:20',
    jour: 3,
    duree: 95,
  ),
  Appel(
    nom: 'Tontine des commerçantes',
    couleur: Color(0xFF7C3AED),
    sens: SensAppel.manque,
    heure: '08:00',
    jour: 4,
    video: true,
    groupe: 'g2',
    participants: 9,
  ),
];

/// Participants fictifs d'un appel en groupe.
const participantsAppel = <(String, Color)>[
  ('Prof. Kimbembe', Color(0xFF1D4ED8)),
  ('Merveille', Color(0xFF9D174D)),
  ('Junior', Color(0xFF0F766E)),
  ('Divine', Color(0xFFB45309)),
  ('Christ', Color(0xFF7C3AED)),
];
