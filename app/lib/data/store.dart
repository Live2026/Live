import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/format.dart';
import 'etat.dart';
import 'mock.dart';

export 'etat.dart';

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
      case TypePaiement.reservation:
        state = state.copyWith(
          visites: [
            for (final v in state.visites)
              v.id == p.cibleId ? v.avec(StatutVisite.reservee) : v,
          ],
          effacerPaiement: true,
        );
        return p.cibleId;
      case TypePaiement.service:
        final [idPro, idService] = p.cibleId.split('|');
        final pro = prestataireParId(idPro);
        final service = pro.services.firstWhere((s) => s.id == idService);
        final id = _numero('PR');
        final devis = Devis(
          prestataire: pro,
          mainOeuvre: service.prix,
          materiel: 0,
          acompte: service.prix,
          quand: p.creneau ?? 'Demain 10:00',
        );
        state = state.copyWith(
          prestations: [
            Prestation(id: id, devis: devis, statut: StatutPrestation.acompte),
            ...state.prestations,
          ],
          effacerPaiement: true,
        );
        return id;
      case TypePaiement.abonnement:
        state = state.copyWith(pro: true, effacerPaiement: true);
        return 'pro';
      case TypePaiement.boost:
        state = state.copyWith(effacerPaiement: true);
        return p.cibleId;
      case TypePaiement.numerique:
        state = state.copyWith(
          bibliotheque: {...state.bibliotheque, ...p.cibleId.split(',')},
          panier: const [],
          effacerPaiement: true,
        );
        return _numero('NU');
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
          v.id == id ? v.avec(StatutVisite.confirmee) : v,
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

  /// Refus d'une commande par le vendeur (motif obligatoire) : l'acheteur
  /// est remboursé immédiatement, la commande sort de la liste.
  void refuserVente(String id, String motif) => state = state.copyWith(
    ventes: [
      for (final v in state.ventes)
        if (v.id != id) v,
    ],
  );

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

  // ---- Super-pouvoirs et compte ----

  /// Vérification d'identité (N2) : validée instantanément dans le prototype.
  void verifierIdentite() {
    if (state.niveau < 2) state = state.copyWith(niveau: 2);
  }

  /// Crée un espace pro vérifié (N3).
  void creerEspace(String nom, TypeEspace type) {
    state = state.copyWith(
      niveau: 3,
      espaces: [...state.espaces, Espace(nom, type)],
    );
  }

  void basculerSuivi(String id) => state = state.copyWith(
    suivis: state.suivis.contains(id)
        ? ({...state.suivis}..remove(id))
        : {...state.suivis, id},
  );

  void basculerFavori(String id) => state = state.copyWith(
    favoris: state.favoris.contains(id)
        ? ({...state.favoris}..remove(id))
        : {...state.favoris, id},
  );

  // ---- Confiance ----

  void donnerAvis(String cle) =>
      state = state.copyWith(avisDonnes: {...state.avisDonnes, cle});

  String ouvrirReclamation(String objet, String motif, int montant) {
    final id = _numero('RC');
    state = state.copyWith(
      reclamations: [
        Reclamation(id: id, objet: objet, motif: motif, montant: montant),
        ...state.reclamations,
      ],
    );
    return id;
  }

  void avancerReclamation(String id) => state = state.copyWith(
    reclamations: [
      for (final r in state.reclamations)
        r.id == id
            ? Reclamation(
                id: r.id,
                objet: r.objet,
                motif: r.motif,
                montant: r.montant,
                etape: (r.etape + 1).clamp(1, 3),
              )
            : r,
    ],
  );

  // ---- Recherche et préférences ----

  void basculerAlerte(int i) => state = state.copyWith(
    alertes: [
      for (final (j, a) in state.alertes.indexed) j == i ? (a.$1, !a.$2) : a,
    ],
  );

  void ajouterAlerte(String libelle) =>
      state = state.copyWith(alertes: [(libelle, true), ...state.alertes]);

  void choisirInterets(Set<String> interets) =>
      state = state.copyWith(interets: interets);

  void basculerEconomieDonnees() =>
      state = state.copyWith(economieDonnees: !state.economieDonnees);

  // ---- Publication ----

  void publierBien(String titre) =>
      state = state.copyWith(biensPublies: [titre, ...state.biensPublies]);

  void publierService(String titre) => state = state.copyWith(
    servicesPublies: [titre, ...state.servicesPublies],
  );

  void publierContenu(String titre) => state = state.copyWith(
    contenusPublies: [titre, ...state.contenusPublies],
  );

  void publierOpportunite(String titre) => state = state.copyWith(
    opportunitesPubliees: [titre, ...state.opportunitesPubliees],
  );

  // ---- Apprendre et Opportunités ----

  void ajouterAuPanier(String id) {
    if (state.panier.contains(id) || state.bibliotheque.contains(id)) return;
    state = state.copyWith(panier: [...state.panier, id]);
  }

  void retirerDuPanier(String id) => state = state.copyWith(
    panier: [
      for (final x in state.panier)
        if (x != id) x,
    ],
  );

  void postuler(String id) =>
      state = state.copyWith(candidatures: {...state.candidatures, id});

  /// Paiement avec le solde Live (gains disponibles) : débit immédiat.
  bool debiterSolde(int montant, String libelle) {
    if (montant > state.disponible) return false;
    state = state.copyWith(
      disponible: state.disponible - montant,
      historique: [
        Mouvement('Paiement · $libelle', -montant, "à l'instant"),
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
    id: 'LV-00479',
    produit: produitParId('p8'),
    total: 25000,
    mode: ModePaiement.avance,
    statut: StatutCommande.payee,
    acheteur: 'Prince B.',
  ),
  Commande(
    id: 'LV-00475',
    produit: produitParId('p2'),
    total: 17000,
    mode: ModePaiement.avance,
    statut: StatutCommande.acceptee,
    acheteur: 'Merveille K.',
  ),
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
