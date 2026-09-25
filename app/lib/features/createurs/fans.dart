part of 'createurs_screens.dart';

/// E-CRE-02 — Page fans d'un créateur : formules d'abonnement (Fan, Super
/// fan), contenus réservés, paiement dans Live. Le créateur reçoit 75 %.
class EcranFans extends ConsumerStatefulWidget {
  const EcranFans({super.key, required this.id});
  final String id;

  @override
  ConsumerState<EcranFans> createState() => _EcranFansState();
}

class _EcranFansState extends ConsumerState<EcranFans> {
  var _offre = 0;

  @override
  Widget build(BuildContext context) {
    final c = vendeurParId(widget.id);
    final fan = ref.watch(liveProvider.select((e) => e.fans.contains(c.id)));
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 220,
            backgroundColor: c.couleur,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      c.couleur,
                      Color.lerp(c.couleur, LiveColors.nuit, 0.7)!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Avatar(
                        nom: c.nom,
                        couleur: c.couleur,
                        taille: 76,
                        verifie: true,
                        anneau: true,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        c.nom,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        '${compact(c.abonnes)} abonnés · ${compact(c.abonnes ~/ 25)} fans',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(marge, 16, marge, 32),
            sliver: SliverList.list(
              children: [
                const BandeauApercu(module: 'Abonnements de fans', phase: 2),
                const SizedBox(height: 12),
                if (fan)
                  const Bloc(
                    fond: Color(0xFFE7F4EC),
                    child: Row(
                      children: [
                        Icon(Icons.star_rounded, color: LiveColors.succes),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Vous êtes fan : les contenus réservés sont débloqués.',
                          ),
                        ),
                      ],
                    ),
                  )
                else ...[
                  const Text(
                    'Soutenez ce créateur chaque mois',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  for (final (i, o) in offresFan.indexed)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Pressable(
                        onTap: () => setState(() => _offre = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: _offre == i
                                ? LiveColors.fondProtection
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _offre == i
                                  ? LiveColors.bleu
                                  : const Color(0xFFE4E8EE),
                              width: _offre == i ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    i == 0
                                        ? Icons.star_outline_rounded
                                        : Icons.stars_rounded,
                                    color: LiveColors.orangeVif,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      o.nom,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${fcfa(o.prix)} / mois',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              for (final a in o.avantages)
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_rounded,
                                        size: 18,
                                        color: LiveColors.succes,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(child: Text(a)),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const Text(
                    'Payé dans Live, résiliable à tout moment. Le créateur reçoit 75 %.',
                    style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
                  ),
                ],
                const EnTeteSection('Contenus réservés aux fans'),
                GrilleAdaptative(
                  largeurMax: 160,
                  espacement: 8,
                  hauteur: 200,
                  enfants: [
                    for (final (i, t) in const [
                      'Corrigé détaillé BAC 2025',
                      'Direct privé : questions',
                      'Méthode pour les QCM',
                      'Fiche mémo : dérivées',
                    ].indexed)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Vignette(
                              couleur: [
                                c.couleur,
                                LiveColors.bleu,
                                LiveColors.cuivre,
                                const Color(0xFF7C3AED),
                              ][i],
                              icone: Icons.play_arrow_rounded,
                              rayon: 0,
                            ),
                            if (!fan)
                              Container(
                                color: Colors.black54,
                                child: const Icon(
                                  Icons.lock_rounded,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            Positioned(
                              left: 8,
                              right: 8,
                              bottom: 8,
                              child: Text(
                                t,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: fan
          ? null
          : BarreAction(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: LiveColors.orangeVif,
                ),
                onPressed: () {
                  final o = offresFan[_offre];
                  ref
                      .read(liveProvider.notifier)
                      .preparerPaiement(
                        PaiementEnCours(
                          type: TypePaiement.fan,
                          montant: o.prix,
                          libelle: 'Abonnement ${o.nom} · 1 mois',
                          beneficiaire: c.nom,
                          cibleId: c.id,
                        ),
                      );
                  context.push('/payer');
                },
                icon: const Icon(Icons.star_rounded),
                label: Text(
                  'Devenir ${offresFan[_offre].nom.toLowerCase()} · ${fcfa(offresFan[_offre].prix)}',
                ),
              ),
            ),
    );
  }
}
