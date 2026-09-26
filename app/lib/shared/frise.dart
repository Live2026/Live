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
                          color: e.faite ? LiveColors.bleu : LiveColors.surface,
                          border: Border.all(
                            color: e.faite || i == encours
                                ? LiveColors.bleu
                                : LiveColors.bord,
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
                            color: e.faite ? LiveColors.bleu : LiveColors.filet,
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
                                ? LiveColors.encre
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

/// Progression horizontale en étapes (livraison, candidature…) : barres
/// colorées jusqu'à l'étape en cours, libellés dessous.
class ProgressionEtapes extends StatelessWidget {
  const ProgressionEtapes({
    super.key,
    required this.etapes,
    required this.actuelle,
  });
  final List<String> etapes;
  final int actuelle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final (i, e) in etapes.indexed)
          Expanded(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  height: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: i <= actuelle ? LiveColors.succes : LiveColors.filet,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  e,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: i <= actuelle ? LiveColors.encre : LiveColors.gris,
                    fontWeight: i == actuelle ? FontWeight.w700 : null,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
