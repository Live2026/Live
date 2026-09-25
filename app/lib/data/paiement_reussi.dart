import 'etat.dart';
import 'mock.dart';

/// Effet d'un paiement réussi sur l'état : crée la commande, la visite, la
/// prestation, etc. Renvoie le nouvel état et l'identifiant de l'objet créé.
(LiveState, String) appliquerPaiement(
  LiveState etat,
  PaiementEnCours p,
  String Function(String prefixe) numero,
) {
  var state = etat;
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
        return (state, p.cibleId);
      }
      final id = numero('LV');
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
      return (state, id);
    case TypePaiement.visite:
      final id = numero('VI');
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
      return (state, id);
    case TypePaiement.acompte:
      final id = numero('PR');
      final devis = devisRecus.firstWhere((d) => d.prestataire.id == p.cibleId);
      state = state.copyWith(
        prestations: [
          Prestation(id: id, devis: devis, statut: StatutPrestation.acompte),
          ...state.prestations,
        ],
        effacerPaiement: true,
        demandeEnvoyee: false,
      );
      return (state, id);
    case TypePaiement.reservation:
      state = state.copyWith(
        visites: [
          for (final v in state.visites)
            v.id == p.cibleId ? v.avec(StatutVisite.reservee) : v,
        ],
        effacerPaiement: true,
      );
      return (state, p.cibleId);
    case TypePaiement.service:
      final [idPro, idService] = p.cibleId.split('|');
      final pro = prestataireParId(idPro);
      final service = pro.services.firstWhere((s) => s.id == idService);
      final id = numero('PR');
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
      return (state, id);
    case TypePaiement.abonnement:
      state = state.copyWith(pro: true, effacerPaiement: true);
      return (state, 'pro');
    case TypePaiement.boost:
      state = state.copyWith(effacerPaiement: true);
      return (state, p.cibleId);
    case TypePaiement.numerique:
      state = state.copyWith(
        bibliotheque: {...state.bibliotheque, ...p.cibleId.split(',')},
        panier: const [],
        effacerPaiement: true,
      );
      return (state, numero('NU'));
    case TypePaiement.fan:
      state = state.copyWith(
        fans: {...state.fans, p.cibleId},
        effacerPaiement: true,
      );
      return (state, p.cibleId);
    case TypePaiement.sejour:
      final id = numero('SJ');
      state = state.copyWith(
        sejoursReserves: [id, ...state.sejoursReserves],
        effacerPaiement: true,
      );
      return (state, id);
    case TypePaiement.publicite:
      final id = numero('PUB');
      state = state.copyWith(
        publicites: [p.libelle, ...state.publicites],
        effacerPaiement: true,
      );
      return (state, id);
    case TypePaiement.cotisation:
      state = state.copyWith(
        cotisations: {...state.cotisations, p.cibleId},
        effacerPaiement: true,
      );
      return (state, numero('TO'));
    case TypePaiement.achatGroupe:
      state = state.copyWith(
        groupes: {...state.groupes, p.cibleId},
        effacerPaiement: true,
      );
      return (state, numero('AG'));
    case TypePaiement.facture:
    case TypePaiement.recharge:
      state = state.copyWith(
        facturesPayees: {...state.facturesPayees, p.cibleId},
        effacerPaiement: true,
      );
      return (state, numero('FA'));
    case TypePaiement.pourUnProche:
    case TypePaiement.transfert:
      state = state.copyWith(
        envois: [p.libelle, ...state.envois],
        effacerPaiement: true,
      );
      return (state, numero(p.type == TypePaiement.transfert ? 'TR' : 'PP'));
    case TypePaiement.livePlus:
      state = state.copyWith(
        formulePlus: p.cibleId,
        credits: state.credits + (p.cibleId == 'pro' ? 500 : 200),
        effacerPaiement: true,
      );
      return (state, p.cibleId);
    case TypePaiement.credits:
      final pack = packs.firstWhere((k) => k.id == p.cibleId);
      state = state.copyWith(
        credits: state.credits + pack.credits,
        effacerPaiement: true,
      );
      return (state, pack.id);
  }
}
