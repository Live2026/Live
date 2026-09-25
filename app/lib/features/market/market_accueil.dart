part of 'market_screens.dart';

/// E-MKT-01 — Accueil Market : recherche, catégories, boutiques vérifiées,
/// tendances et toutes les annonces en grille.
class EcranMarket extends StatefulWidget {
  const EcranMarket({super.key});

  @override
  State<EcranMarket> createState() => _EcranMarketState();
}

class _EcranMarketState extends State<EcranMarket> {
  String? _categorie;

  @override
  Widget build(BuildContext context) {
    final marge = context.grandEcran ? 24.0 : 16.0;
    final liste = produits
        .where((p) => _categorie == null || p.categorie == _categorie)
        .toList();
    final tendances = [...produits]..sort((a, b) => b.vues.compareTo(a.vues));
    return Scaffold(
      appBar: AppBar(
        titleSpacing: marge,
        title: const Text('Market'),
        actions: [
          IconButton(
            tooltip: 'Vendre',
            onPressed: () => context.push('/vendre'),
            icon: const Icon(Icons.add_circle_outline_rounded),
          ),
          const BoutonMessages(),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: TextField(
              readOnly: true,
              onTap: () => context.push('/recherche'),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search_rounded),
                hintText: 'Téléphone, pagne, climatiseur…',
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 86,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: marge - 8),
              children: [
                PuceIcone(
                  icone: Icons.grid_view_rounded,
                  texte: 'Tout',
                  active: _categorie == null,
                  onTap: () => setState(() => _categorie = null),
                ),
                for (final (icone, nom) in categoriesMarket)
                  PuceIcone(
                    icone: icone,
                    texte: nom,
                    active: _categorie == nom,
                    onTap: () => setState(
                      () => _categorie = _categorie == nom ? null : nom,
                    ),
                  ),
              ],
            ),
          ),
          if (_categorie == null) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(marge, 8, marge, 0),
              child: const _BanniereLancement(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: marge),
              child: EnTeteSection(
                'Boutiques vérifiées',
                onTap: () => context.push('/boutique/grace'),
              ),
            ),
            SizedBox(
              height: 104,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: marge),
                itemCount: vendeurs.length,
                separatorBuilder: (_, _) => const SizedBox(width: 14),
                itemBuilder: (_, i) {
                  final v = vendeurs[i];
                  return Semantics(
                    button: true,
                    label: v.nom,
                    excludeSemantics: true,
                    child: Pressable(
                      onTap: () => context.push('/boutique/${v.id}'),
                      child: SizedBox(
                        width: 76,
                        child: Column(
                          children: [
                            Avatar(
                              nom: v.nom,
                              couleur: v.couleur,
                              taille: 64,
                              anneau: i < 3,
                              verifie: v.badge.startsWith('Pro'),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              v.nom,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: marge),
              child: const EnTeteSection('Tendances à Brazzaville'),
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
          ],
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: EnTeteSection(
              _categorie ?? 'Toutes les annonces',
              action: _categorie == null ? null : 'Effacer',
              onTap: _categorie == null
                  ? null
                  : () => setState(() => _categorie = null),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: GrilleAdaptative(
              largeurMax: context.grandEcran ? 220 : 180,
              espacement: 14,
              enfants: [
                for (final (i, p) in liste.indexed)
                  Apparition(
                    rang: i,
                    child: CarteProduit(produit: p),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Bannière de l'offre de lancement pour les vendeurs.
class _BanniereLancement extends StatelessWidget {
  const _BanniereLancement();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Vendez sans commission pendant 3 mois',
      excludeSemantics: true,
      child: Pressable(
        onTap: () => context.push('/vendre'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [LiveColors.bleu, LiveColors.nuit],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '0 % de commission',
                      style: TextStyle(
                        color: LiveColors.ambreClair,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Vendez sur Live pendant 3 mois sans rien payer. '
                      'Votre argent est garanti.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Icon(Icons.sell_rounded, color: Colors.white, size: 40),
            ],
          ),
        ),
      ),
    );
  }
}
