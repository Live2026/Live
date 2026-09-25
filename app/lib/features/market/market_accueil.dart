part of 'market_screens.dart';

/// E-MKT-01 — Accueil Market : carrousel à la une, catégories, recommandés,
/// vendeurs à la une, nouveautés, puis commandes, vente, paiements et aide.
/// La recherche est une icône de la barre du haut.
class EcranMarket extends ConsumerWidget {
  const EcranMarket({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achats = ref.watch(liveProvider.select((e) => e.achats));
    final marge = context.grandEcran ? 24.0 : 16.0;
    final tendances = [...produits]..sort((a, b) => b.vues.compareTo(a.vues));
    final nouveautes = produits.reversed.toList();
    return Scaffold(
      appBar: EnTeteRecherche(
        titleSpacing: marge,
        toolbarHeight: 64,
        titre: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Market'),
            Text(
              'Paiement protégé',
              style: TextStyle(
                fontSize: 13,
                color: LiveColors.gris,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        indice: 'Rechercher un produit, une boutique…',
        onSubmitted: (q) => context.push('/recherche', extra: q),
        actions: [
          const BoutonCommandes(),
          const BoutonNotifications(),
          const BoutonMessages(),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(marge, 4, marge, 0),
            child: const _CarrouselUne(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: EnTeteSection(
              'Catégories populaires',
              onTap: () => context.push('/market/liste'),
            ),
          ),
          SizedBox(
            height: 86,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: marge - 8),
              children: [
                for (final (icone, nom) in categoriesMarket)
                  PuceIcone(
                    icone: icone,
                    texte: nom,
                    onTap: () => context.push(
                      '/market/liste?categorie=${Uri.encodeComponent(nom)}',
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: EnTeteSection(
              'Recommandé pour vous',
              onTap: () => context.push('/market/liste'),
            ),
          ),
          Carrousel(
            largeur: 160,
            hauteur: 250,
            marge: marge,
            enfants: [
              for (final p in tendances.take(8))
                CarteProduit(produit: p, hero: false),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: const EnTeteSection('Vendeurs à la une'),
          ),
          Carrousel(
            largeur: 132,
            hauteur: 156,
            marge: marge,
            enfants: [for (final v in vendeurs) _CarteVendeurUne(vendeur: v)],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: EnTeteSection(
              'Nouveautés près de vous',
              onTap: () => context.push('/market/liste?tri=1'),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: GrilleAdaptative(
              largeurMax: context.grandEcran ? 220 : 180,
              espacement: 14,
              enfants: [
                for (final (i, p) in nouveautes.indexed)
                  Apparition(
                    rang: i,
                    child: CarteProduit(produit: p),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: GrilleAdaptative(
              largeurMax: 420,
              espacement: 12,
              enfants: [
                if (achats.isNotEmpty) _VosCommandes(achats: achats),
                const _VendreSurLive(),
                const _PaiementsSecurises(),
                const _BesoinAide(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
