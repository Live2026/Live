import 'mock.dart';

/// État du prototype, gardé en mémoire (tout est perdu au redémarrage).

enum ModePaiement { avance, remise }

enum StatutCommande { payee, acceptee, remise, terminee, reservee }

class Commande {
  const Commande({
    required this.id,
    required this.produit,
    required this.total,
    required this.mode,
    required this.statut,
    this.acheteur,
  });
  final String id;
  final Produit produit;
  final int total;
  final ModePaiement mode;
  final StatutCommande statut;

  /// Renseigné pour les ventes (l'utilisateur est le vendeur).
  final String? acheteur;

  Commande avec(StatutCommande s) => Commande(
    id: id,
    produit: produit,
    total: total,
    mode: mode,
    statut: s,
    acheteur: acheteur,
  );
}

enum StatutVisite { payee, confirmee, reservee }

class Visite {
  const Visite({
    required this.id,
    required this.bien,
    required this.creneau,
    required this.statut,
  });
  final String id;
  final Bien bien;
  final String creneau;
  final StatutVisite statut;

  Visite avec(StatutVisite s) =>
      Visite(id: id, bien: bien, creneau: creneau, statut: s);
}

enum StatutPrestation { acompte, demarree, terminee }

class Prestation {
  const Prestation({
    required this.id,
    required this.devis,
    required this.statut,
  });
  final String id;
  final Devis devis;
  final StatutPrestation statut;
}

class Mouvement {
  const Mouvement(
    this.libelle,
    this.montant,
    this.quand, {
    this.enAttente = false,
  });
  final String libelle;
  final int montant;
  final String quand;
  final bool enAttente;
}

enum TypePaiement {
  commande,
  visite,
  acompte,
  credits,

  /// Acompte de réservation d'un logement après la visite (E-IMMO-06).
  reservation,

  /// Service à prix fixe payé à la réservation (E-SRV-06).
  service,

  /// Abonnement Live Pro (C-STATS-AVANCEES).
  abonnement,

  /// Boost d'une annonce (F-PRO-01), payé par Mobile Money.
  boost,

  /// Panier de contenus numériques (cours, PDF, vidéos…).
  numerique,
}

/// Pack de Crédits Live (document 19, section 2.2).
class Pack {
  const Pack(this.id, this.prix, this.credits, {this.bonus});
  final String id;
  final int prix;
  final int credits;
  final String? bonus;
}

const packs = [
  Pack('p500', 500, 50),
  Pack('p1000', 1000, 110, bonus: '+10 %'),
  Pack('p2500', 2500, 300, bonus: '+20 %'),
  Pack('p5000', 5000, 650, bonus: '+30 %'),
];

/// Document produit par Live IA et conservé dans « Mes documents ».
class DocumentIa {
  const DocumentIa({
    required this.id,
    required this.type,
    required this.titre,
    required this.contenu,
    required this.quand,
  });
  final String id;
  final String type;
  final String titre;
  final List<(String, String)> contenu;
  final String quand;
}

/// Paiement en cours de saisie : ce qu'on paie et ce qu'il faut faire en cas de succès.
class PaiementEnCours {
  const PaiementEnCours({
    required this.type,
    required this.montant,
    required this.libelle,
    required this.beneficiaire,
    required this.cibleId,
    this.modeCommande = ModePaiement.avance,
    this.creneau,
  });
  final TypePaiement type;
  final int montant;
  final String libelle;
  final String beneficiaire;
  final String cibleId;
  final ModePaiement modeCommande;
  final String? creneau;
}

/// Réclamation ouverte sur une commande, une visite ou une prestation (E-CONF-03/04).
class Reclamation {
  const Reclamation({
    required this.id,
    required this.objet,
    required this.motif,
    required this.montant,
    this.etape = 1,
  });
  final String id;
  final String objet;
  final String motif;
  final int montant;

  /// 1 ouverte, 2 réponse de l'autre partie, 3 décision de Live.
  final int etape;
}

/// Espace professionnel créé par l'utilisateur (boutique, agence…).
class Espace {
  const Espace(this.nom, this.type);
  final String nom;
  final TypeEspace type;
}

class LiveState {
  const LiveState({
    this.connecte = false,
    this.prenom = 'Grâce',
    this.telephone = '06 123 45 67',
    this.operateur = 'MTN',
    this.niveau = 1,
    this.pro = false,
    this.espaces = const [],
    this.achats = const [],
    this.ventes = const [],
    this.visites = const [],
    this.prestations = const [],
    this.mesAnnonces = const [],
    this.disponible = 184500,
    this.historique = const [
      Mouvement('Vente · Pagne 6 yards', 16920, 'hier'),
      Mouvement('Retrait MTN MoMo', -150000, 'lun.'),
      Mouvement('Vente · Robe wax ×2', 28200, 'lun.'),
    ],
    this.paiement,
    this.demandeEnvoyee = false,
    this.credits = 20,
    this.documents = const [],
    this.suivis = const {'grace'},
    this.favoris = const {'b3'},
    this.reclamations = const [],
    this.avisDonnes = const {},
    this.alertes = const [
      ('Studio · Poto-Poto · < 100 000 FCFA', true),
      ('iPhone · < 100 000 FCFA', true),
      ('Plombier · Moungali', false),
    ],
    this.biensPublies = const [],
    this.servicesPublies = const [],
    this.interets = const {},
    this.economieDonnees = true,
    this.panier = const [],
    this.bibliotheque = const {'n2'},
    this.candidatures = const {},
    this.contenusPublies = const [],
    this.opportunitesPubliees = const [],
  });

  final bool connecte;
  final String prenom;
  final String telephone;
  final String operateur;

  /// Niveau de confiance : 1 téléphone, 2 identité, 3 professionnel (docs/03).
  final int niveau;

  /// Abonnement Live Pro actif.
  final bool pro;
  final List<Espace> espaces;
  final List<Commande> achats;
  final List<Commande> ventes;
  final List<Visite> visites;
  final List<Prestation> prestations;
  final List<String> mesAnnonces;
  final int disponible;
  final List<Mouvement> historique;
  final PaiementEnCours? paiement;
  final bool demandeEnvoyee;

  /// Crédits Live (20 offerts à l'inscription).
  final int credits;
  final List<DocumentIa> documents;

  /// Comptes et espaces suivis (identifiants de vendeurs).
  final Set<String> suivis;

  /// Annonces enregistrées (identifiants de produits et de biens).
  final Set<String> favoris;
  final List<Reclamation> reclamations;

  /// Transactions déjà notées (un seul avis par transaction payée).
  final Set<String> avisDonnes;

  /// Recherches sauvegardées : (libellé, notifications actives).
  final List<(String, bool)> alertes;
  final List<String> biensPublies;
  final List<String> servicesPublies;
  final Set<String> interets;
  final bool economieDonnees;

  /// Contenus numériques dans le panier, puis achetés (bibliothèque).
  final List<String> panier;
  final Set<String> bibliotheque;

  /// Opportunités auxquelles l'utilisateur a postulé.
  final Set<String> candidatures;
  final List<String> contenusPublies;
  final List<String> opportunitesPubliees;

  bool get identiteVerifiee => niveau >= 2;

  int get enAttente =>
      historique.where((m) => m.enAttente).fold(0, (s, m) => s + m.montant);

  LiveState copyWith({
    bool? connecte,
    String? prenom,
    String? telephone,
    String? operateur,
    int? niveau,
    bool? pro,
    List<Espace>? espaces,
    List<Commande>? achats,
    List<Commande>? ventes,
    List<Visite>? visites,
    List<Prestation>? prestations,
    List<String>? mesAnnonces,
    int? disponible,
    List<Mouvement>? historique,
    PaiementEnCours? paiement,
    bool effacerPaiement = false,
    bool? demandeEnvoyee,
    int? credits,
    List<DocumentIa>? documents,
    Set<String>? suivis,
    Set<String>? favoris,
    List<Reclamation>? reclamations,
    Set<String>? avisDonnes,
    List<(String, bool)>? alertes,
    List<String>? biensPublies,
    List<String>? servicesPublies,
    Set<String>? interets,
    bool? economieDonnees,
    List<String>? panier,
    Set<String>? bibliotheque,
    Set<String>? candidatures,
    List<String>? contenusPublies,
    List<String>? opportunitesPubliees,
  }) {
    return LiveState(
      connecte: connecte ?? this.connecte,
      prenom: prenom ?? this.prenom,
      telephone: telephone ?? this.telephone,
      operateur: operateur ?? this.operateur,
      niveau: niveau ?? this.niveau,
      pro: pro ?? this.pro,
      espaces: espaces ?? this.espaces,
      achats: achats ?? this.achats,
      ventes: ventes ?? this.ventes,
      visites: visites ?? this.visites,
      prestations: prestations ?? this.prestations,
      mesAnnonces: mesAnnonces ?? this.mesAnnonces,
      disponible: disponible ?? this.disponible,
      historique: historique ?? this.historique,
      paiement: effacerPaiement ? null : (paiement ?? this.paiement),
      demandeEnvoyee: demandeEnvoyee ?? this.demandeEnvoyee,
      credits: credits ?? this.credits,
      documents: documents ?? this.documents,
      suivis: suivis ?? this.suivis,
      favoris: favoris ?? this.favoris,
      reclamations: reclamations ?? this.reclamations,
      avisDonnes: avisDonnes ?? this.avisDonnes,
      alertes: alertes ?? this.alertes,
      biensPublies: biensPublies ?? this.biensPublies,
      servicesPublies: servicesPublies ?? this.servicesPublies,
      interets: interets ?? this.interets,
      economieDonnees: economieDonnees ?? this.economieDonnees,
      panier: panier ?? this.panier,
      bibliotheque: bibliotheque ?? this.bibliotheque,
      candidatures: candidatures ?? this.candidatures,
      contenusPublies: contenusPublies ?? this.contenusPublies,
      opportunitesPubliees: opportunitesPubliees ?? this.opportunitesPubliees,
    );
  }
}
