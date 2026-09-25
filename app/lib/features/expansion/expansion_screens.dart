import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptatif.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../shared/animations.dart';
import '../../shared/widgets.dart';

part 'fonds.dart';
part 'finance.dart';

/// E-LIV-01 — Live Livraison (phase 3) : suivi du livreur sur le plan de la
/// ville, étapes, code de remise, course payée dans Live.
class EcranLivraison extends StatelessWidget {
  const EcranLivraison({super.key, required this.id});
  final String id;

  static const _boutique = Offset(0.44, 0.46);
  static const _client = Offset(0.62, 0.64);

  @override
  Widget build(BuildContext context) {
    final reduit = MediaQuery.of(context).disableAnimations;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 0.65),
              duration: Duration(seconds: reduit ? 0 : 6),
              curve: Curves.easeInOut,
              builder: (_, t, _) => PlanVille(
                reperes: [
                  Repere(
                    position: _boutique,
                    libelle: 'Boutique',
                    onTap: () => context.push('/boutique/grace'),
                  ),
                  Repere(
                    position: _client,
                    libelle: 'Vous',
                    couleur: LiveColors.succes,
                    onTap: () {},
                  ),
                  Repere(
                    position: Offset.lerp(_boutique, _client, t)!,
                    libelle: 'Armel',
                    selectionne: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: BoutonVerre(
                  icone: Icons.arrow_back_rounded,
                  libelle: 'Retour',
                  onTap: () => context.pop(),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(color: Color(0x33041936), blurRadius: 16),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BandeauApercu(module: 'Live Livraison', phase: 3),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Arrivée dans 12 min',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Etiquette(
                          'En route',
                          icone: Icons.two_wheeler_rounded,
                          fond: Color(0xFFFFF1E0),
                          couleur: LiveColors.cuivre,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const ProgressionEtapes(
                      etapes: ['Prête', 'Récupérée', 'En route', 'Livrée'],
                      actuelle: 2,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Avatar(
                          nom: 'Armel Ngoma',
                          couleur: Color(0xFF0F766E),
                          taille: 44,
                          verifie: true,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Armel · livreur vérifié',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              Text(
                                'Moto · 4,9/5 · 1 240 courses',
                                style: TextStyle(
                                  color: LiveColors.gris,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton.filledTonal(
                          tooltip: 'Appeler le livreur',
                          onPressed: () => informer(
                            context,
                            'Appel par numéro masqué (simulation).',
                          ),
                          icon: const Icon(Icons.call_rounded),
                        ),
                        IconButton.filledTonal(
                          tooltip: 'Écrire au livreur',
                          onPressed: () => context.push('/conversation'),
                          icon: const Icon(Icons.chat_bubble_outline_rounded),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    const Row(
                      children: [
                        Icon(Icons.pin_rounded, color: LiveColors.bleu),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text('Code de remise à donner au livreur'),
                        ),
                        Text(
                          'LV-L4821',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Course ${fcfa(1500)} · payée dans Live, versée au livreur à la remise.',
                      style: const TextStyle(
                        color: LiveColors.gris,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
