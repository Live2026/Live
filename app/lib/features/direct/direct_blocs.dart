part of 'direct_screens.dart';

/// Cœur qui monte en ondulant puis disparaît (J'aime pendant un direct).
class _CoeurVolant extends StatelessWidget {
  const _CoeurVolant({super.key});

  @override
  Widget build(BuildContext context) {
    final decalage = (key.hashCode % 40).toDouble();
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1400),
      curve: Curves.easeOut,
      builder: (context, t, _) => Positioned(
        right: 24 + decalage * (t < 0.5 ? t : 1 - t),
        bottom: 200 + 260 * t,
        child: Opacity(
          opacity: 1 - t,
          child: Transform.scale(
            scale: 0.8 + 0.6 * t,
            child: const Icon(
              Icons.favorite_rounded,
              color: Color(0xFFFE2C55),
              size: 34,
            ),
          ),
        ),
      ),
    );
  }
}

/// Cadeau affiché en grand au centre quand on l'envoie.
class _GrandCadeau extends StatelessWidget {
  const _GrandCadeau({required this.cadeau});
  final Cadeau cadeau;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      builder: (_, s, _) => Transform.scale(
        scale: s,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cadeau.couleur.withValues(alpha: 0.9),
                boxShadow: [BoxShadow(color: cadeau.couleur, blurRadius: 30)],
              ),
              child: Icon(cadeau.icone, color: Colors.white, size: 64),
            ),
            const SizedBox(height: 8),
            Text(
              '${cadeau.nom} envoyé !',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bouton rond de la colonne de droite.
class _ActionDirect extends StatelessWidget {
  const _ActionDirect({
    required this.icone,
    required this.libelle,
    required this.onTap,
    this.couleur = Colors.white,
  });
  final IconData icone;
  final String libelle;
  final VoidCallback onTap;
  final Color couleur;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: libelle,
      excludeSemantics: true,
      child: Pressable(
        echelle: 0.85,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Column(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                child: Icon(icone, color: couleur, size: 26),
              ),
              const SizedBox(height: 2),
              Text(
                libelle,
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Les derniers commentaires, en bas à gauche, les plus anciens estompés.
class _FilCommentaires extends StatelessWidget {
  const _FilCommentaires({required this.evenements});
  final List<_Evenement> evenements;

  @override
  Widget build(BuildContext context) {
    final derniers = evenements.length > 5
        ? evenements.sublist(evenements.length - 5)
        : evenements;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (i, e) in derniers.indexed)
            AnimatedOpacity(
              key: ValueKey('${e.auteur}${e.texte}$i${evenements.length}'),
              duration: const Duration(milliseconds: 300),
              opacity: 0.45 + 0.55 * (i + 1) / derniers.length,
              child: Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: e.cadeau != null
                      ? e.cadeau!.couleur.withValues(alpha: 0.75)
                      : Colors.black38,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${e.auteur}  ',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: LiveColors.ambreClair,
                        ),
                      ),
                      TextSpan(text: e.texte),
                    ],
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Produit épinglé pendant le direct : achat protégé sans quitter le direct.
class _ProduitEpingle extends StatelessWidget {
  const _ProduitEpingle({
    required this.produit,
    required this.nombre,
    required this.onSuivant,
  });
  final Produit produit;
  final int nombre;
  final VoidCallback onSuivant;

  @override
  Widget build(BuildContext context) {
    final p = produit;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: LiveColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Vignette(
            couleur: p.couleur,
            icone: p.icone,
            hauteur: 48,
            largeur: 48,
            rayon: 8,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.titre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  '${fcfa(p.prix)} · payé dans Live',
                  style: const TextStyle(
                    color: LiveColors.succes,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          if (nombre > 1)
            IconButton(
              tooltip: 'Produit suivant',
              onPressed: onSuivant,
              icon: Badge(
                label: Text('$nombre'),
                child: const Icon(Icons.shopping_bag_outlined),
              ),
            ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: LiveColors.orangeVif,
              minimumSize: const Size(0, 38),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            onPressed: () => context.push('/produit/${p.id}'),
            child: const Text('Acheter'),
          ),
        ],
      ),
    );
  }
}

/// Bien présenté pendant une visite en direct.
class _BienEpingle extends StatelessWidget {
  const _BienEpingle({required this.bien});
  final Bien bien;

  @override
  Widget build(BuildContext context) {
    final b = bien;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: LiveColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Vignette(
            couleur: b.couleur,
            icone: b.type.icone,
            hauteur: 48,
            largeur: 48,
            rayon: 8,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${b.titre}\n${fcfaCourt(b.loyer)}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(0, 38)),
            onPressed: () => context.push('/bien/${b.id}'),
            child: const Text('Visiter'),
          ),
        ],
      ),
    );
  }
}

/// Panneau des cadeaux : prix en FCFA, payé avec le solde Live ; le créateur
/// reçoit 75 % (commission de 25 %, document 02).
void _ouvrirCadeaux(
  BuildContext context,
  WidgetRef ref,
  Direct d,
  ValueChanged<Cadeau> onEnvoye,
) {
  Cadeau? choisi;
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: LiveColors.surface,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, maj) {
        final solde = ref.read(liveProvider).disponible;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Offrir un cadeau à ${d.hote.nom}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Solde Live : ${fcfa(solde)} · ${d.hote.nom} reçoit 75 %',
                  style: const TextStyle(color: LiveColors.gris),
                ),
                const SizedBox(height: 12),
                GridView.extent(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  maxCrossAxisExtent: 110,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.95,
                  children: [
                    for (final c in cadeaux)
                      Semantics(
                        button: true,
                        selected: choisi == c,
                        label: '${c.nom}, ${fcfa(c.prix)}',
                        excludeSemantics: true,
                        child: Pressable(
                          onTap: () => maj(() => choisi = c),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            decoration: BoxDecoration(
                              color: choisi == c
                                  ? c.couleur.withValues(alpha: 0.12)
                                  : LiveColors.champ,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: choisi == c
                                    ? c.couleur
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(c.icone, color: c.couleur, size: 34),
                                const SizedBox(height: 4),
                                Text(
                                  c.nom,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  fcfa(c.prix),
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: LiveColors.gris,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: choisi == null
                        ? null
                        : () {
                            final c = choisi!;
                            Navigator.pop(ctx);
                            if (ref
                                .read(liveProvider.notifier)
                                .envoyerCadeau(c.prix, c.nom)) {
                              onEnvoye(c);
                            } else {
                              informer(
                                context,
                                'Solde insuffisant : rechargez par Mobile Money.',
                              );
                            }
                          },
                    child: Text(
                      choisi == null
                          ? 'Choisissez un cadeau'
                          : 'Envoyer · ${fcfa(choisi!.prix)}',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
