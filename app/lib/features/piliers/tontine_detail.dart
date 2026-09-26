part of 'piliers_screens.dart';

/// E-TON-02 — Une tontine : cagnotte du tour, bénéficiaire, ordre des tours,
/// qui a cotisé, cotiser, historique.
class EcranTontine extends ConsumerWidget {
  const EcranTontine({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = tontineParId(id);
    final payee = ref.watch(
      liveProvider.select((e) => e.cotisations.contains(t.id)),
    );
    final marge = context.grandEcran ? 24.0 : 16.0;
    final membres = [
      for (final (i, (nom, a)) in t.membres.indexed)
        (nom, a || (i == t.moi && payee)),
    ];
    final ont = membres.where((m) => m.$2).length;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.nom),
        actions: [
          IconButton(
            tooltip: context.t.piliersDiscussionDuGroupe,
            onPressed: () => context.push('/groupe/g1'),
            icon: const Icon(Icons.forum_outlined),
          ),
          IconButton(
            tooltip: context.t.piliersInviter,
            onPressed: () => partager(
              context,
              context.t.piliersRejoinsTontine(t.nom, 'live.africa/t/${t.id}'),
            ),
            icon: const Icon(Icons.person_add_alt_1_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 32),
        children: [
          _Banniere(
            icone: Icons.savings_rounded,
            titre: context.t.piliersCagnotteMontant(fcfa(t.cagnotte)),
            texte: context.t.piliersTourSur(
              t.tour + 1,
              t.membres.length,
              t.tour == t.moi ? context.t.piliersVous : t.beneficiaire,
              t.prochaine.toLowerCase(),
            ),
            couleurs: [t.couleur, LiveColors.nuit],
            enfant: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: ont / membres.length),
                  duration: const Duration(milliseconds: 800),
                  curve: courbeDouce,
                  builder: (_, v, _) => LinearProgressIndicator(
                    value: v,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                    color: LiveColors.ambre,
                    backgroundColor: Colors.white24,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  context.t.piliersCotisationsRecues(ont, membres.length),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (payee)
            Bloc(
              fond: LiveColors.teinteVerte,
              child: Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: LiveColors.succes),
                  SizedBox(width: 10),
                  Expanded(child: Text(context.t.piliersVotreCotisationDeCe)),
                ],
              ),
            )
          else
            FilledButton.icon(
              onPressed: () => _payer(
                context,
                ref,
                TypePaiement.cotisation,
                t.montant,
                context.t.piliersCotisationDe(t.nom),
                t.id,
                beneficiaire: context.t.piliersTontineNom(t.nom),
              ),
              icon: const Icon(Icons.payments_rounded),
              label: Text(context.t.piliersCotiserMontant(fcfa(t.montant))),
            ),
          EnTeteSection(context.t.piliersOrdreDesTours),
          Bloc(
            padding: 0,
            child: Column(
              children: [
                for (final (i, (nom, a)) in membres.indexed)
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: i < t.tour
                          ? LiveColors.teinteVerte
                          : i == t.tour
                          ? t.couleur
                          : LiveColors.champ,
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: i == t.tour ? Colors.white : LiveColors.encre,
                        ),
                      ),
                    ),
                    title: Text(
                      i == t.moi ? context.t.piliersNomVous(nom) : nom,
                      style: TextStyle(
                        fontWeight: i == t.tour ? FontWeight.w800 : null,
                      ),
                    ),
                    subtitle: Text(
                      i < t.tour
                          ? context.t.piliersARecuSaCagnotte
                          : i == t.tour
                          ? context.t.piliersRecoitLaCagnotteCe
                          : context.t.piliersTourN(i + 1),
                    ),
                    trailing: Icon(
                      a ? Icons.check_circle_rounded : Icons.schedule_rounded,
                      color: a ? LiveColors.succes : LiveColors.cuivre,
                      semanticLabel: a
                          ? context.t.piliersACotise
                          : context.t.piliersPasEncoreCotise,
                    ),
                  ),
              ],
            ),
          ),
          EnTeteSection(context.t.piliersHistorique),
          for (final (quand, texte) in [
            (
              context.t.piliersN20Sept,
              context.t.piliersCagnotteVerseeA(
                fcfa(t.cagnotte),
                t.membres[t.tour > 0 ? t.tour - 1 : 0].$1,
              ),
            ),
            (context.t.piliersN13Sept, context.t.piliersTousLesMembresOnt),
            (context.t.piliersN6Sept, context.t.piliersRappelEnvoyeA2),
          ])
            LigneMenu(
              icone: Icons.history_rounded,
              titre: texte,
              detail: quand,
            ),
          const SizedBox(height: 8),
          Text(
            context.t.piliersLiveGardeLesCotisations,
            style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}
