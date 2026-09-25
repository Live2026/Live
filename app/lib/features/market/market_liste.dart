part of 'market_screens.dart';

/// E-MKT-01 bis — Liste des annonces d'une catégorie, triable
/// (pertinence, nouveautés, prix croissant, prix décroissant).
class EcranListeMarket extends StatefulWidget {
  const EcranListeMarket({super.key, this.categorie, this.tri = 0});
  final String? categorie;
  final int tri;

  @override
  State<EcranListeMarket> createState() => _EcranListeMarketState();
}

class _EcranListeMarketState extends State<EcranListeMarket> {
  late var _tri = widget.tri;
  static const _tris = [
    'Pertinence',
    'Nouveautés',
    'Prix croissant',
    'Prix décroissant',
  ];

  @override
  void didUpdateWidget(EcranListeMarket ancien) {
    super.didUpdateWidget(ancien);
    if (ancien.tri != widget.tri) _tri = widget.tri;
  }

  @override
  Widget build(BuildContext context) {
    final liste = produits
        .where(
          (p) => widget.categorie == null || p.categorie == widget.categorie,
        )
        .toList();
    switch (_tri) {
      case 0:
        liste.sort((a, b) => b.vues.compareTo(a.vues));
      case 1:
        liste.setAll(0, liste.reversed.toList());
      case 2:
        liste.sort((a, b) => a.prix.compareTo(b.prix));
      case 3:
        liste.sort((a, b) => b.prix.compareTo(a.prix));
    }
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: EnTeteRecherche(
        toolbarHeight: 64,
        titre: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.categorie ?? 'Toutes les annonces'),
            TexteVille(
              '${liste.length} résultat${liste.length > 1 ? 's' : ''} à {ville}',
              style: const TextStyle(
                fontSize: 13,
                color: LiveColors.gris,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        indice: 'Rechercher dans le Market…',
        onSubmitted: (q) => context.push('/recherche', extra: q),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: marge),
              children: [
                for (final (i, t) in _tris.indexed)
                  _Onglet(
                    texte: t,
                    actif: _tri == i,
                    onTap: () => setState(() => _tri = i),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.fromLTRB(marge, 8, marge, 0),
            child: GrilleAdaptative(
              largeurMax: 520,
              espacement: 8,
              hauteur: 128,
              enfants: [
                for (final (i, p) in liste.indexed)
                  Apparition(
                    rang: i,
                    child: _LigneProduit(produit: p),
                  ),
              ],
            ),
          ),
          if (liste.isEmpty)
            const EtatVide(
              icone: Icons.search_off_rounded,
              texte: 'Aucune annonce dans cette catégorie pour l’instant.',
            ),
        ],
      ),
    );
  }
}

/// Onglet de tri souligné.
class _Onglet extends StatelessWidget {
  const _Onglet({
    required this.texte,
    required this.actif,
    required this.onTap,
  });
  final String texte;
  final bool actif;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: actif,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 3,
                color: actif ? LiveColors.orangeVif : Colors.transparent,
              ),
            ),
          ),
          child: Text(
            texte,
            style: TextStyle(
              fontWeight: actif ? FontWeight.w800 : FontWeight.w500,
              color: actif ? LiveColors.nuit : LiveColors.gris,
            ),
          ),
        ),
      ),
    );
  }
}

/// Annonce en ligne : photo carrée à gauche, titre, état, vendeur, note,
/// prix. Même hauteur pour toutes les lignes.
class _LigneProduit extends StatelessWidget {
  const _LigneProduit({required this.produit});
  final Produit produit;

  @override
  Widget build(BuildContext context) {
    final p = produit;
    return Semantics(
      button: true,
      label: '${p.titre}, ${fcfa(p.prix)}',
      child: Pressable(
        onTap: () => context.push('/produit/${p.id}'),
        child: Row(
          children: [
            SizedBox(
              width: 112,
              height: 112,
              child: Vignette(couleur: p.couleur, icone: p.icone),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          p.titre,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      BoutonFavori(id: p.id),
                    ],
                  ),
                  Text(
                    p.reglement == Reglement.surPlace
                        ? '${p.etat} · payé à la remise'
                        : '${p.etat} · ${p.quartier}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: LiveColors.gris,
                      fontSize: 12.5,
                    ),
                  ),
                  Text(
                    'Par ${p.vendeur.nom}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: LiveColors.gris,
                      fontSize: 12.5,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 15,
                        color: LiveColors.ambre,
                      ),
                      Text(
                        ' ${note(p.vendeur.note).replaceAll('/5', '')}',
                        style: const TextStyle(fontSize: 12.5),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            fcfa(p.prix),
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mes commandes : tous les achats du Market et leur état.
class EcranMesCommandes extends ConsumerWidget {
  const EcranMesCommandes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achats = ref.watch(liveProvider.select((e) => e.achats));
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: const Text('Mes commandes')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 24),
        children: [
          if (achats.isEmpty)
            EtatVide(
              icone: Icons.receipt_long_outlined,
              texte: 'Aucune commande pour l’instant.',
              action: 'Découvrir le Market',
              onTap: () => context.go('/market'),
            ),
          for (final c in achats) LigneCommande(commande: c),
        ],
      ),
    );
  }
}
