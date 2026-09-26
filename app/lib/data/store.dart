import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/format.dart';
import 'etat.dart';
import 'mock.dart';
import 'paiement_reussi.dart';
import 'store_local.dart';
import 'ventes_initiales.dart';

export 'etat.dart';

class LiveStore extends Notifier<LiveState> with PersistanceLocale {
  var _compteur = 482;

  @override
  LiveState build() {
    chargerLocal();
    return LiveState(ventes: ventesInitiales());
  }

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
    final (etat, id) = appliquerPaiement(state, state.paiement!, _numero);
    state = etat;
    return id;
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

  // ---- Relations ----

  Set<String> _bascule(Set<String> s, String id) =>
      s.contains(id) ? ({...s}..remove(id)) : {...s, id};

  /// Bloquer : on ne se suit plus dans aucun sens, plus de messages.
  void bloquer(String id) => state = state.copyWith(
    bloques: {...state.bloques, id},
    suivis: {...state.suivis}..remove(id),
    retires: {...state.retires, id},
  );

  void debloquer(String id) =>
      state = state.copyWith(bloques: {...state.bloques}..remove(id));

  /// Retirer un abonné, sans le bloquer ni le prévenir.
  void retirerAbonne(String id) =>
      state = state.copyWith(retires: {...state.retires, id});

  void basculerSourdine(String id) =>
      state = state.copyWith(sourdine: _bascule(state.sourdine, id));

  void basculerCloche(String id) =>
      state = state.copyWith(cloches: _bascule(state.cloches, id));

  void basculerFavori(String id) {
    final present = !state.favoris.contains(id);
    state = state.copyWith(
      favoris: present
          ? {...state.favoris, id}
          : ({...state.favoris}..remove(id)),
    );
    garderFavori(id, present: present);
  }

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

  void choisirInterets(Set<String> interets) {
    state = state.copyWith(interets: interets);
    garder('interets', interets.join('|'));
  }

  void basculerEconomieDonnees() {
    state = state.copyWith(economieDonnees: !state.economieDonnees);
    garder('economie', state.economieDonnees ? '1' : '0');
  }

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

  /// Cadeau envoyé pendant un direct, prélevé sur le solde Live.
  bool envoyerCadeau(int prix, String nom) {
    if (!debiterSolde(prix, 'Cadeau $nom')) return false;
    state = state.copyWith(cadeauxEnvoyes: state.cadeauxEnvoyes + prix);
    return true;
  }

  void choisirPays(String ville) {
    state = state.copyWith(pays: ville);
    garder('pays', ville);
  }

  void choisirDevise(String code) {
    state = state.copyWith(devise: code);
    garder('devise', code);
  }

  /// Photo de profil (octets de l'image), ou null pour la retirer.
  void choisirPhoto(Uint8List? octets) {
    state = octets == null
        ? state.copyWith(retirerPhoto: true)
        : state.copyWith(photoProfil: octets);
  }

  void choisirLangue(String code) {
    state = state.copyWith(langue: code);
    garder('langue', code);
  }

  /// Demande au support Live ; renvoie son numéro (SP-…).
  String ecrireSupport(String sujet, String message) {
    final id = 'SP-${(10421 + state.demandesSupport.length)}';
    state = state.copyWith(
      demandesSupport: [(id, sujet, message), ...state.demandesSupport],
    );
    return id;
  }

  /// Transfert reçu de l'étranger, versé sur le compte Mobile Money.
  void retirerTransfert(String id) => state = state.copyWith(
    transfertsRetires: {...state.transfertsRetires, id},
  );

  void reinitialiser() => state = LiveState(ventes: ventesInitiales());
}

final liveProvider = NotifierProvider<LiveStore, LiveState>(LiveStore.new);
