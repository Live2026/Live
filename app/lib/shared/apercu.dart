import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Bandeau des modules prévus après le MVP (docs/04, section 5) : l'écran
/// montre la direction du produit, sans faire partie du lancement.
class BandeauApercu extends StatelessWidget {
  const BandeauApercu({super.key, required this.module, required this.phase});
  final String module;
  final int phase;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1ECFE),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.rocket_launch_rounded,
            size: 18,
            color: Color(0xFF6D28D9),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Aperçu · $module arrive en phase $phase, après le lancement.',
              style: const TextStyle(fontSize: 12.5, color: LiveColors.nuit),
            ),
          ),
        ],
      ),
    );
  }
}
