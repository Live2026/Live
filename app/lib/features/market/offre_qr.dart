part of 'market_screens.dart';

/// E-MKT-03 — Faire une offre de prix (panneau du bas).
Future<void> ouvrirOffre(BuildContext context, Produit p) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    backgroundColor: LiveColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _FeuilleOffre(produit: p),
  );
}

class _FeuilleOffre extends StatefulWidget {
  const _FeuilleOffre({required this.produit});
  final Produit produit;

  @override
  State<_FeuilleOffre> createState() => _FeuilleOffreState();
}

class _FeuilleOffreState extends State<_FeuilleOffre> {
  late var _montant = (widget.produit.prix * 0.9).round() ~/ 1000 * 1000;

  @override
  Widget build(BuildContext context) {
    final p = widget.produit;
    final remise = ((1 - _montant / p.prix) * 100).round();
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.t.marketFaireUneOffre,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          Text(
            context.t.marketTitrePrixDemande(p.titre, fcfa(p.prix)),
            style: const TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 20),
          Center(
            child: ChiffreAnime(
              valeur: _montant,
              format: fcfa,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
            ),
          ),
          Center(
            child: Text(
              remise > 0
                  ? context.t.marketPourcentSousPrix(remise)
                  : context.t.marketPrixDemande,
              style: TextStyle(
                color: remise > 20 ? LiveColors.erreur : LiveColors.gris,
              ),
            ),
          ),
          Slider(
            value: _montant.toDouble(),
            min: (p.prix * 0.6).roundToDouble(),
            max: p.prix.toDouble(),
            divisions: 40,
            onChanged: (v) => setState(() => _montant = v.round() ~/ 500 * 500),
          ),
          Wrap(
            spacing: 8,
            children: [
              for (final r in const [5, 10, 15])
                ActionChip(
                  label: Text('−$r %'),
                  onPressed: () => setState(
                    () => _montant =
                        (p.prix * (100 - r) / 100).round() ~/ 500 * 500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            context.t.marketSiLeVendeurAccepteVous,
            style: TextStyle(color: LiveColors.gris, fontSize: 13),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      context.t.marketOffreEnvoyee(fcfa(_montant), p.vendeur.nom),
                    ),
                  ),
                );
                context.push('/conversation');
              },
              child: Text(context.t.marketEnvoyerOffre(fcfa(_montant))),
            ),
          ),
        ],
      ),
    );
  }
}

/// E-MKT-09 — QR de paiement du vendeur (« payer à la remise ») : l'acheteur
/// le scanne avec son téléphone et valide avec son code MoMo ou Airtel.
class EcranQrPaiement extends ConsumerStatefulWidget {
  const EcranQrPaiement({super.key, required this.id});
  final String id;

  @override
  ConsumerState<EcranQrPaiement> createState() => _EcranQrPaiementState();
}

class _EcranQrPaiementState extends ConsumerState<EcranQrPaiement> {
  var _paye = false;

  @override
  Widget build(BuildContext context) {
    final ventes = ref.watch(liveProvider).ventes;
    final v = ventes.firstWhere(
      (x) => x.id == widget.id,
      orElse: () => ventes.first,
    );
    return Scaffold(
      appBar: AppBar(title: Text(context.t.marketEncaisserALaRemise)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            fcfa(v.total),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
          ),
          Text(
            '${v.produit.titre} · ${v.acheteur ?? context.t.marketAcheteur}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _paye
                ? Column(
                    key: ValueKey('paye'),
                    children: [
                      CocheAnimee(taille: 96),
                      Text(
                        context.t.marketPaiementRecu,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        context.t.marketVerseSurVotreSoldeApres,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : CarteQr(
                    key: const ValueKey('qr'),
                    titre: context.t.marketScannerPourPayer,
                    donnee: 'live://payer/${v.id}',
                    codeSecours: 'LV-P7731',
                    consigne: context.t.marketLAcheteurScanneCeQr,
                  ),
          ),
          const SizedBox(height: 16),
          if (!_paye)
            BoutonSimulation(
              texte: context.t.marketSimulerLAcheteurPaie,
              onTap: () => setState(() => _paye = true),
            )
          else
            FilledButton(
              onPressed: () => context.go('/mes-ventes'),
              child: Text(context.t.marketRetourAMesVentes),
            ),
        ],
      ),
    );
  }
}

/// F-PRO-01 — Booster une annonce : visibilité payée par Mobile Money.
Future<void> ouvrirBoost(BuildContext context, WidgetRef ref, String titre) {
  final pro = ref.read(liveProvider).pro;
  final offres = [
    (context.t.marketN24Heures, 1000, context.t.marketEnv1500Vues),
    (context.t.marketN3Jours, 2500, context.t.marketEnv5000Vues),
    (context.t.marketN7Jours, 5000, context.t.marketEnv12000Vues),
  ];
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: LiveColors.surface,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.t.marketBoosterUneAnnonce,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            Text(
              '${context.t.marketBoostTitre(titre)}'
              '${pro ? ' Live Pro : −30 %.' : ''}',
              style: const TextStyle(color: LiveColors.gris),
            ),
            const SizedBox(height: 8),
            for (final (duree, prix, vues) in offres)
              LigneMenu(
                icone: Icons.rocket_launch_outlined,
                couleur: LiveColors.orangeVif,
                titre: duree,
                detail: vues,
                valeur: fcfa(pro ? (prix * 0.7).round() : prix),
                onTap: () {
                  Navigator.pop(ctx);
                  ref
                      .read(liveProvider.notifier)
                      .preparerPaiement(
                        PaiementEnCours(
                          type: TypePaiement.boost,
                          montant: pro ? (prix * 0.7).round() : prix,
                          libelle: context.t.marketBoostLibelle(duree, titre),
                          beneficiaire: 'Live',
                          cibleId: 'boost',
                        ),
                      );
                  context.push('/payer');
                },
              ),
            const SizedBox(height: 4),
            Text(
              context.t.marketLesAnnoncesBoosteesPortentLa,
              style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
            ),
          ],
        ),
      ),
    ),
  );
}
