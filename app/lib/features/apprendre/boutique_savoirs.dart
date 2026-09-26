part of 'apprendre_screens.dart';

/// E-APP-07 — Ma boutique de savoirs : revenus de la semaine, répartition
/// par contenu, solde à retirer et contenus en vente.
class EcranBoutiqueSavoirs extends ConsumerWidget {
  const EcranBoutiqueSavoirs({super.key});

  static const _mesContenus = ['n1', 'n2', 'n6'];
  static const _parts = [0.52, 0.30, 0.18];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final etat = ref.watch(liveProvider);
    final semaine = revenusSemaine.fold(0, (s, r) => s + r.$2);
    final marge = context.grandEcran ? 24.0 : 16.0;
    final couleurs = [
      LiveColors.bleu,
      LiveColors.orange,
      const Color(0xFF7C3AED),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.apprendreMaBoutiqueDeSavoirs),
        actions: [
          IconButton(
            tooltip: context.t.apprendreVendreUnContenu,
            onPressed: () => context.push('/apprendre/vendre'),
            icon: const Icon(Icons.add_circle_outline_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 8, marge, 32),
        children: [
          GrilleAdaptative(
            largeurMax: 200,
            espacement: 10,
            hauteur: 112,
            enfants: [
              TuileChiffre(
                libelle: context.t.apprendreRevenusDuMois,
                valeur: fcfaCourt(342500),
                icone: Icons.trending_up_rounded,
                detail: context.t.apprendreN18SurAout,
                couleur: LiveColors.succes,
              ),
              TuileChiffre(
                libelle: context.t.apprendreVentes,
                valeur: '128',
                icone: Icons.shopping_bag_outlined,
                detail: context.t.apprendreCeMoisCi,
              ),
              TuileChiffre(
                libelle: context.t.apprendreEleves,
                valeur: '96',
                icone: Icons.people_alt_outlined,
                detail: context.t.apprendreN31Nouveaux,
              ),
              TuileChiffre(
                libelle: context.t.apprendreNoteMoyenne,
                valeur: '4,8',
                icone: Icons.star_rounded,
                detail: context.t.apprendreN212Avis,
                couleur: LiveColors.cuivre,
              ),
            ],
          ),
          EnTeteSection(context.t.apprendreN7DerniersJours),
          Bloc(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fcfa(semaine),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  context.t.apprendreRevenusNetsApresLa,
                  style: TextStyle(color: LiveColors.gris),
                ),
                const SizedBox(height: 12),
                const _Histogramme(),
              ],
            ),
          ),
          EnTeteSection(context.t.apprendreRepartitionParContenu),
          Bloc(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Row(
                    children: [
                      for (final (i, p) in _parts.indexed)
                        Expanded(
                          flex: (p * 100).round(),
                          child: Container(height: 10, color: couleurs[i]),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                for (final (i, id) in _mesContenus.indexed)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: couleurs[i],
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            contenuParId(id).titre,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          fcfa((342500 * _parts[i]).round()),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Bloc(
            fond: LiveColors.fondProtection,
            child: Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: LiveColors.bleu,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.t.apprendreSoldeDisponible),
                      Text(
                        fcfa(etat.disponible),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
                  onPressed: () => context.push('/retirer'),
                  child: Text(context.t.apprendreRetirer),
                ),
              ],
            ),
          ),
          EnTeteSection(context.t.apprendreMesContenus),
          for (final titre in etat.contenusPublies)
            LigneMenu(
              icone: Icons.hourglass_top_rounded,
              titre: titre,
              detail: context.t.apprendreEnVerificationMoinsDe,
              couleur: LiveColors.cuivre,
            ),
          for (final id in _mesContenus)
            LigneMenu(
              icone: contenuParId(id).type.icone,
              titre: contenuParId(id).titre,
              detail: context.t.apprendreVentesEnVente(
                compact(contenuParId(id).ventes),
              ),
              onTap: () => context.push('/contenu/$id'),
            ),
        ],
      ),
    );
  }
}

/// Histogramme des revenus des 7 derniers jours.
class _Histogramme extends StatelessWidget {
  const _Histogramme();

  @override
  Widget build(BuildContext context) {
    final max = revenusSemaine.map((r) => r.$2).reduce((a, b) => a > b ? a : b);
    return SizedBox(
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final (i, (jour, montant)) in revenusSemaine.indexed)
            Expanded(
              child: Semantics(
                label: context.t.apprendreJourMontant(jour, fcfa(montant)),
                excludeSemantics: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      compact(montant),
                      style: const TextStyle(
                        fontSize: 11,
                        color: LiveColors.gris,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 100 * montant / max,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: i == 4 ? LiveColors.orangeVif : LiveColors.bleu,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(jour, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
