part of 'market_screens.dart';

/// E-MKT-05 — Suivi de commande (acheteur) : produit, frise, QR de confirmation.
class EcranSuiviCommande extends ConsumerWidget {
  const EcranSuiviCommande({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref
        .watch(liveProvider)
        .achats
        .firstWhere(
          (c) => c.id == id,
          // Ouverture directe (démonstration) : commande d'exemple.
          orElse: () => Commande(
            id: id,
            produit: produitParId('p1'),
            total: 85000,
            mode: ModePaiement.avance,
            statut: StatutCommande.acceptee,
          ),
        );
    final termine = c.statut == StatutCommande.terminee;
    final remise = c.mode == ModePaiement.remise;
    final etapes = <EtapeFrise>[
      EtapeFrise(
        remise
            ? context.t.commandeReservee
            : context.t.payeeArgentBloqueParLive,
        context.t.aujourdHui1021,
        true,
      ),
      EtapeFrise(
        context.t.accepteeParLeVendeur,
        context.t.aujourdHui1034,
        true,
      ),
      EtapeFrise(
        remise ? context.t.payeeALaRemise : context.t.receptionConfirmee,
        termine ? context.t.aLInstant : context.t.enAttenteDeLaRemise,
        termine,
      ),
    ];
    final entete = Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Hero(
              tag: 'produit-${c.produit.id}',
              child: Vignette(
                couleur: c.produit.couleur,
                icone: c.produit.icone,
                hauteur: 64,
                largeur: 64,
                rayon: 8,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.produit.titre,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    c.produit.vendeur.nom,
                    style: const TextStyle(color: LiveColors.gris),
                  ),
                ],
              ),
            ),
            Text(
              fcfa(c.total),
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.commandeNumero(c.id)),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/accueil'),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => context.push('/conversation'),
            icon: const Icon(Icons.chat_bubble_outline, size: 18),
            label: Text(context.t.ecrire),
          ),
        ],
      ),
      body: DeuxColonnes(
        principale: [
          Apparition(child: entete),
          const SizedBox(height: 20),
          Apparition(rang: 1, child: Frise(etapes: etapes)),
          const SizedBox(height: 12),
          if (!termine)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => context.push('/livraison/${c.id}'),
                icon: const Icon(Icons.two_wheeler_rounded, size: 18),
                label: Text(context.t.livraisonLiveSuivreLeLivreur),
              ),
            ),
          if (!termine && !remise)
            Apparition(
              rang: 2,
              child: BandeauProtection(context.t.votreArgentEstBloqueJusqu),
            ),
        ],
        secondaire: [
          if (termine) ...[
            const SizedBox(height: 8),
            const Center(child: CocheAnimee()),
            const SizedBox(height: 12),
            Text(
              remise
                  ? context.t.paiementRecuMerci
                  : context.t.receptionConfirmeeLeVendeurEst,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () => _avis(context),
              child: Text(context.t.laisserUnAvis),
            ),
          ] else if (!remise) ...[
            Apparition(
              rang: 2,
              child: CarteQr(
                titre: context.t.confirmerLaRemise,
                donnee: 'live://remise/${c.id}',
                codeSecours: 'LV-K4827',
                consigne: context.t.montrezLeAuVendeurQuand,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: () =>
                  ref.read(liveProvider.notifier).confirmerReception(c.id),
              child: Text(context.t.jAiRecuLeProduit),
            ),
            TextButton(
              onPressed: () => _probleme(context),
              child: Text(context.t.signalerUnProbleme),
            ),
            const SizedBox(height: 8),
            BoutonSimulation(
              texte: context.t.simulerLeVendeurScanneVotre,
              onTap: () =>
                  ref.read(liveProvider.notifier).confirmerReception(c.id),
            ),
          ] else ...[
            Text(
              context.t.verifiezLeProduitPuisPayez,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              context.t.leVendeurVousEnverraUne,
              style: TextStyle(color: LiveColors.gris),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                ref
                    .read(liveProvider.notifier)
                    .preparerPaiement(
                      PaiementEnCours(
                        type: TypePaiement.commande,
                        montant: c.total,
                        libelle: c.produit.titre,
                        beneficiaire: c.produit.vendeur.nom,
                        cibleId: c.id,
                        modeCommande: ModePaiement.remise,
                      ),
                    );
                context.push('/payer');
              },
              child: Text(context.t.payerMaintenantMontant(fcfa(c.total))),
            ),
          ],
        ],
      ),
    );
  }

  void _avis(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => const _FeuilleAvis(),
    );
  }

  void _probleme(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.t.unProbleme),
        content: Text(context.t.vousPourrezDecrireLeProbleme),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.t.ok),
          ),
        ],
      ),
    );
  }
}

class _FeuilleAvis extends StatefulWidget {
  const _FeuilleAvis();

  @override
  State<_FeuilleAvis> createState() => _FeuilleAvisState();
}

class _FeuilleAvisState extends State<_FeuilleAvis> {
  var _note = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.t.votreAvis,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  onPressed: () => setState(() => _note = i),
                  icon: Icon(
                    i <= _note ? Icons.star : Icons.star_border,
                    color: LiveColors.ambre,
                    size: 36,
                  ),
                ),
            ],
          ),
          TextField(
            decoration: InputDecoration(
              hintText: context.t.votreCommentaireFacultatif,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _note == 0 ? null : () => Navigator.pop(context),
            child: Text(context.t.publierLAvis),
          ),
        ],
      ),
    );
  }
}
