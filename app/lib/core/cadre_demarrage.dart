import 'dart:math';

import 'package:flutter/material.dart';

import '../shared/animations.dart';
import '../shared/demarrage.dart';
import '../shared/logo.dart';
import 'adaptatif.dart';
import 'theme.dart';

/// Démarrage sur ordinateur (docs/ecrans/00, section 8) : à gauche, Live
/// se présente (slogan animé, espaces, promesses) ; à droite, le formulaire
/// dans une carte avec le logo. Sur téléphone et tablette, la page seule.
/// Image de fond du démarrage sur ordinateur : déposer le fichier à cet
/// emplacement (dossier déclaré dans pubspec.yaml). Sans image, le fond animé
/// de Live s'affiche.
const imageFondDemarrage = 'assets/images/fond_demarrage.jpg';

class CadreDemarrage extends StatelessWidget {
  const CadreDemarrage({super.key, required this.child, this.hauteur = 620});
  final Widget child;

  /// Hauteur de la carte, adaptée au contenu de chaque page (router.dart) :
  /// la carte ne prend jamais toute la hauteur, le fond reste visible.
  final double hauteur;

  static const _promesses = [
    (
      Icons.lock_rounded,
      'Argent protégé',
      'Bloqué par Live jusqu’à la remise, confirmée par QR.',
    ),
    (
      Icons.verified_rounded,
      'Comptes vérifiés',
      'Vendeurs, agences et pros contrôlés ; avis de vrais clients.',
    ),
    (
      Icons.account_balance_wallet_rounded,
      'Mobile Money et carte',
      'Payez et soyez payé comme vous en avez l’habitude.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (context.taille != Taille.etendue) return child;
    return Material(
      color: LiveColors.nuit,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const _Fond(),
          Row(
            children: [
              const Expanded(flex: 6, child: _Presentation()),
              Expanded(
                flex: 5,
                child: LayoutBuilder(
                  builder: (context, c) => Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: SizedBox(
                        width: 440,
                        height: min(hauteur, c.maxHeight - 64),
                        child: Apparition(child: _Carte(child: child)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// La carte du formulaire : logo en tête, page dessous.
class _Carte extends StatelessWidget {
  const _Carte({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 48,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 22, bottom: 2),
              child: LogoLive(taille: 34),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

/// Fond de toute la page : l'image si elle est fournie, sinon le fond animé ;
/// un voile à gauche garde le texte lisible.
class _Fond extends StatelessWidget {
  const _Fond();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          imageFondDemarrage,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) =>
              const FondDemarrage(child: SizedBox.expand()),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xCC041936), Color(0x33041936)],
              stops: [0.35, 1],
            ),
          ),
        ),
      ],
    );
  }
}

class _Presentation extends StatelessWidget {
  const _Presentation();

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(56, 44, 56, 36),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: c.maxHeight - 80),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LogoLive(taille: 40, couleur: Colors.white),
                    const Spacer(),
                    const SloganAnime(taille: 46),
                    const SizedBox(height: 14),
                    const Text(
                      'La place de marché sociale de l’Afrique centrale : '
                      'produits, logements, services, directs, cours et '
                      'emplois, au même endroit.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 17,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final (i, (icone, nom, couleur))
                            in espacesLive.indexed)
                          Apparition(
                            rang: i + 1,
                            child: PastilleEspace(
                              icone: icone,
                              nom: nom,
                              couleur: couleur,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final (icone, titre, texte)
                            in CadreDemarrage._promesses)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(icone, color: LiveColors.ambre),
                                  const SizedBox(height: 8),
                                  Text(
                                    titre,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    texte,
                                    style: const TextStyle(
                                      color: Colors.white60,
                                      fontSize: 13,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),
                    const SizedBox(height: 24),
                    const Text(
                      '6 pays de la CEMAC · une seule monnaie, le FCFA · '
                      'Prototype, aucune transaction réelle',
                      style: TextStyle(color: Colors.white54, fontSize: 12.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
