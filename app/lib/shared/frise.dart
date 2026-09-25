import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Étape d'une frise chronologique (commande, visite, prestation).
class EtapeFrise {
  const EtapeFrise(this.titre, this.detail, this.faite);
  final String titre;
  final String detail;
  final bool faite;
}

/// Frise verticale : pastilles reliées par un trait, l'étape en cours soulignée.
class Frise extends StatelessWidget {
  const Frise({super.key, required this.etapes});
  final List<EtapeFrise> etapes;

  @override
  Widget build(BuildContext context) {
    final encours = etapes.indexWhere((e) => !e.faite);
    return Column(
      children: [
        for (final (i, e) in etapes.indexed)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 28,
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: e.faite ? LiveColors.bleu : Colors.white,
                          border: Border.all(
                            color: e.faite || i == encours
                                ? LiveColors.bleu
                                : const Color(0xFFC3CAD4),
                            width: 2,
                          ),
                        ),
                        child: e.faite
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      if (i < etapes.length - 1)
                        Expanded(
                          child: Container(
                            width: 2,
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            color: e.faite
                                ? LiveColors.bleu
                                : const Color(0xFFE4E8EE),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.titre,
                          style: TextStyle(
                            fontWeight: i == encours || e.faite
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: e.faite || i == encours
                                ? LiveColors.nuit
                                : LiveColors.gris,
                          ),
                        ),
                        Text(
                          e.detail,
                          style: const TextStyle(
                            color: LiveColors.gris,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
