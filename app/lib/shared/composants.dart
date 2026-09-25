import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'animations.dart';

/// Petits composants réutilisés sur tous les écrans : en-têtes de section,
/// carrousels, pastilles, avatars, étoiles, états vides, chiffres clés.

/// Titre de section avec lien « Voir tout » facultatif.
class EnTeteSection extends StatelessWidget {
  const EnTeteSection(this.titre, {super.key, this.action, this.onTap});
  final String titre;
  final String? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              titre,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
          ),
          if (onTap != null)
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size(0, 36),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              onPressed: onTap,
              child: Text(action ?? 'Voir tout'),
            ),
        ],
      ),
    );
  }
}

/// Rangée défilante horizontale de cartes de même largeur.
class Carrousel extends StatelessWidget {
  const Carrousel({
    super.key,
    required this.largeur,
    required this.hauteur,
    required this.enfants,
    this.marge = 16,
  });
  final double largeur;
  final double hauteur;
  final List<Widget> enfants;

  /// Marge latérale, pour aligner la première carte sur le reste de la page.
  final double marge;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: hauteur,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: marge),
        itemCount: enfants.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) => SizedBox(width: largeur, child: enfants[i]),
      ),
    );
  }
}

/// Pastille posée sur une photo ou une carte (vérifié, nouveau, sponsorisé).
class Etiquette extends StatelessWidget {
  const Etiquette(
    this.texte, {
    super.key,
    this.icone,
    this.fond = const Color(0xEBFFFFFF),
    this.couleur = LiveColors.nuit,
  });
  final String texte;
  final IconData? icone;
  final Color fond;
  final Color couleur;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: fond,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icone != null) ...[
            Icon(icone, size: 13, color: couleur),
            const SizedBox(width: 3),
          ],
          Flexible(
            child: Text(
              texte,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: couleur,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Avatar rond avec initiales, anneau facultatif et coche de vérification.
class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.nom,
    required this.couleur,
    this.taille = 44,
    this.verifie = false,
    this.anneau = false,
    this.enLigne = false,
  });
  final String nom;
  final Color couleur;
  final double taille;
  final bool verifie;

  /// Anneau orange « nouvelle vidéo », comme les stories.
  final bool anneau;
  final bool enLigne;

  String get _initiales {
    final mots = nom
        .replaceAll('@', '')
        .split(RegExp(r'[ .·]'))
        .where((m) => m.isNotEmpty)
        .toList();
    return mots.take(2).map((m) => m[0].toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    final rond = Container(
      width: taille,
      height: taille,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [couleur, Color.lerp(couleur, Colors.black, 0.3)!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Text(
        _initiales,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: taille * 0.36,
        ),
      ),
    );
    return Stack(
      clipBehavior: Clip.none,
      children: [
        anneau
            ? Container(
                padding: const EdgeInsets.all(2.5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [LiveColors.orangeVif, LiveColors.ambre],
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: rond,
                ),
              )
            : rond,
        if (verifie)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.verified,
                size: taille * 0.34,
                color: LiveColors.bleu,
              ),
            ),
          ),
        if (enLigne)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: taille * 0.28,
              height: taille * 0.28,
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}

/// Note en étoiles (affichage).
class Etoiles extends StatelessWidget {
  const Etoiles(this.note, {super.key, this.taille = 16});
  final double note;
  final double taille;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          Icon(
            note >= i
                ? Icons.star_rounded
                : note >= i - 0.5
                ? Icons.star_half_rounded
                : Icons.star_outline_rounded,
            size: taille,
            color: LiveColors.ambre,
          ),
      ],
    );
  }
}

/// Sélecteur de note de 1 à 5 étoiles, avec une petite animation.
class SelecteurEtoiles extends StatelessWidget {
  const SelecteurEtoiles({
    super.key,
    required this.note,
    required this.onChange,
  });
  final int note;
  final ValueChanged<int> onChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 1; i <= 5; i++)
          Semantics(
            button: true,
            selected: note == i,
            label: '$i étoile${i > 1 ? 's' : ''}',
            child: Pressable(
              echelle: 0.85,
              onTap: () => onChange(i),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: AnimatedScale(
                  scale: note >= i ? 1.12 : 1,
                  duration: const Duration(milliseconds: 180),
                  curve: courbeDouce,
                  child: Icon(
                    note >= i ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 44,
                    color: note >= i ? LiveColors.ambre : LiveColors.brume,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Message quand une liste est vide, avec une action pour avancer.
class EtatVide extends StatelessWidget {
  const EtatVide({
    super.key,
    required this.icone,
    required this.texte,
    this.action,
    this.onTap,
  });
  final IconData icone;
  final String texte;
  final String? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0xFFEFF2F6),
              shape: BoxShape.circle,
            ),
            child: Icon(icone, size: 34, color: LiveColors.gris),
          ),
          const SizedBox(height: 12),
          Text(
            texte,
            textAlign: TextAlign.center,
            style: const TextStyle(color: LiveColors.gris),
          ),
          if (action != null) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: onTap, child: Text(action!)),
          ],
        ],
      ),
    );
  }
}

/// Chiffre clé dans une tuile (tableaux de bord).
class TuileChiffre extends StatelessWidget {
  const TuileChiffre({
    super.key,
    required this.libelle,
    required this.valeur,
    required this.icone,
    this.detail,
    this.couleur = LiveColors.bleu,
  });
  final String libelle;
  final String valeur;
  final IconData icone;
  final String? detail;
  final Color couleur;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4E8EE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icone, size: 18, color: couleur),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  libelle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: LiveColors.gris, fontSize: 13),
                ),
              ),
            ],
          ),
          const Spacer(),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              valeur,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ),
          Text(
            detail ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: LiveColors.gris, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// Puce de filtre ou de catégorie avec icône (rangées défilantes).
class PuceIcone extends StatelessWidget {
  const PuceIcone({
    super.key,
    required this.icone,
    required this.texte,
    required this.onTap,
    this.active = false,
  });
  final IconData icone;
  final String texte;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      child: Pressable(
        onTap: onTap,
        child: SizedBox(
          width: 76,
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: active ? LiveColors.bleu : const Color(0xFFEFF2F6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icone,
                  color: active ? Colors.white : LiveColors.bleu,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                texte,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
