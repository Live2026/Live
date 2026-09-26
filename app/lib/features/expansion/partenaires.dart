part of 'expansion_screens.dart';

/// E-API-01 — API partenaires (document 04, section 5) : banques, livreurs,
/// agences et écoles branchent leurs outils sur Live (catalogue, commandes,
/// Live Pay et séquestre, livraison), avec des clés de test puis de production.
class EcranPartenaires extends StatefulWidget {
  const EcranPartenaires({super.key});

  @override
  State<EcranPartenaires> createState() => _EcranPartenairesState();
}

class _EcranPartenairesState extends State<EcranPartenaires> {
  var _production = false;
  var _cleVisible = false;

  late final _apis = [
    (
      Icons.inventory_2_rounded,
      context.t.expansionCatalogue,
      context.t.expansionPublierEtMettreA,
    ),
    (
      Icons.receipt_long_rounded,
      context.t.expansionCommandes,
      context.t.expansionRecevoirLesCommandesLes,
    ),
    (
      Icons.lock_rounded,
      context.t.expansionLivePayEtSequestre,
      context.t.expansionEncaisserMomoAirtelMoney,
    ),
    (
      Icons.two_wheeler_rounded,
      context.t.expansionLivraison,
      context.t.expansionRecevoirDesCoursesEnvoyer,
    ),
    (
      Icons.verified_user_rounded,
      context.t.expansionVerification,
      context.t.expansionSavoirSiUnVendeur,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final marge = context.grandEcran ? 24.0 : 16.0;
    final cle = _production ? 'live_prod_7Hq2…Xk91' : 'live_test_4Fz8…Mb20';
    return Scaffold(
      appBar: AppBar(title: Text(context.t.expansionApiPartenaires)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [LiveColors.bleu, LiveColors.nuit],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.hub_rounded, color: LiveColors.ambreClair, size: 32),
                SizedBox(height: 8),
                Text(
                  context.t.expansionBranchezVotreActiviteSur,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  context.t.expansionPourLesBanquesLivreurs,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          EnTeteSection(context.t.expansionCeQueVousPouvez),
          GrilleAdaptative(
            largeurMax: 420,
            espacement: 10,
            hauteur: 86,
            enfants: [
              for (final (i, (icone, titre, texte)) in _apis.indexed)
                Apparition(
                  rang: i,
                  child: Bloc(
                    padding: 12,
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: LiveColors.voile,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icone, color: LiveColors.bleu),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                titre,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                texte,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: LiveColors.gris,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          EnTeteSection(context.t.expansionMesCles),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('Test')),
              ButtonSegment(value: true, label: Text('Production')),
            ],
            selected: {_production},
            onSelectionChanged: (v) => setState(() {
              _production = v.first;
              _cleVisible = false;
            }),
          ),
          const SizedBox(height: 10),
          Bloc(
            child: Row(
              children: [
                const Icon(Icons.key_rounded, color: LiveColors.cuivre),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _cleVisible ? cle : '•••• •••• •••• ••••',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: _cleVisible
                      ? context.t.expansionMasquerLaCle
                      : context.t.expansionAfficherLaCle,
                  onPressed: () async {
                    if (_cleVisible) {
                      setState(() => _cleVisible = false);
                    } else if (await confirmer(
                      context,
                      titre: context.t.expansionAfficherLaCle,
                      texte: context.t.expansionNeLaPartagezJamais,
                      action: context.t.expansionAfficher,
                    )) {
                      setState(() => _cleVisible = true);
                    }
                  },
                  icon: Icon(
                    _cleVisible
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _production
                ? context.t.expansionProductionVraiesTransactionsAfficher
                : context.t.expansionTestPaiementsSimulesAucun,
            style: const TextStyle(color: LiveColors.gris, fontSize: 12.5),
          ),
          EnTeteSection(context.t.expansionUtilisationCeMoisCi),
          GrilleAdaptative(
            largeurMax: 260,
            espacement: 10,
            enfants: [
              TuileChiffre(
                icone: Icons.swap_horiz_rounded,
                valeur: '6 214',
                libelle: context.t.expansionAppels,
              ),
              TuileChiffre(
                icone: Icons.check_circle_rounded,
                valeur: '99,8 %',
                libelle: context.t.expansionReussis,
                couleur: LiveColors.succes,
              ),
              TuileChiffre(
                icone: Icons.card_giftcard_rounded,
                valeur: '10 000',
                libelle: context.t.expansionAppelsGratuitsParMois,
                couleur: LiveColors.cuivre,
              ),
            ],
          ),
          const SizedBox(height: 12),
          LigneMenu(
            icone: Icons.webhook_rounded,
            titre: context.t.expansionAdresseDeNotificationWebhook,
            detail: 'https://boutique-grace.cg/live',
            onTap: () =>
                informer(context, context.t.expansionNotificationDeTestEnvoyee),
          ),
          LigneMenu(
            icone: Icons.menu_book_rounded,
            titre: context.t.expansionDocumentation,
            detail: context.t.expansionExemplesEnJavascriptPhp,
            onTap: () => informer(
              context,
              context.t.expansionDocumentationDeveloppeursLiveAfrica,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton.icon(
          onPressed: () =>
              informer(context, context.t.expansionDemandeEnvoyeeUnConseiller),
          icon: const Icon(Icons.handshake_rounded),
          label: Text(context.t.expansionDevenirPartenaire),
        ),
      ),
    );
  }
}
