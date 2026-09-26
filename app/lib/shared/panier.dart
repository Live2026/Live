import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/mock.dart';
import '../data/store.dart';
import '../l10n/textes.dart';

/// Icône du panier (contenus numériques) avec le nombre d'articles.
class BoutonPanier extends ConsumerWidget {
  const BoutonPanier({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = ref.watch(liveProvider.select((e) => e.panier.length));
    return IconButton(
      tooltip: context.t.panier,
      onPressed: () => context.push('/panier'),
      icon: Badge(
        isLabelVisible: n > 0,
        label: Text('$n'),
        child: const Icon(Icons.shopping_cart_outlined),
      ),
    );
  }
}

/// Cloche des notifications des barres du haut, avec le nombre de nouveautés.
class BoutonNotifications extends StatelessWidget {
  const BoutonNotifications({super.key, this.couleur});
  final Color? couleur;

  @override
  Widget build(BuildContext context) {
    final n = notificationsDemo.where((x) => x.nouvelle).length;
    return IconButton(
      tooltip: context.t.notifications,
      onPressed: () => context.push('/notifications'),
      icon: Badge(
        isLabelVisible: n > 0,
        label: Text('$n'),
        child: Icon(Icons.notifications_none_rounded, color: couleur),
      ),
    );
  }
}

/// Sac « Mes commandes » du Market : nombre de commandes en cours. Une
/// commande reste liée à un seul vendeur (pas de panier multi-vendeurs).
class BoutonCommandes extends ConsumerWidget {
  const BoutonCommandes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = ref.watch(
      liveProvider.select(
        (e) =>
            e.achats.where((c) => c.statut != StatutCommande.terminee).length,
      ),
    );
    return IconButton(
      tooltip: context.t.mesCommandes,
      onPressed: () => context.push('/commandes'),
      icon: Badge(
        isLabelVisible: n > 0,
        label: Text('$n'),
        child: const Icon(Icons.shopping_bag_outlined),
      ),
    );
  }
}
