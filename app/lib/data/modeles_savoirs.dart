import 'package:flutter/material.dart';

import 'modeles.dart';

/// Modèles des espaces Apprendre (contenus numériques), Opportunités et des
/// comptes suivis.

enum TypeContenu { cours, pdf, video, livre, serie, qcm, coaching }

extension InfoTypeContenu on TypeContenu {
  String get libelle => switch (this) {
    TypeContenu.cours => 'Cours',
    TypeContenu.pdf => 'PDF',
    TypeContenu.video => 'Vidéo',
    TypeContenu.livre => 'Livre',
    TypeContenu.serie => 'Série',
    TypeContenu.qcm => 'Exercices & QCM',
    TypeContenu.coaching => 'Coaching',
  };

  IconData get icone => switch (this) {
    TypeContenu.cours => Icons.school_rounded,
    TypeContenu.pdf => Icons.picture_as_pdf_rounded,
    TypeContenu.video => Icons.play_circle_rounded,
    TypeContenu.livre => Icons.menu_book_rounded,
    TypeContenu.serie => Icons.video_library_rounded,
    TypeContenu.qcm => Icons.quiz_rounded,
    TypeContenu.coaching => Icons.support_agent_rounded,
  };
}

/// Contenu numérique vendu dans Live (cours, PDF, vidéo…) : toujours payé
/// dans Live, disponible hors connexion après l'achat.
class Contenu {
  const Contenu({
    required this.id,
    required this.titre,
    required this.type,
    required this.auteur,
    required this.prix,
    required this.couleur,
    required this.format,
    this.note = 4.7,
    this.avis = 0,
    this.ventes = 0,
    this.niveau = 'Tous niveaux',
    this.description = '',
    this.programme = const [],
    this.taille = '25 Mo',
    this.nouveau = false,
  });
  final String id;
  final String titre;
  final TypeContenu type;
  final Vendeur auteur;
  final int prix;
  final Color couleur;

  /// Durée, nombre de pages ou de questions (« 6 h · 24 leçons »).
  final String format;
  final double note;
  final int avis;
  final int ventes;
  final String niveau;
  final String description;
  final List<String> programme;

  /// Poids du téléchargement, affiché pour économiser les données.
  final String taille;
  final bool nouveau;
}

enum TypeOpportunite { bourse, concours, stage, emploi, formation, autre }

extension InfoTypeOpportunite on TypeOpportunite {
  String get libelle => switch (this) {
    TypeOpportunite.bourse => 'Bourse',
    TypeOpportunite.concours => 'Concours',
    TypeOpportunite.stage => 'Stage',
    TypeOpportunite.emploi => 'Emploi',
    TypeOpportunite.formation => 'Formation',
    TypeOpportunite.autre => 'Autre',
  };

  IconData get icone => switch (this) {
    TypeOpportunite.bourse => Icons.workspace_premium_rounded,
    TypeOpportunite.concours => Icons.emoji_events_rounded,
    TypeOpportunite.stage => Icons.badge_rounded,
    TypeOpportunite.emploi => Icons.work_rounded,
    TypeOpportunite.formation => Icons.school_rounded,
    TypeOpportunite.autre => Icons.lightbulb_rounded,
  };

  Color get couleur => switch (this) {
    TypeOpportunite.bourse => const Color(0xFF7C3AED),
    TypeOpportunite.concours => const Color(0xFFB45309),
    TypeOpportunite.stage => const Color(0xFF0369A1),
    TypeOpportunite.emploi => const Color(0xFF15803D),
    TypeOpportunite.formation => const Color(0xFF1D4ED8),
    TypeOpportunite.autre => const Color(0xFF475569),
  };
}

/// Bourse, concours, stage, emploi ou formation. Postuler dans Live est
/// toujours gratuit ; les frais officiels éventuels sont affichés à l'avance.
class Opportunite {
  const Opportunite({
    required this.id,
    required this.type,
    required this.titre,
    required this.organisation,
    required this.lieu,
    required this.dateLimite,
    required this.joursRestants,
    required this.description,
    this.frais = 0,
    this.fraisPayesA = '',
    this.remuneration,
    this.places = 1,
    this.candidats = 0,
    this.niveau = 'Tous niveaux',
    this.conditions = const [],
    this.pieces = const [],
    this.avantages = const [],
    this.video = true,
  });
  final String id;
  final TypeOpportunite type;
  final String titre;
  final Vendeur organisation;
  final String lieu;
  final String dateLimite;
  final int joursRestants;
  final String description;

  /// Frais officiels (0 = gratuit), toujours payés en direct à [fraisPayesA].
  final int frais;
  final String fraisPayesA;
  final String? remuneration;
  final int places;
  final int candidats;
  final String niveau;
  final List<String> conditions;
  final List<String> pieces;
  final List<String> avantages;

  /// Vidéo verticale de présentation (30 s).
  final bool video;

  bool get gratuite => frais == 0;
}

enum TypeCompte { personne, organisation, createur, enseignant }

extension InfoTypeCompte on TypeCompte {
  String get libelle => switch (this) {
    TypeCompte.personne => 'Personne',
    TypeCompte.organisation => 'Organisation',
    TypeCompte.createur => 'Créateur',
    TypeCompte.enseignant => 'Enseignant',
  };

  String get pluriel => switch (this) {
    TypeCompte.personne => 'Personnes',
    TypeCompte.organisation => 'Organisations',
    TypeCompte.createur => 'Créateurs',
    TypeCompte.enseignant => 'Enseignants',
  };
}

/// Compte affiché dans les listes d'abonnés et d'abonnements.
class Compte {
  const Compte(
    this.id,
    this.nom,
    this.type,
    this.couleur,
    this.bio, {
    this.verifie = false,
    this.abonnes = 0,
    this.route,
  });
  final String id;
  final String nom;
  final TypeCompte type;
  final Color couleur;
  final String bio;
  final bool verifie;
  final int abonnes;

  /// Page ouverte au toucher (boutique, profil…).
  final String? route;
}

/// Activité récente d'un compte suivi (fil « Suivis »).
class Activite {
  const Activite(
    this.compte,
    this.action,
    this.titre,
    this.detail,
    this.quand,
    this.icone,
    this.route, {
    this.couleur = const Color(0xFF13385C),
  });
  final Compte compte;
  final String action;
  final String titre;
  final String detail;
  final String quand;
  final IconData icone;
  final String route;
  final Color couleur;
}
