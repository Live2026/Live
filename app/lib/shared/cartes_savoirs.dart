import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/format.dart';
import '../core/theme.dart';
import '../data/mock.dart';
import 'animations.dart';
import 'composants.dart';
import 'medias.dart';

/// Cartes des espaces Apprendre et Opportunités. Même règle que les autres
/// cartes : taille identique dans une catégorie, textes en zones fixes.

const _meta = TextStyle(color: LiveColors.gris, fontSize: 12.5, height: 1.3);

Widget _zone(BuildContext context, String texte, int lignes, TextStyle style) {
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

/// Carte d'un contenu numérique : visuel 16:9 avec type, titre sur 2 lignes,
/// auteur, note et prix.
class CarteContenu extends StatelessWidget {
  const CarteContenu({super.key, required this.contenu, this.achete = false});
  final Contenu contenu;
  final bool achete;

  @override
  Widget build(BuildContext context) {
    final c = contenu;
    return Semantics(
      button: true,
      label: '${c.type.libelle}, ${c.titre}, ${fcfa(c.prix)}',
      excludeSemantics: true,
      child: Pressable(
        onTap: () => context.push('/contenu/${c.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Vignette(couleur: c.couleur, icone: c.type.icone),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Etiquette(c.type.libelle, icone: c.type.icone),
                  ),
                  if (c.nouveau)
                    const Positioned(
                      right: 8,
                      top: 8,
                      child: Etiquette(
                        'Nouveau',
                        fond: LiveColors.orangeVif,
                        couleur: LiveColors.surface,
                      ),
                    ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Etiquette(c.format.split(' · ').first),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _zone(
              context,
              c.titre,
              2,
              const TextStyle(fontWeight: FontWeight.w700, height: 1.25),
            ),
            _zone(context, c.auteur.nom, 1, _meta),
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 15,
                  color: LiveColors.ambre,
                ),
                Expanded(
                  child: Text(
                    ' ${note(c.note).replaceAll('/5', '')} (${compact(c.avis)})',
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: _meta,
                  ),
                ),
                Text(
                  achete ? 'Acheté' : fcfa(c.prix),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: achete ? LiveColors.succes : LiveColors.nuit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Carte d'une opportunité : hauteur fixe, type, titre, organisation, lieu,
/// date limite et frais toujours visibles.
class CarteOpportunite extends StatelessWidget {
  const CarteOpportunite({super.key, required this.opportunite});
  final Opportunite opportunite;

  @override
  Widget build(BuildContext context) {
    final o = opportunite;
    final t = o.type;
    final urgent = o.joursRestants <= 10;
    return Semantics(
      button: true,
      label: '${t.libelle}, ${o.titre}, ${o.organisation.nom}',
      excludeSemantics: true,
      child: Pressable(
        onTap: () => context.push('/opportunite/${o.id}'),
        child: Container(
          height: 168,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: LiveColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: LiveColors.filet),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Avatar(
                    nom: o.organisation.nom,
                    couleur: o.organisation.couleur,
                    taille: 40,
                    verifie: true,
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: _zone(context, o.organisation.nom, 1, _meta)),
                  Etiquette(
                    t.libelle,
                    icone: t.icone,
                    fond: t.couleur.withValues(alpha: 0.12),
                    couleur: t.couleur,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _zone(
                context,
                o.titre,
                2,
                const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15.5,
                  height: 1.25,
                ),
              ),
              const Spacer(),
              _zone(
                context,
                '${o.lieu} · ${o.places} place${o.places > 1 ? 's' : ''}',
                1,
                _meta,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: 15,
                    color: urgent ? LiveColors.erreur : LiveColors.gris,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'J-${o.joursRestants} · ${o.dateLimite}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _meta.copyWith(
                        color: urgent ? LiveColors.erreur : LiveColors.gris,
                        fontWeight: urgent ? FontWeight.w700 : null,
                      ),
                    ),
                  ),
                  Text(
                    o.gratuite ? 'Gratuit' : 'Frais ${fcfaCourt(o.frais)}',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: o.gratuite ? LiveColors.succes : LiveColors.cuivre,
                    ),
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
