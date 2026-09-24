import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/format.dart';
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

enum StatutVisite { payee, confirmee }

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

enum TypePaiement { commande, visite, acompte, credits }

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

class LiveState {
  const LiveState({
    this.connecte = false,
    this.prenom = 'Grâce',
    this.telephone = '06 123 45 67',
    this.operateur = 'MTN',
    this.identiteVerifiee = true,
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
  });

  final bool connecte;
  final String prenom;
  final String telephone;
  final String operateur;
  final bool identiteVerifiee;
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

  int get enAttente =>
      historique.where((m) => m.enAttente).fold(0, (s, m) => s + m.montant);

  LiveState copyWith({
    bool? connecte,
    String? prenom,
    String? telephone,
    String? operateur,
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
  }) {
    return LiveState(
      connecte: connecte ?? this.connecte,
      prenom: prenom ?? this.prenom,
      telephone: telephone ?? this.telephone,
      operateur: operateur ?? this.operateur,
      identiteVerifiee: identiteVerifiee,
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
    );
  }
}

class LiveStore extends Notifier<LiveState> {
  var _compteur = 482;

  @override
  LiveState build() => LiveState(ventes: ventesInitiales());

  String _numero(String prefixe) =>
      '$prefixe-${(_compteur++).toString().padLeft(5, '0')}';

  void connecter({
    required String prenom,
    required String telephone,
    required String operateur,
  }) {
    state = state.copyWith(
      connecte: true,
      prenom: prenom.isEmpty ? 'Grâce' : prenom,
      telephone: telephone,
      operateur: operateur,
    );
  }

  void preparerPaiement(PaiementEnCours p) =>
      state = state.copyWith(paiement: p);

  /// Réserve une commande « payer à la remise » (aucun paiement à ce stade).
  String reserverCommande(Produit produit, int total) {
    final id = _numero('LV');
    state = state.copyWith(
      achats: [
        Commande(
          id: id,
          produit: produit,
          total: total,
          mode: ModePaiement.remise,
          statut: StatutCommande.reservee,
        ),
        ...state.achats,
      ],
    );
    return id;
  }

  /// Applique un paiement réussi et renvoie l'identifiant de l'objet créé.
  String paiementReussi() {
    final p = state.paiement!;
    switch (p.type) {
      case TypePaiement.commande:
        final existante = state.achats.where((c) => c.id == p.cibleId).toList();
        if (existante.isNotEmpty) {
          // Paiement d'une commande « payer à la remise » : terminée immédiatement.
          state = state.copyWith(
            achats: [
              for (final c in state.achats)
                c.id == p.cibleId ? c.avec(StatutCommande.terminee) : c,
            ],
            effacerPaiement: true,
          );
          return p.cibleId;
        }
        final id = _numero('LV');
        final commande = Commande(
          id: id,
          produit: produitParId(p.cibleId),
          total: p.montant,
          mode: ModePaiement.avance,
          statut: StatutCommande.acceptee,
        );
        state = state.copyWith(
          achats: [commande, ...state.achats],
          effacerPaiement: true,
        );
        return id;
      case TypePaiement.visite:
        final id = _numero('VI');
        final visite = Visite(
          id: id,
          bien: bienParId(p.cibleId),
          creneau: p.creneau ?? 'Mar 30 · 10:30',
          statut: StatutVisite.payee,
        );
        state = state.copyWith(
          visites: [visite, ...state.visites],
          effacerPaiement: true,
        );
        return id;
      case TypePaiement.acompte:
        final id = _numero('PR');
        final devis = devisRecus.firstWhere(
          (d) => d.prestataire.id == p.cibleId,
        );
        state = state.copyWith(
          prestations: [
            Prestation(id: id, devis: devis, statut: StatutPrestation.acompte),
            ...state.prestations,
          ],
          effacerPaiement: true,
          demandeEnvoyee: false,
        );
        return id;
      case TypePaiement.credits:
        final pack = packs.firstWhere((k) => k.id == p.cibleId);
        state = state.copyWith(
          credits: state.credits + pack.credits,
          effacerPaiement: true,
        );
        return pack.id;
    }
  }

  /// Débite des crédits pour un service Live IA ; faux si le solde est insuffisant.
  bool depenserCredits(int n) {
    if (n > state.credits) return false;
    state = state.copyWith(credits: state.credits - n);
    return true;
  }

  /// Recrédit automatique en cas d'échec d'une génération (R-CR-05).
  void recrediter(int n) => state = state.copyWith(credits: state.credits + n);

  String ajouterDocument(
    String type,
    String titre,
    List<(String, String)> contenu,
  ) {
    final id = _numero('DOC');
    state = state.copyWith(
      documents: [
        DocumentIa(
          id: id,
          type: type,
          titre: titre,
          contenu: contenu,
          quand: "à l'instant",
        ),
        ...state.documents,
      ],
    );
    return id;
  }

  void confirmerReception(String id) {
    state = state.copyWith(
      achats: [
        for (final c in state.achats)
          c.id == id ? c.avec(StatutCommande.terminee) : c,
      ],
    );
  }

  void confirmerVisite(String id) {
    state = state.copyWith(
      visites: [
        for (final v in state.visites)
          v.id == id
              ? Visite(
                  id: v.id,
                  bien: v.bien,
                  creneau: v.creneau,
                  statut: StatutVisite.confirmee,
                )
              : v,
      ],
    );
  }

  void avancerPrestation(String id) {
    state = state.copyWith(
      prestations: [
        for (final p in state.prestations)
          p.id == id
              ? Prestation(
                  id: p.id,
                  devis: p.devis,
                  statut: p.statut == StatutPrestation.acompte
                      ? StatutPrestation.demarree
                      : StatutPrestation.terminee,
                )
              : p,
      ],
    );
  }

  void envoyerDemande() => state = state.copyWith(demandeEnvoyee: true);

  /// Publie une annonce et simule une commande reçue d'un acheteur.
  void publier(String titre, int prix) {
    final produit = Produit(
      id: 'mien-${state.mesAnnonces.length}',
      titre: titre,
      prix: prix,
      quartier: 'Moungali',
      vendeur: Vendeur(state.prenom),
      couleur: const Color(0xFF6D28D9),
      icone: Icons.sell,
    );
    final vente = Commande(
      id: _numero('LV'),
      produit: produit,
      total: prix,
      mode: ModePaiement.avance,
      statut: StatutCommande.payee,
      acheteur: 'Merveille K.',
    );
    state = state.copyWith(
      mesAnnonces: [titre, ...state.mesAnnonces],
      ventes: [vente, ...state.ventes],
    );
  }

  void accepterVente(String id) {
    state = state.copyWith(
      ventes: [
        for (final v in state.ventes)
          v.id == id ? v.avec(StatutCommande.acceptee) : v,
      ],
    );
  }

  /// Le vendeur scanne le QR de l'acheteur : la vente est terminée et le montant net crédité.
  void remettreVente(String id) {
    final vente = state.ventes.firstWhere((v) => v.id == id);
    final net = vente.total - commission(vente.total, 0.06, minimum: 100);
    state = state.copyWith(
      ventes: [
        for (final v in state.ventes)
          v.id == id ? v.avec(StatutCommande.terminee) : v,
      ],
      disponible: state.disponible + net,
      historique: [
        Mouvement('Vente · ${vente.produit.titre}', net, "à l'instant"),
        ...state.historique,
      ],
    );
  }

  bool retirer(int montant) {
    if (montant <= 0 || montant > state.disponible) return false;
    state = state.copyWith(
      disponible: state.disponible - montant,
      historique: [
        Mouvement(
          'Retrait ${state.operateur == 'MTN' ? 'MTN MoMo' : 'Airtel Money'}',
          -montant,
          "à l'instant",
        ),
        ...state.historique,
      ],
    );
    return true;
  }

  void reinitialiser() => state = LiveState(ventes: ventesInitiales());
}

final liveProvider = NotifierProvider<LiveStore, LiveState>(LiveStore.new);

/// Ventes déjà réalisées par le compte de démonstration (historique de « Mes ventes »).
List<Commande> ventesInitiales() => [
  Commande(
    id: 'LV-00471',
    produit: produitParId('p6'),
    total: 18000,
    mode: ModePaiement.avance,
    statut: StatutCommande.terminee,
    acheteur: 'Jordy M.',
  ),
  Commande(
    id: 'LV-00466',
    produit: produitParId('p2'),
    total: 30000,
    mode: ModePaiement.remise,
    statut: StatutCommande.terminee,
    acheteur: 'Nadège L.',
  ),
];
