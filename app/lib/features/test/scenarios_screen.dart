import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';
import '../../data/store.dart';

/// Scénarios du test terrain : lus par l'animateur, un par participant.
/// Voir docs/prototype/Protocole_test_terrain.md.
class EcranScenarios extends ConsumerWidget {
  const EcranScenarios({super.key});

  static const scenarios = [
    (
      '1. Acheter',
      "Vous voulez l'iPhone 11 de Grâce Mode. Achetez-le en payant avec MTN MoMo, puis confirmez que vous l'avez reçu.",
    ),
    (
      '2. Vendre',
      'Vous voulez vendre votre vieux téléphone 30 000 FCFA. Publiez l\'annonce, acceptez la commande, puis remettez le téléphone à l\'acheteuse.',
    ),
    (
      '3. Visiter un logement',
      "Vous cherchez un logement à Moungali à moins de 100 000 FCFA par mois. Trouvez-en un, dites combien il coûte pour entrer, et réservez une visite.",
    ),
    (
      '4. Demander un devis',
      "L'évier de votre cuisine fuit. Trouvez un plombier, choisissez un devis et payez l'acompte.",
    ),
    (
      '5. Retirer ses gains',
      'Vous avez des gains sur Live. Retirez 50 000 FCFA sur votre MoMo.',
    ),
    (
      '6. Live IA',
      'Achetez 500 FCFA de crédits avec MoMo, faites votre CV de comptable, puis faites-vous expliquer l\'exercice « 2x + 3 = 11 ».',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scénarios de test')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: LiveColors.fondAlerte,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "Pour l'animateur : lisez la tâche au participant, puis rendez-lui le téléphone sur l'écran d'accueil. N'aidez pas : notez où il hésite.",
            ),
          ),
          const SizedBox(height: 12),
          for (final (titre, texte) in scenarios)
            Card(
              child: ListTile(
                title: Text(
                  titre,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(texte),
              ),
            ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              ref.read(liveProvider.notifier).reinitialiser();
              context.go('/bienvenue');
            },
            icon: const Icon(Icons.restart_alt),
            label: const Text('Réinitialiser pour un nouveau participant'),
          ),
        ],
      ),
    );
  }
}
