import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'animations.dart';

/// État du réseau. Dans l'application réelle, il suit `connectivity_plus` ;
/// dans le prototype, on le bascule depuis Moi › Paramètres › Économie de
/// données (« Simuler une coupure du réseau »).
final horsConnexion = ValueNotifier<bool>(false);

/// Bandeau affiché en haut de toutes les pages quand le réseau manque
/// (NF-03, docs/ecrans/00 §2 règle 6) : on continue d'utiliser Live, les
/// actions partent au retour du réseau (file d'envoi, docs/26 §4).
class BandeauHorsConnexion extends StatelessWidget {
  const BandeauHorsConnexion({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: horsConnexion,
      builder: (context, coupe, _) => AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: courbeDouce,
        child: !coupe
            ? const SizedBox(width: double.infinity)
            : Semantics(
                liveRegion: true,
                child: Material(
                  color: const Color(0xFF3F3F46),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.cloud_off_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Hors connexion : vos actions seront envoyées au '
                            'retour du réseau. Les paiements attendent le '
                            'réseau.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: LiveColors.ambre,
                            minimumSize: const Size(0, 36),
                          ),
                          onPressed: () => horsConnexion.value = false,
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
