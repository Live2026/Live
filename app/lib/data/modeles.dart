import 'package:flutter/material.dart';

/// Modèles de données du prototype (docs/21 pour le modèle réel).

enum Verticale { market, immo, services }

/// Où se règle une somme (docs/19, section 1 bis). Live distingue ce qui se
/// paie dans l'application (protégé) de ce qui se paie sur place ou en direct.
enum Reglement {
  /// Payé dans Live : argent bloqué jusqu'à la remise ou au service rendu.
  dansLive,

  /// On voit avant d'acheter : rendez-vous fixé dans Live, paiement à la
  /// remise (QR Live pour rester protégé, ou espèces à ses risques).
  surPlace,

  /// Payé directement au propriétaire, à l'agence ou à l'organisme, contre
  /// reçu : loyers, caution, prix d'un bien, frais officiels d'un concours.
  direct,
}

extension InfoReglement on Reglement {
  String get libelle => switch (this) {
    Reglement.dansLive => 'Payé dans Live',
    Reglement.surPlace => 'Voir puis payer sur place',
    Reglement.direct => 'Payé en direct',
  };

  String get court => switch (this) {
    Reglement.dansLive => 'Dans Live',
    Reglement.surPlace => 'Sur place',
    Reglement.direct => 'En direct',
  };

  IconData get icone => switch (this) {
    Reglement.dansLive => Icons.verified_user_rounded,
    Reglement.surPlace => Icons.handshake_rounded,
    Reglement.direct => Icons.receipt_long_rounded,
  };

  Color get couleur => switch (this) {
    Reglement.dansLive => const Color(0xFF15803D),
    Reglement.surPlace => const Color(0xFFB45309),
    Reglement.direct => const Color(0xFF475569),
  };
}

/// Type d'espace professionnel (docs/03, section 6).
enum TypeEspace { boutique, agence, prestataire, chaine }

/// Vendeur, agence ou particulier qui publie sur Live.
class Vendeur {
  const Vendeur(
    this.nom, {
    this.id = '',
    this.note = 4.8,
    this.ventes = 0,
    this.verifie = true,
    this.badge = 'Identité vérifiée',
    this.couleur = const Color(0xFF13385C),
    this.abonnes = 0,
    this.quartier = 'Brazzaville',
    this.bio = '',
    this.depuis = '2026',
    this.reponse = '1 h',
  });
  final String id;
  final String nom;
  final double note;
  final int ventes;
  final bool verifie;
  final String badge;
  final Color couleur;
  final int abonnes;
  final String quartier;
  final String bio;
  final String depuis;

  /// Délai moyen de réponse aux messages.
  final String reponse;

  String get initiales => nom
      .split(' ')
      .where((m) => m.isNotEmpty && m[0].toUpperCase() == m[0])
      .take(2)
      .map((m) => m[0])
      .join();
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
    this.categorie = 'Divers',
    this.etat = 'Très bon état',
    this.negociable = true,
    this.livraison = 2000,
    this.description = '',
    this.details = const {},
    this.vues = 120,
    this.reglement = Reglement.dansLive,
  });
  final String id;
  final String titre;
  final int prix;
  final String quartier;
  final Vendeur vendeur;

  /// Occasion à voir avant d'acheter (téléphone, moto…) : [Reglement.surPlace].
  final Reglement reglement;
  final Color couleur;
  final IconData icone;
  final String categorie;
  final String etat;
  final bool negociable;
  final int livraison;
  final String description;
  final Map<String, String> details;
  final int vues;
}

enum TypeBien { appartement, maison, studio, chambre, villa, local, terrain }

extension LibelleTypeBien on TypeBien {
  String get libelle => switch (this) {
    TypeBien.appartement => 'Appartement',
    TypeBien.maison => 'Maison',
    TypeBien.studio => 'Studio',
    TypeBien.chambre => 'Chambre',
    TypeBien.villa => 'Villa',
    TypeBien.local => 'Local commercial',
    TypeBien.terrain => 'Terrain',
  };

  IconData get icone => switch (this) {
    TypeBien.appartement => Icons.apartment_rounded,
    TypeBien.maison => Icons.house_rounded,
    TypeBien.studio => Icons.bed_rounded,
    TypeBien.chambre => Icons.single_bed_rounded,
    TypeBien.villa => Icons.villa_rounded,
    TypeBien.local => Icons.storefront_rounded,
    TypeBien.terrain => Icons.landscape_rounded,
  };
}

class Bien {
  const Bien({
    required this.id,
    required this.titre,
    required this.type,
    required this.quartier,
    required this.loyer,
    required this.moisAvance,
    required this.moisCaution,
    required this.commissionMois,
    required this.fraisVisite,
    required this.annonceur,
    required this.couleur,
    required this.caracteristiques,
    this.vente = false,
    this.chambres = 0,
    this.douches = 0,
    this.surface = 0,
    this.meuble = false,
    this.eau = 'Réseau public',
    this.electricite = 'Compteur prépayé',
    this.parking = false,
    this.photos = 8,
    this.repere = '',
    this.confirmeIlYa = 5,
    this.nouveau = false,
    this.sponsorise = false,
  });
  final String id;
  final String titre;
  final TypeBien type;
  final String quartier;

  /// Loyer mensuel, ou prix de vente si [vente].
  final int loyer;
  final int moisAvance;
  final int moisCaution;
  final int commissionMois;
  final int fraisVisite;
  final Vendeur annonceur;
  final Color couleur;
  final List<String> caracteristiques;
  final bool vente;
  final int chambres;
  final int douches;
  final int surface;
  final bool meuble;
  final String eau;
  final String electricite;
  final bool parking;
  final int photos;
  final String repere;
  final int confirmeIlYa;
  final bool nouveau;
  final bool sponsorise;

  int get avance => loyer * moisAvance;
  int get caution => loyer * moisCaution;
  int get commission => loyer * commissionMois;
  int get coutEntree => vente ? loyer : avance + caution + commission;
  bool get agence => annonceur.badge.startsWith('Agence');
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
    this.prixDepuis = 5000,
    this.bio = '',
    this.interventions = 0,
    this.services = const [],
  });
  final String id;
  final String nom;
  final String metier;
  final double note;
  final int avis;
  final String zone;
  final Color couleur;
  final int prixDepuis;
  final String bio;
  final int interventions;
  final List<ServiceFixe> services;
}

/// Service vendu à prix fixe, réservable directement (E-SRV-06).
class ServiceFixe {
  const ServiceFixe(this.id, this.titre, this.prix, this.duree);
  final String id;
  final String titre;
  final int prix;
  final String duree;
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
    required this.id,
    required this.auteur,
    required this.texte,
    required this.verticale,
    required this.cibleId,
    required this.couleur,
    required this.likes,
    this.commentaires = '84',
    this.partages = '31',
    this.son = 'Son original',
    this.distance,
  });
  final String id;
  final String auteur;
  final String texte;
  final Verticale verticale;
  final String cibleId;
  final Color couleur;
  final String likes;
  final String commentaires;
  final String partages;
  final String son;
  final String? distance;
}

class Commentaire {
  const Commentaire(
    this.auteur,
    this.texte,
    this.quand,
    this.likes, {
    this.couleur = const Color(0xFF13385C),
    this.vendeur = false,
  });
  final String auteur;
  final String texte;
  final String quand;
  final int likes;
  final Color couleur;

  /// Réponse de l'auteur de la publication.
  final bool vendeur;
}

enum TypeConversation { privee, groupe, canal }

class Conversation {
  const Conversation({
    this.type = TypeConversation.privee,
    this.membres = 2,
    required this.id,
    required this.nom,
    required this.dernier,
    required this.quand,
    required this.couleur,
    this.nonLus = 0,
    this.annonce,
    this.enLigne = false,
    this.lu = true,
  });
  final TypeConversation type;
  final int membres;
  final String id;
  final String nom;
  final String dernier;
  final String quand;
  final Color couleur;
  final int nonLus;
  final String? annonce;
  final bool enLigne;

  /// Mon dernier message a été lu (double coche bleue).
  final bool lu;
}

class NotificationLive {
  const NotificationLive(
    this.titre,
    this.texte,
    this.quand,
    this.icone,
    this.route, {
    this.nouvelle = false,
  });
  final String titre;
  final String texte;
  final String quand;
  final IconData icone;
  final String route;
  final bool nouvelle;
}

/// Demande de visite reçue par une agence (E-IMMO-07).
class DemandeVisite {
  const DemandeVisite(
    this.id,
    this.visiteur,
    this.bienId,
    this.creneau,
    this.agent, {
    this.statut = 'Payée',
  });
  final String id;
  final String visiteur;
  final String bienId;
  final String creneau;
  final String agent;
  final String statut;
}
