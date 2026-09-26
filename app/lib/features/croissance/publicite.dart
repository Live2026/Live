part of 'croissance_screens.dart';

/// E-PUB-08 — Publicité (bêta, phase 2) : une vidéo sponsorisée dans le fil,
/// ciblée par ville, quartier et centre d'intérêt, avec budget et portée
/// estimée. Toujours marquée « Sponsorisé ».
class EcranPublicite extends ConsumerStatefulWidget {
  const EcranPublicite({super.key});

  @override
  ConsumerState<EcranPublicite> createState() => _EcranPubliciteState();
}

class _EcranPubliciteState extends ConsumerState<EcranPublicite> {
  late var _objectif = context.t.croissanceObjVentes;
  final _quartiers = <String>{'Moungali', 'Poto-Poto'};
  final _interets = <String>{'Mode'};
  var _budget = 10000.0;
  var _jours = 3;

  @override
  Widget build(BuildContext context) {
    final campagnes = ref.watch(liveProvider.select((e) => e.publicites));
    final marge = context.grandEcran ? 24.0 : 16.0;
    final budget = (_budget / 1000).round() * 1000;
    final portee = (budget / 1000 * 900 * (1 + _quartiers.length / 4)).round();
    return Scaffold(
      appBar: AppBar(title: Text(context.t.croissancePublicite)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 32),
        children: [
          if (campagnes.isNotEmpty) ...[
            EnTeteSection(context.t.croissanceMesCampagnes),
            for (final c in campagnes)
              LigneMenu(
                icone: Icons.campaign_rounded,
                titre: c,
                detail: context.t.croissanceEnVerificationDiffusionSous,
                couleur: LiveColors.cuivre,
              ),
          ],
          EnTeteSection(context.t.croissanceVotrePublicite),
          Row(
            children: [
              const SizedBox(
                width: 90,
                height: 150,
                child: Vignette(
                  couleur: Color(0xFFB45309),
                  icone: Icons.play_arrow_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t.croissanceNouvelArrivageDeRobes,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      context.t.croissanceVideoPublieeIlY,
                      style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
                    ),
                    const SizedBox(height: 6),
                    Etiquette(
                      context.t.croissanceSponsorise,
                      fond: LiveColors.voile,
                      couleur: LiveColors.bleu,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: () => context.push('/publier/media'),
                      child: Text(context.t.croissanceChoisirUneAutreVideo),
                    ),
                  ],
                ),
              ),
            ],
          ),
          EnTeteSection(context.t.croissanceObjectif),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final o in [
                context.t.croissanceObjVentes,
                context.t.croissanceObjVisites,
                context.t.croissanceObjAbonnes,
                context.t.croissanceObjMessages,
              ])
                ChoiceChip(
                  label: Text(o),
                  selected: _objectif == o,
                  onSelected: (_) => setState(() => _objectif = o),
                ),
            ],
          ),
          EnTeteSection(context.t.croissanceQuiLaVoit),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final q in quartiersBrazzaville)
                ChoiceChip(
                  label: Text(q),
                  selected: _quartiers.contains(q),
                  onSelected: (v) => setState(
                    () => v ? _quartiers.add(q) : _quartiers.remove(q),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (_, c) in categoriesMarket.take(6))
                ChoiceChip(
                  label: Text(c),
                  selected: _interets.contains(c),
                  onSelected: (v) => setState(
                    () => v ? _interets.add(c) : _interets.remove(c),
                  ),
                ),
            ],
          ),
          EnTeteSection(context.t.croissanceBudgetEtDuree),
          Text(
            fcfa(budget),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          Slider(
            value: _budget,
            min: 2000,
            max: 50000,
            divisions: 48,
            label: fcfa(budget),
            onChanged: (v) => setState(() => _budget = v),
          ),
          Wrap(
            spacing: 8,
            children: [
              for (final j in const [1, 3, 7, 14])
                ChoiceChip(
                  label: Text(context.t.croissanceNJours(j)),
                  selected: _jours == j,
                  onSelected: (_) => setState(() => _jours = j),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [LiveColors.bleu, LiveColors.nuit],
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.groups_rounded,
                  color: LiveColors.ambreClair,
                  size: 34,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.t.croissancePorteeEstimee,
                        style: TextStyle(color: Colors.white70),
                      ),
                      ChiffreAnime(
                        valeur: portee,
                        format: (n) => context.t.croissanceNPersonnes(
                          fcfa(n, devise: false),
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        context.t.croissanceSurJoursObjectif(
                          context.t.croissanceNJours(_jours),
                          _objectif.toLowerCase(),
                        ),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: _quartiers.isEmpty
              ? null
              : () => _payer(
                  context,
                  ref,
                  TypePaiement.publicite,
                  budget,
                  context.t.croissanceCampagne(_objectif, _jours),
                  'pub',
                ),
          child: Text(context.t.croissanceLancerCampagne(fcfa(budget))),
        ),
      ),
    );
  }
}
