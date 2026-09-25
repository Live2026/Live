import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/format.dart';
import '../core/theme.dart';
import '../data/mock.dart';
import '../data/store.dart';
import 'animations.dart';
import 'composants.dart';
import 'medias.dart';

/// Cartes d'annonces. Règle : dans une même catégorie, toutes les cartes ont
/// exactement la même taille (image au même format, texte dans des zones de
/// hauteur fixe), quel que soit le contenu.

const _titre = TextStyle(fontWeight: FontWeight.w600, height: 1.25);
const _meta = TextStyle(color: LiveColors.gris, fontSize: 12.5, height: 1.3);

/// Zone de texte de hauteur fixe (n lignes), pour aligner les cartes.
class _Zone extends StatelessWidget {
  const _Zone(this.texte, {required this.lignes, this.style = _titre});
  final String texte;
  final int lignes;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final hauteur = (style.fontSize ?? 14) * (style.height ?? 1.25) * lignes;
    return SizedBox(
      height: MediaQuery.textScalerOf(context).scale(hauteur),
      child: Text(
        texte,
        maxLines: lignes,
        overflow: TextOverflow.ellipsis,
        style: style,
      ),
    );
  }
}

/// Cœur « enregistrer », transparent sur les photos.
class BoutonFavori extends ConsumerWidget {
  const BoutonFavori({
    super.key,
    required this.id,
    this.couleur = Colors.white,
  });
  final String id;
  final Color couleur;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actif = ref.watch(liveProvider.select((e) => e.favoris.contains(id)));
    return Semantics(
      button: true,
      selected: actif,
      label: actif ? 'Retirer des favoris' : 'Enregistrer',
      excludeSemantics: true,
      child: Pressable(
        echelle: 0.8,
        onTap: () => ref.read(liveProvider.notifier).basculerFavori(id),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.22),
            shape: BoxShape.circle,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
            child: Icon(
              actif ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              key: ValueKey(actif),
              size: 20,
              color: actif ? const Color(0xFFFF4D67) : couleur,
            ),
          ),
        ),
      ),
    );
  }
}

/// Carte produit en grille : image carrée, titre sur 2 lignes, prix, lieu.
class CarteProduit extends StatelessWidget {
  const CarteProduit({super.key, required this.produit, this.hero = true});
  final Produit produit;

  /// Animation partagée vers la fiche : désactivée dans les carrousels, pour
  /// qu'un même produit n'ait jamais deux Hero sur la même page.
  final bool hero;

  @override
  Widget build(BuildContext context) {
    final p = produit;
    return Semantics(
      button: true,
      label: '${p.titre}, ${fcfa(p.prix)}',
      child: Pressable(
        onTap: () => context.push('/produit/${p.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _AvecHero(
                    actif: hero,
                    tag: 'produit-${p.id}',
                    child: Vignette(couleur: p.couleur, icone: p.icone),
                  ),
                  Positioned(right: 6, top: 6, child: BoutonFavori(id: p.id)),
                  if (p.etat == 'Neuf')
                    const Positioned(
                      left: 8,
                      bottom: 8,
                      child: Etiquette('Neuf'),
                    )
                  else if (p.reglement == Reglement.surPlace)
                    const Positioned(
                      left: 8,
                      bottom: 8,
                      right: 8,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Etiquette(
                          'À voir sur place',
                          icone: Icons.handshake_rounded,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _Zone(p.titre, lignes: 2),
            const SizedBox(height: 2),
            Text(
              fcfa(p.prix),
              maxLines: 1,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            ),
            _Zone(
              '${p.quartier} · ${note(p.vendeur.note)}',
              lignes: 1,
              style: _meta,
            ),
          ],
        ),
      ),
    );
  }
}

/// Carte logement : photo 4:3 avec badges, prix, titre, caractéristiques en
/// icônes et coût d'entrée. Même hauteur pour tous les logements.
class CarteBien extends StatelessWidget {
  const CarteBien({super.key, required this.bien, this.hero = true});
  final Bien bien;
  final bool hero;

  @override
  Widget build(BuildContext context) {
    final b = bien;
    return Semantics(
      button: true,
      label: '${b.titre}, ${b.quartier}, ${fcfaCourt(b.loyer)}',
      child: Pressable(
        onTap: () => context.push('/bien/${b.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: PhotoBien(bien: b, hero: hero),
            ),
            const SizedBox(height: 8),
            PrixBien(bien: b),
            _Zone('${b.titre} · ${b.quartier}', lignes: 1),
            const SizedBox(height: 4),
            SpecsBien(bien: b),
            const SizedBox(height: 4),
            _Zone(
              b.vente
                  ? 'Vente · ${b.annonceur.nom}'
                  : "Entrée ${fcfa(b.coutEntree)}",
              lignes: 1,
              style: _meta.copyWith(color: LiveColors.bleu),
            ),
          ],
        ),
      ),
    );
  }
}

/// Photo d'un logement avec ses badges (partagée par les cartes et la fiche).
class PhotoBien extends StatelessWidget {
  const PhotoBien({
    super.key,
    required this.bien,
    this.rayon = 12,
    this.hero = true,
    this.favori = true,
    this.haut = 8,
  });
  final Bien bien;
  final double rayon;
  final bool hero;

  /// Cœur « enregistrer » sur la photo (absent quand la barre du haut l'a déjà).
  final bool favori;

  /// Marge des badges en haut, pour passer sous une barre transparente.
  final double haut;

  @override
  Widget build(BuildContext context) {
    final b = bien;
    return Stack(
      fit: StackFit.expand,
      children: [
        _AvecHero(
          actif: hero,
          tag: 'bien-${b.id}',
          child: Vignette(
            couleur: b.couleur,
            icone: b.type.icone,
            rayon: rayon,
          ),
        ),
        Positioned(
          left: 8,
          top: haut,
          right: favori ? 48 : 8,
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              Etiquette(
                b.agence ? 'Agence vérifiée' : 'Vérifié',
                icone: Icons.verified,
              ),
              if (b.nouveau)
                const Etiquette(
                  'Nouveau',
                  fond: LiveColors.orangeVif,
                  couleur: Colors.white,
                ),
              if (b.sponsorise)
                const Etiquette(
                  'Sponsorisé',
                  fond: Color(0xB3041936),
                  couleur: Colors.white,
                ),
            ],
          ),
        ),
        if (favori) Positioned(right: 6, top: 6, child: BoutonFavori(id: b.id)),
        Positioned(
          left: 8,
          bottom: 8,
          child: Etiquette(
            '${b.photos}',
            icone: Icons.photo_library_outlined,
            fond: const Color(0x99041936),
            couleur: Colors.white,
          ),
        ),
        const Positioned(
          right: 8,
          bottom: 8,
          child: Icon(Icons.play_circle_fill, color: Colors.white, size: 26),
        ),
      ],
    );
  }
}

/// Prix d'un bien : loyer mensuel ou prix de vente.
class PrixBien extends StatelessWidget {
  const PrixBien({super.key, required this.bien, this.taille = 16});
  final Bien bien;
  final double taille;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: fcfaCourt(bien.loyer),
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: taille),
          ),
          TextSpan(
            text: bien.vente ? ' · à vendre' : ' /mois',
            style: const TextStyle(color: LiveColors.gris, fontSize: 13),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Caractéristiques en icônes : chambres, douches, surface, meublé.
class SpecsBien extends StatelessWidget {
  const SpecsBien({super.key, required this.bien});
  final Bien bien;

  @override
  Widget build(BuildContext context) {
    final b = bien;
    final items = <(IconData, String)>[
      if (b.chambres > 0) (Icons.bed_outlined, '${b.chambres}'),
      if (b.douches > 0) (Icons.shower_outlined, '${b.douches}'),
      if (b.surface > 0) (Icons.square_foot_rounded, '${b.surface} m²'),
      if (b.meuble) (Icons.chair_outlined, 'Meublé'),
      if (b.parking && !b.meuble) (Icons.local_parking_rounded, 'Parking'),
    ];
    return SizedBox(
      height: 18,
      child: Row(
        children: [
          for (final (icone, texte) in items.take(4)) ...[
            Icon(icone, size: 15, color: LiveColors.gris),
            const SizedBox(width: 3),
            Flexible(
              child: Text(
                texte,
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: const TextStyle(fontSize: 12.5, color: LiveColors.gris),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }
}

/// Carte d'un professionnel des services : même hauteur pour tous.
class CartePro extends StatelessWidget {
  const CartePro({super.key, required this.pro});
  final Prestataire pro;

  @override
  Widget build(BuildContext context) {
    final s = pro;
    return Semantics(
      button: true,
      label: '${s.nom}, ${s.metier}, ${note(s.note)}',
      child: Pressable(
        onTap: () => context.push('/pro/${s.id}'),
        child: Container(
          height: 92,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE4E8EE)),
          ),
          child: Row(
            children: [
              Avatar(nom: s.nom, couleur: s.couleur, taille: 52, verifie: true),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${s.nom} · ${s.metier}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: LiveColors.ambre,
                        ),
                        Text(
                          ' ${note(s.note)} (${s.avis})',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    Text(
                      s.zone,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _meta,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('dès', style: _meta),
                  Text(
                    fcfa(s.prixDepuis),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Hero facultatif.
class _AvecHero extends StatelessWidget {
  const _AvecHero({
    required this.actif,
    required this.tag,
    required this.child,
  });
  final bool actif;
  final String tag;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      actif ? Hero(tag: tag, child: child) : child;
}
