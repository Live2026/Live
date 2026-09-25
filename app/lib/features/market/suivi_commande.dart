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
        remise ? 'Commande réservée' : 'Payée · argent bloqué par Live',
        "Aujourd'hui 10:21",
        true,
      ),
      const EtapeFrise('Acceptée par le vendeur', "Aujourd'hui 10:34", true),
      EtapeFrise(
        remise ? 'Payée à la remise' : 'Réception confirmée',
        termine ? "À l'instant" : 'En attente de la remise',
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
        title: Text('Commande ${c.id}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/accueil'),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => context.push('/conversation'),
            icon: const Icon(Icons.chat_bubble_outline, size: 18),
            label: const Text('Écrire'),
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
                label: const Text(
                  'Livraison Live : suivre le livreur (aperçu phase 3)',
                ),
              ),
            ),
          if (!termine && !remise)
            const Apparition(
              rang: 2,
              child: BandeauProtection(
                "Votre argent est bloqué jusqu'à votre confirmation.",
              ),
            ),
        ],
        secondaire: [
          if (termine) ...[
            const SizedBox(height: 8),
            const Center(child: CocheAnimee()),
            const SizedBox(height: 12),
            Text(
              remise
                  ? 'Paiement reçu. Merci !'
                  : 'Réception confirmée. Le vendeur est payé.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () => _avis(context),
              child: const Text('Laisser un avis'),
            ),
          ] else if (!remise) ...[
            Apparition(
              rang: 2,
              child: CarteQr(
                titre: 'Confirmer la remise',
                donnee: 'live://remise/${c.id}',
                codeSecours: 'LV-K4827',
                consigne:
                    'Montrez-le au vendeur quand vous avez vérifié le produit.',
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: () =>
                  ref.read(liveProvider.notifier).confirmerReception(c.id),
              child: const Text("J'ai reçu le produit"),
            ),
            TextButton(
              onPressed: () => _probleme(context),
              child: const Text('Signaler un problème'),
            ),
            const SizedBox(height: 8),
            BoutonSimulation(
              texte: 'Simuler : le vendeur scanne votre QR',
              onTap: () =>
                  ref.read(liveProvider.notifier).confirmerReception(c.id),
            ),
          ] else ...[
            Text(
              'Vérifiez le produit, puis payez.',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text(
              "Le vendeur vous enverra une demande MoMo ou Airtel. Elle n'arrive pas ? Payez vous-même :",
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
              child: Text('Payer maintenant ${fcfa(c.total)}'),
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
        title: const Text('Un problème ?'),
        content: const Text(
          "Vous pourrez décrire le problème et joindre des photos. L'argent reste bloqué jusqu'à la solution.\n\n(Écran de réclamation non inclus dans ce prototype.)",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
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
          const Text(
            'Votre avis',
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
          const TextField(
            decoration: InputDecoration(
              hintText: 'Votre commentaire (facultatif)',
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _note == 0 ? null : () => Navigator.pop(context),
            child: const Text("Publier l'avis"),
          ),
        ],
      ),
    );
  }
}
