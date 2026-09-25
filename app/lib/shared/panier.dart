import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/store.dart';

/// Icône du panier (contenus numériques) avec le nombre d'articles.
class BoutonPanier extends ConsumerWidget {
  const BoutonPanier({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = ref.watch(liveProvider.select((e) => e.panier.length));
    return IconButton(
      tooltip: 'Panier',
      onPressed: () => context.push('/panier'),
      icon: Badge(
        isLabelVisible: n > 0,
        label: Text('$n'),
        child: const Icon(Icons.shopping_cart_outlined),
      ),
    );
  }
}
