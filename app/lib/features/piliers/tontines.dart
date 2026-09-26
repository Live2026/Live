part of 'piliers_screens.dart';

/// E-TON-01 — Mes tontines : likelemba numérique. Cotisations en Mobile
/// Money, gardées par Live, cagnotte versée automatiquement le jour du tour.
class EcranTontines extends ConsumerWidget {
  const EcranTontines({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payees = ref.watch(liveProvider.select((e) => e.cotisations));
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: Text(context.t.piliersTontines)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 32),
        children: [
          _Banniere(
            icone: Icons.diversity_3_rounded,
            titre: context.t.piliersLaTontineSansCahier,
            texte: context.t.piliersChacunCotiseEnMobile,
            couleurs: const [Color(0xFFDB2777), Color(0xFF7C3AED)],
            enfant: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: LiveColors.surface,
                foregroundColor: const Color(0xFF7C3AED),
                minimumSize: const Size(0, 44),
              ),
              onPressed: () => _creer(context),
              icon: const Icon(Icons.add_rounded),
              label: Text(context.t.piliersCreerUneTontine),
            ),
          ),
          EnTeteSection(context.t.piliersMesTontines),
          GrilleAdaptative(
            largeurMax: 460,
            espacement: 12,
            enfants: [
              for (final (i, t) in tontines.indexed)
                Apparition(
                  rang: i,
                  child: _CarteTontine(
                    tontine: t,
                    payee: payees.contains(t.id),
                  ),
                ),
            ],
          ),
          EnTeteSection(context.t.piliersCommentCaMarche),
          for (final (icone, titre, texte) in [
            (
              Icons.event_repeat_rounded,
              context.t.piliersMemeSommeMemeJour,
              context.t.piliersRappelLaVeilleCotisation,
            ),
            (
              Icons.lock_rounded,
              context.t.piliersArgentGardeParLive,
              context.t.piliersLesCotisationsSontBloquees,
            ),
            (
              Icons.shuffle_rounded,
              context.t.piliersOrdreDesToursClair,
              context.t.piliersTirageAuSortFilme,
            ),
            (
              Icons.gavel_rounded,
              context.t.piliersRetardsEncadres,
              context.t.piliersRappelsPuisPenaliteVotee,
            ),
          ])
            LigneMenu(icone: icone, titre: titre, detail: texte),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => context.push('/achats-groupes'),
            icon: const Icon(Icons.groups_2_rounded),
            label: Text(context.t.piliersVoirAussiLesAchats),
          ),
        ],
      ),
    );
  }

  void _creer(BuildContext context) {
    var montant = 10000.0;
    var semaine = true;
    var membres = 8.0;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: LiveColors.surface,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, maj) => SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(
              20,
              0,
              20,
              16 + MediaQuery.viewInsetsOf(ctx).bottom,
            ),
            children: [
              Text(
                context.t.piliersNouvelleTontine,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: context.t.piliersNomDuGroupe,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                context.t.piliersCotisationMontant(fcfa(montant.round())),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Slider(
                value: montant,
                min: 2000,
                max: 100000,
                divisions: 49,
                onChanged: (v) =>
                    maj(() => montant = (v / 1000).round() * 1000),
              ),
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment(
                    value: true,
                    label: Text(context.t.piliersChaqueSemaine),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text(context.t.piliersChaqueMois),
                  ),
                ],
                selected: {semaine},
                onSelectionChanged: (v) => maj(() => semaine = v.first),
              ),
              const SizedBox(height: 14),
              Text(
                context.t.piliersMembresCagnotte(
                  membres.round(),
                  fcfa((montant * membres).round()),
                ),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Slider(
                value: membres,
                min: 3,
                max: 30,
                divisions: 27,
                onChanged: (v) => maj(() => membres = v),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  informer(context, context.t.piliersTontineCreeeInvitezVos);
                },
                child: Text(context.t.piliersCreerEtInviter),
              ),
              const SizedBox(height: 6),
              Text(
                context.t.piliersFraisLive1De,
                textAlign: TextAlign.center,
                style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CarteTontine extends StatelessWidget {
  const _CarteTontine({required this.tontine, required this.payee});
  final Tontine tontine;
  final bool payee;

  @override
  Widget build(BuildContext context) {
    final t = tontine;
    final ont = t.membres.where((m) => m.$2).length + (payee ? 1 : 0);
    final monTour = t.moi == t.tour;
    return Pressable(
      onTap: () => context.push('/tontine/${t.id}'),
      child: Bloc(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: t.couleur.withValues(alpha: 0.12),
                  child: Icon(Icons.diversity_3_rounded, color: t.couleur),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.nom,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${fcfa(t.montant)} · ${t.frequence}',
                        style: const TextStyle(color: LiveColors.gris),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: ont / t.membres.length,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
              color: t.couleur,
              backgroundColor: LiveColors.voile,
            ),
            const SizedBox(height: 6),
            Text(
              context.t.piliersOntCotise(
                ont,
                t.membres.length,
                monTour ? context.t.piliersVous : t.beneficiaire,
                t.prochaine,
              ),
              style: const TextStyle(fontSize: 12.5, color: LiveColors.gris),
            ),
            const SizedBox(height: 8),
            Etiquette(
              payee
                  ? context.t.piliersCotisationPayee
                  : context.t.piliersACotiser(fcfa(t.montant)),
              icone: payee
                  ? Icons.check_circle_rounded
                  : Icons.schedule_rounded,
              fond: payee ? LiveColors.teinteVerte : LiveColors.teinteAmbre,
              couleur: payee ? LiveColors.succes : LiveColors.cuivre,
            ),
          ],
        ),
      ),
    );
  }
}
