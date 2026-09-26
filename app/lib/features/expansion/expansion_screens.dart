import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptatif.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../shared/animations.dart';
import '../../shared/widgets.dart';
import '../../l10n/textes.dart';

part 'fonds.dart';
part 'finance.dart';
part 'partenaires.dart';

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
              builder: (_, t, _) => CarteInteractive(
                margeBas: 380,
                lieuVueRue: 'Moungali, Brazzaville',
                maPosition: _client,
                trajet: const [_boutique, Offset(0.52, 0.5), _client],
                reperes: [
                  Repere(
                    position: _boutique,
                    libelle: context.t.expansionBoutique,
                    onTap: () => context.push('/boutique/grace'),
                  ),
                  Repere(
                    position: _client,
                    libelle: context.t.expansionVous,
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
                  libelle: context.t.retour,
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
                color: LiveColors.surface,
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            context.t.expansionArriveeDans12Min,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Etiquette(
                          context.t.expansionEnRoute,
                          icone: Icons.two_wheeler_rounded,
                          fond: LiveColors.teinteOrange,
                          couleur: LiveColors.cuivre,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ProgressionEtapes(
                      etapes: [
                        context.t.expansionPrete,
                        context.t.expansionRecuperee,
                        context.t.expansionEnRoute,
                        context.t.expansionLivree,
                      ],
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.t.expansionArmelLivreurVerifie,
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              Text(
                                context.t.expansionMoto495,
                                style: TextStyle(
                                  color: LiveColors.gris,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton.filledTonal(
                          tooltip: context.t.expansionAppelerLeLivreur,
                          onPressed: () => informer(
                            context,
                            context.t.expansionAppelParNumeroMasque,
                          ),
                          icon: const Icon(Icons.call_rounded),
                        ),
                        IconButton.filledTonal(
                          tooltip: context.t.expansionEcrireAuLivreur,
                          onPressed: () => context.push('/conversation'),
                          icon: const Icon(Icons.chat_bubble_outline_rounded),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      children: [
                        Icon(Icons.pin_rounded, color: LiveColors.bleu),
                        SizedBox(width: 8),
                        Expanded(child: Text(context.t.expansionCodeDeRemiseA)),
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
                      context.t.expansionCourse(fcfa(1500)),
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
