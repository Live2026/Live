import 'package:flutter/material.dart';

import '../shared/animations.dart';
import '../shared/demarrage.dart';
import '../shared/logo.dart';
import 'adaptatif.dart';
import 'theme.dart';

/// Démarrage sur ordinateur (docs/ecrans/00, section 8) : à gauche, Live
/// se présente (slogan animé, espaces, promesses) ; à droite, le formulaire
/// dans une carte avec le logo. Sur téléphone et tablette, la page seule.
class CadreDemarrage extends StatelessWidget {
  const CadreDemarrage({super.key, required this.child});
  final Widget child;

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
      color: const Color(0xFFF3F5F8),
      child: Row(
        children: [
          const Expanded(flex: 6, child: _Presentation()),
          Expanded(
            flex: 5,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 460,
                    maxHeight: 760,
                  ),
                  child: Apparition(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A041936),
                            blurRadius: 40,
                            offset: Offset(0, 16),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 28, bottom: 4),
                              child: LogoLive(taille: 40),
                            ),
                            Expanded(child: child),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Presentation extends StatelessWidget {
  const _Presentation();

  @override
  Widget build(BuildContext context) {
    return FondDemarrage(
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
