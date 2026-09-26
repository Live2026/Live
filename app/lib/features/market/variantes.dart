part of 'market_screens.dart';

/// F-MKT-06 — Choix de la variante (taille) et de la quantité avant la
/// commande, avec le stock restant, comme dans les grandes boutiques en ligne.
void ouvrirVariantes(BuildContext context, Produit p) {
  final tailles = p.details['Tailles']!.split(', ');
  final stock = int.tryParse(p.details['Stock'] ?? '') ?? 5;
  String? taille;
  var quantite = 1;
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: LiveColors.surface,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, maj) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Vignette(
                    couleur: p.couleur,
                    icone: p.icone,
                    hauteur: 64,
                    largeur: 64,
                    rayon: 10,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.titre,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          fcfa(p.prix * quantite),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          stock <= 3
                              ? context.t.marketPlusQueStock(stock)
                              : context.t.marketNEnStock(stock),
                          style: TextStyle(
                            color: stock <= 3
                                ? LiveColors.erreur
                                : LiveColors.succes,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                context.t.marketTaille,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: [
                  for (final t in tailles)
                    ChoiceChip(
                      label: Text(t),
                      selected: taille == t,
                      onSelected: (_) => maj(() => taille = t),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.t.marketQuantite,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton.outlined(
                    tooltip: context.t.marketMoins,
                    onPressed: quantite > 1
                        ? () => maj(() => quantite--)
                        : null,
                    icon: const Icon(Icons.remove),
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '$quantite',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton.outlined(
                    tooltip: context.t.plus,
                    onPressed: quantite < stock
                        ? () => maj(() => quantite++)
                        : null,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: taille == null
                      ? null
                      : () {
                          Navigator.pop(ctx);
                          context.push(
                            '/commande/${p.id}?variante=$taille&qte=$quantite',
                          );
                        },
                  child: Text(
                    taille == null
                        ? context.t.marketChoisissezUneTaille
                        : context.t.continuer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
