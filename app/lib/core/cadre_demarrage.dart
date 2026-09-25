import 'package:flutter/material.dart';

import '../shared/animations.dart';
import 'adaptatif.dart';
import 'theme.dart';

/// Démarrage sur ordinateur : la marque et ses promesses à gauche, le
/// formulaire à droite dans une colonne lisible. Sur téléphone, la page seule.
class CadreDemarrage extends StatelessWidget {
  const CadreDemarrage({super.key, required this.child});
  final Widget child;

  static const _promesses = [
    (
      Icons.lock_rounded,
      'Argent protégé',
      'Live bloque votre paiement jusqu’à la remise, confirmée par QR.',
    ),
    (
      Icons.verified_rounded,
      'Vendeurs et agences vérifiés',
      'Identité contrôlée, avis laissés seulement par de vrais clients.',
    ),
    (
      Icons.phone_iphone_rounded,
      'MTN MoMo, Airtel Money, Visa',
      'Payez et soyez payé comme vous en avez l’habitude.',
    ),
    (
      Icons.auto_awesome_rounded,
      'Live IA',
      'CV, exercices, business plan : l’aide qu’il faut, en crédits.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (context.taille != Taille.etendue) return child;
    return Material(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [LiveColors.bleu, LiveColors.nuit],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: LayoutBuilder(
                  builder: (context, c) => SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(56, 48, 56, 40),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: c.maxHeight - 88),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'LIVE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 8,
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              'Achetez, vendez, louez,\napprenez et gagnez.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 38,
                                height: 1.15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'La place de marché sociale de Brazzaville et Pointe-Noire.',
                              style: TextStyle(
                                color: LiveColors.ambreClair,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 32),
                            for (final (i, (icone, titre, texte))
                                in _promesses.indexed)
                              Apparition(
                                rang: i + 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 18),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: const Color(0x1FFFFFFF),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Icon(
                                          icone,
                                          color: LiveColors.ambre,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              titre,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            Text(
                                              texte,
                                              style: const TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            const Spacer(),
                            const Text(
                              'Prototype · aucune transaction réelle',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
