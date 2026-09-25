import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/store.dart';

/// Texte qui nomme la ville choisie (Paramètres, « Pays et ville ») au lieu
/// d'une ville écrite en dur : Live vise toute la zone CEMAC.
/// [modele] contient `{ville}`, par exemple « Tendances à {ville} ».
class TexteVille extends ConsumerWidget {
  const TexteVille(this.modele, {super.key, this.style});
  final String modele;
  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ville = ref.watch(liveProvider.select((e) => e.pays));
    return Text(
      modele.replaceAll('{ville}', ville),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: style,
    );
  }
}
