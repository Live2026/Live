part of 'market_screens.dart';

/// E-MKT-07 — Mes ventes (vendeur) : chiffres clés, onglets, commandes.
class EcranMesVentes extends ConsumerStatefulWidget {
  const EcranMesVentes({super.key});

  @override
  ConsumerState<EcranMesVentes> createState() => _EcranMesVentesState();
}

class _EcranMesVentesState extends ConsumerState<EcranMesVentes> {
  var _onglet = 0; // 0 à traiter, 1 en cours, 2 terminées

  static int _rang(StatutCommande s) => switch (s) {
    StatutCommande.payee || StatutCommande.reservee => 0,
    StatutCommande.acceptee || StatutCommande.remise => 1,
    StatutCommande.terminee => 2,
  };

  @override
  Widget build(BuildContext context) {
    final etat = ref.watch(liveProvider);
    final ventes = etat.ventes;
    final nombre = [
      for (var i = 0; i < 3; i++)
        ventes.where((v) => _rang(v.statut) == i).length,
    ];
    final visibles = ventes.where((v) => _rang(v.statut) == _onglet).toList();
    final ceMois = ventes
        .where((v) => v.statut == StatutCommande.terminee)
        .fold(0, (s, v) => s + v.total);
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes ventes'),
        actions: [
          IconButton(
            tooltip: 'Statistiques',
            onPressed: () {},
            icon: const Icon(Icons.insights_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 8, marge, 24),
        children: [
          _BandeauChiffres(
            chiffres: [
              _Chiffre(
                libelle: 'Ce mois',
                valeur: ceMois,
                format: (n) => fcfa(n, devise: false),
                unite: 'FCFA',
                icone: Icons.trending_up,
              ),
              _Chiffre(
                libelle: 'En attente',
                valeur: 96000,
                format: (n) => fcfa(n, devise: false),
                unite: 'FCFA',
                icone: Icons.lock_clock_outlined,
              ),
              _Chiffre(
                libelle: 'Note clients',
                valeur: 48,
                format: (n) => (n / 10).toStringAsFixed(1).replaceAll('.', ','),
                unite: 'sur 5',
                icone: Icons.star_rounded,
                couleurIcone: LiveColors.cuivre,
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<int>(
              showSelectedIcon: false,
              segments: [
                for (final (i, t) in const [
                  'À traiter',
                  'En cours',
                  'Terminées',
                ].indexed)
                  ButtonSegment(
                    value: i,
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('$t · ${nombre[i]}', maxLines: 1),
                    ),
                  ),
              ],
              selected: {_onglet},
              onSelectionChanged: (s) => setState(() => _onglet = s.first),
            ),
          ),
          const SizedBox(height: 16),
          if (visibles.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 48,
                    color: LiveColors.gris,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _onglet == 0
                        ? 'Aucune commande à traiter.'
                        : 'Rien ici pour le moment.',
                    style: const TextStyle(color: LiveColors.gris),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () => context.push('/vendre'),
                    icon: const Icon(Icons.add),
                    label: const Text('Publier une annonce'),
                  ),
                ],
              ),
            )
          else
            GrilleAdaptative(
              largeurMax: 560,
              enfants: [
                for (final (i, v) in visibles.indexed)
                  Apparition(
                    rang: i,
                    child: _CarteVente(
                      vente: v,
                      onAcceptee: () => setState(() => _onglet = 1),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

/// Les chiffres clés du vendeur, en une seule bande à 3 colonnes.
class _BandeauChiffres extends StatelessWidget {
  const _BandeauChiffres({required this.chiffres});
  final List<_Chiffre> chiffres;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            for (final (i, c) in chiffres.indexed) ...[
              if (i > 0)
                const VerticalDivider(width: 1, color: LiveColors.brume),
              Expanded(child: c),
            ],
          ],
        ),
      ),
    );
  }
}

class _Chiffre extends StatelessWidget {
  const _Chiffre({
    required this.libelle,
    required this.valeur,
    required this.format,
    required this.unite,
    required this.icone,
    this.couleurIcone = LiveColors.bleu,
  });
  final String libelle;
  final int valeur;
  final String Function(int) format;
  final String unite;
  final IconData icone;
  final Color couleurIcone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icone, size: 16, color: couleurIcone),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  libelle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: LiveColors.gris, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: ChiffreAnime(
              valeur: valeur,
              format: format,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ),
          Text(
            unite,
            style: const TextStyle(color: LiveColors.gris, fontSize: 11.5),
          ),
        ],
      ),
    );
  }
}

class _CarteVente extends ConsumerWidget {
  const _CarteVente({required this.vente, this.onAcceptee});
  final Commande vente;

  /// Après l'acceptation, l'écran suit la commande dans l'onglet « En cours ».
  final VoidCallback? onAcceptee;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = vente;
    final net = v.total - commission(v.total, 0.06, minimum: 100);
    final (statut, couleur) = switch (v.statut) {
      StatutCommande.payee ||
      StatutCommande.reservee => ('Nouvelle', LiveColors.orangeVif),
      StatutCommande.acceptee ||
      StatutCommande.remise => ('À remettre', LiveColors.bleu),
      StatutCommande.terminee => ('Terminée', LiveColors.succes),
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Vignette(
                  couleur: v.produit.couleur,
                  icone: v.produit.icone,
                  hauteur: 56,
                  largeur: 56,
                  rayon: 8,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: couleur.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              statut,
                              style: TextStyle(
                                color: couleur == LiveColors.orangeVif
                                    ? LiveColors.cuivre
                                    : couleur,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            v.id,
                            style: const TextStyle(
                              color: LiveColors.gris,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        v.produit.titre,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${v.acheteur} (4,9/5) · Payée, argent bloqué',
                        style: const TextStyle(
                          color: LiveColors.gris,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      fcfa(v.total),
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      'net ${fcfa(net)}',
                      style: const TextStyle(
                        color: LiveColors.gris,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (v.statut != StatutCommande.terminee) ...[
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (v.statut == StatutCommande.payee) ...[
                    TextButton(onPressed: () {}, child: const Text('Refuser')),
                    const SizedBox(width: 8),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(120, 40),
                      ),
                      onPressed: () {
                        ref.read(liveProvider.notifier).accepterVente(v.id);
                        onAcceptee?.call();
                      },
                      child: const Text('Accepter'),
                    ),
                  ] else
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 40),
                      ),
                      onPressed: () => context.push('/vente/${v.id}'),
                      icon: const Icon(Icons.qr_code_scanner, size: 18),
                      label: const Text('Remettre le produit'),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
