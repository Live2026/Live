part of 'compte_screens.dart';

/// Enregistrés : les annonces sauvegardées d'un cœur (produits, logements),
/// rangées par espace, avec les mêmes cartes que partout ailleurs.
class EcranEnregistres extends ConsumerWidget {
  const EcranEnregistres({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoris = ref.watch(liveProvider.select((e) => e.favoris));
    final lesProduits = produits.where((p) => favoris.contains(p.id)).toList();
    final lesBiens = biens.where((b) => favoris.contains(b.id)).toList();
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: Text(context.t.compteEnregistres)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 0, marge, 24),
        children: [
          if (lesProduits.isEmpty && lesBiens.isEmpty)
            EtatVide(
              icone: Icons.favorite_border_rounded,
              texte: context.t.compteTouchezLeCUr,
              action: context.t.compteExplorer,
              onTap: () => context.go('/explorer'),
            ),
          if (lesBiens.isNotEmpty) ...[
            EnTeteSection(context.t.compteLogementsN(lesBiens.length)),
            GrilleAdaptative(
              largeurMax: 260,
              espacement: 14,
              enfants: [for (final b in lesBiens) CarteBien(bien: b)],
            ),
          ],
          if (lesProduits.isNotEmpty) ...[
            EnTeteSection(context.t.compteProduitsN(lesProduits.length)),
            GrilleAdaptative(
              largeurMax: 200,
              espacement: 14,
              enfants: [for (final p in lesProduits) CarteProduit(produit: p)],
            ),
          ],
        ],
      ),
    );
  }
}
