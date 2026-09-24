import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/store.dart';
import '../../shared/widgets.dart';

/// E-MOI-01 — Moi.
class EcranMoi extends ConsumerWidget {
  const EcranMoi({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final etat = ref.watch(liveProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Moi')),
      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(
              radius: 28,
              child: Icon(Icons.person, size: 32),
            ),
            title: Text(
              etat.prenom,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: const BadgeVerifie('Identité vérifiée'),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Card(
              color: LiveColors.fondProtection,
              child: ListTile(
                leading: const Icon(
                  Icons.payments,
                  color: LiveColors.bleu,
                  size: 32,
                ),
                title: const Text(
                  "Gagner de l'argent sur Live",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Vendez, louez, proposez un service'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('/publier'),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('Mes gains'),
            trailing: Text(
              '${fcfa(etat.disponible)} dispo',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () => context.push('/gains'),
          ),
          ListTile(
            leading: const Icon(Icons.auto_awesome),
            title: const Text('Mes Crédits Live'),
            trailing: Text(
              '${etat.credits} crédits',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () => context.push('/ia/credits'),
          ),
          ListTile(
            leading: const Icon(Icons.storefront),
            title: const Text('Mes ventes'),
            trailing: Text('${etat.ventes.length}'),
            onTap: () => context.push('/mes-ventes'),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Mes achats'),
            trailing: Text('${etat.achats.length}'),
            onTap: etat.achats.isEmpty
                ? null
                : () => context.push('/suivi/${etat.achats.first.id}'),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Mes visites'),
            trailing: Text('${etat.visites.length}'),
            onTap: etat.visites.isEmpty
                ? null
                : () => context.push('/visite/${etat.visites.first.id}'),
          ),
          ListTile(
            leading: const Icon(Icons.handyman),
            title: const Text('Mes prestations'),
            trailing: Text('${etat.prestations.length}'),
            onTap: etat.prestations.isEmpty
                ? null
                : () =>
                      context.push('/prestation/${etat.prestations.first.id}'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.data_saver_on),
            title: const Text('Données utilisées ce mois'),
            trailing: const Text('312 Mo'),
          ),
          ListTile(
            leading: const Icon(Icons.science_outlined),
            title: const Text('Scénarios de test'),
            onTap: () => context.push('/scenarios'),
          ),
        ],
      ),
    );
  }
}
