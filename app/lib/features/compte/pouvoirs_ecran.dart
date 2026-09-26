part of 'compte_screens.dart';

/// E-MOI-02 — Gagner de l'argent sur Live : les super-pouvoirs.
/// Tout le monde est utilisateur ; chacun débloque des pouvoirs selon ce
/// qu'il publie, sa vérification ou son abonnement.
class EcranPouvoirs extends ConsumerWidget {
  const EcranPouvoirs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final etat = ref.watch(liveProvider);
    final actifs = pouvoirs.where((p) => p.actifPour(etat)).toList();
    final aDebloquer = pouvoirs.where((p) => !p.actifPour(etat)).toList();
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: Text(context.t.compteMesSuperPouvoirs)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 24),
        children: [
          Text(
            context.t.compteSurLiveToutLe,
            style: TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 16),
          _Niveaux(niveau: etat.niveau, pro: etat.pro),
          if (aDebloquer.isNotEmpty) ...[
            EnTeteSection(context.t.compteADebloquerN(aDebloquer.length)),
            GrilleAdaptative(
              largeurMax: 360,
              espacement: 10,
              hauteur: 132,
              enfants: [
                for (final (i, p) in aDebloquer.indexed)
                  Apparition(
                    rang: i,
                    child: _CartePouvoir(pouvoir: p, actif: false),
                  ),
              ],
            ),
          ],
          EnTeteSection(context.t.compteActifsN(actifs.length)),
          GrilleAdaptative(
            largeurMax: 360,
            espacement: 10,
            hauteur: 132,
            enfants: [
              for (final (i, p) in actifs.indexed)
                Apparition(
                  rang: i,
                  child: _CartePouvoir(pouvoir: p, actif: true),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Échelle des niveaux de confiance N1 → N3, plus l'abonnement Pro.
class _Niveaux extends StatelessWidget {
  const _Niveaux({required this.niveau, required this.pro});
  final int niveau;
  final bool pro;

  @override
  Widget build(BuildContext context) {
    final etapes = [
      ('N1', context.t.compteTelephone, niveau >= 1),
      ('N2', context.t.compteIdentite, niveau >= 2),
      ('N3', context.t.compteProVerifie, niveau >= 3),
      ('Pro', context.t.compteAbonnement, pro),
    ];
    return Bloc(
      child: Row(
        children: [
          for (final (i, (code, libelle, fait)) in etapes.indexed) ...[
            if (i > 0)
              Expanded(
                child: Container(
                  height: 3,
                  color: fait ? LiveColors.bleu : LiveColors.filet,
                ),
              ),
            Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: fait ? LiveColors.bleu : LiveColors.surface,
                    border: Border.all(
                      color: fait ? LiveColors.bleu : LiveColors.bord,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    code,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: fait ? Colors.white : LiveColors.gris,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(libelle, style: const TextStyle(fontSize: 11.5)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _CartePouvoir extends StatelessWidget {
  const _CartePouvoir({required this.pouvoir, required this.actif});
  final Pouvoir pouvoir;
  final bool actif;

  @override
  Widget build(BuildContext context) {
    final p = pouvoir;
    return Semantics(
      button: true,
      label: '${p.titre}. ${actif ? context.t.compteActif : p.pourDebloquer}',
      excludeSemantics: true,
      child: Pressable(
        onTap: () =>
            context.push(actif ? (p.route ?? '/moi') : p.routeDeblocage),
        child: Bloc(
          padding: 14,
          fond: actif ? LiveColors.surface : LiveColors.champ,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: actif ? LiveColors.voile : LiveColors.teinteOrange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  p.icone,
                  color: actif ? LiveColors.bleu : LiveColors.orangeVif,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            p.titre,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                        Icon(
                          actif
                              ? Icons.check_circle_rounded
                              : Icons.lock_outline_rounded,
                          size: 18,
                          color: actif ? LiveColors.succes : LiveColors.gris,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      p.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: LiveColors.gris,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      actif ? p.gain : p.pourDebloquer,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: actif ? LiveColors.succes : LiveColors.bleu,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Abonnement Live Pro (débloque C-STATS-AVANCEES).
class EcranPro extends ConsumerWidget {
  const EcranPro({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pro = ref.watch(liveProvider.select((e) => e.pro));
    final avantages = [
      (
        Icons.insights_rounded,
        context.t.compteStatistiquesDetaillees,
        context.t.compteVuesClicsVentesPar,
      ),
      (
        Icons.rocket_launch_outlined,
        context.t.compteBoostsA30,
        context.t.compteMettezVosAnnoncesEn,
      ),
      (
        Icons.quickreply_outlined,
        context.t.compteReponsesRapides,
        context.t.compteRepondezEnUnGeste,
      ),
      (
        Icons.workspace_premium_outlined,
        context.t.compteBadgePro,
        context.t.compteAfficheSurVosAnnonces,
      ),
      (
        Icons.support_agent_rounded,
        context.t.compteAssistancePrioritaire,
        context.t.compteUnConseillerLiveRepond,
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Live Pro')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [LiveColors.nuit, LiveColors.bleu],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Live Pro',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  context.t.compteN5000FcfaMois,
                  style: TextStyle(
                    color: LiveColors.ambreClair,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  context.t.comptePourLesVendeursAgences,
                  style: TextStyle(color: LiveColors.brumeClaire),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          for (final (icone, titre, detail) in avantages)
            LigneMenu(icone: icone, titre: titre, detail: detail),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: pro
              ? null
              : () {
                  ref
                      .read(liveProvider.notifier)
                      .preparerPaiement(
                        PaiementEnCours(
                          type: TypePaiement.abonnement,
                          montant: 5000,
                          libelle: context.t.compteLivePro1Mois,
                          beneficiaire: 'Live',
                          cibleId: 'pro',
                        ),
                      );
                  context.push('/payer');
                },
          child: Text(
            pro
                ? context.t.compteLiveProEstActif
                : context.t.compteSAbonner5000,
          ),
        ),
      ),
    );
  }
}
