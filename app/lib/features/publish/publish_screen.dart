import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptatif.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/mock.dart';
import '../../data/store.dart';
import '../../shared/animations.dart';
import '../../shared/feuilles.dart';
import '../../shared/widgets.dart';

part 'publier_media.dart';
part 'publier_bien.dart';
part 'publier_service.dart';

/// E-PUB-01 — Que voulez-vous publier ? Chaque option dit si le super-pouvoir
/// correspondant est actif ; sinon elle explique comment le débloquer (E-PUB-07).
class EcranPublier extends ConsumerWidget {
  const EcranPublier({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final etat = ref.watch(liveProvider);
    final marge = context.grandEcran ? 24.0 : 16.0;
    final options = [
      (
        Icons.videocam_rounded,
        'Vidéo ou photo',
        'Partager dans le fil, comme sur TikTok',
        '/publier/media',
        true,
      ),
      (
        Icons.sell_rounded,
        'Vendre un produit',
        'Téléphone, mode, maison… 0 % pendant 3 mois',
        '/vendre',
        true,
      ),
      (
        Icons.home_work_rounded,
        'Louer ou vendre un bien',
        'Appartement, maison, terrain, local',
        '/publier/bien',
        etat.identiteVerifiee,
      ),
      (
        Icons.handyman_rounded,
        'Proposer un service',
        'Artisan, beauté, cours, événement',
        '/publier/service',
        etat.identiteVerifiee,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publier'),
        actions: [
          TextButton(
            onPressed: () => context.push('/publier/envois'),
            child: const Text('Envois en cours'),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 24),
        children: [
          const Text(
            'Tout le monde peut publier. Certaines publications demandent un '
            'super-pouvoir : il se débloque en 2 minutes.',
            style: TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 12),
          GrilleAdaptative(
            largeurMax: 420,
            espacement: 10,
            hauteur: 96,
            enfants: [
              for (final (i, (icone, titre, sous, route, actif))
                  in options.indexed)
                Apparition(
                  rang: i,
                  child: _Option(
                    icone: icone,
                    titre: titre,
                    sous: sous,
                    verrouille: !actif,
                    onTap: actif
                        ? () => context.push(route)
                        : () => pouvoirRequis(
                            context,
                            titre: 'Vérification requise',
                            raison:
                                '« $titre » est un super-pouvoir. Vérifiez votre '
                                'identité (pièce + selfie) : c’est ce qui rassure '
                                'vos futurs clients.',
                            route: '/verifier',
                            action: 'Vérifier mon identité',
                          ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Bloc(
            fond: const Color(0xFFF3F5F8),
            child: Row(
              children: [
                const Icon(Icons.bolt_rounded, color: LiveColors.orangeVif),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Voir tous mes super-pouvoirs et ce qu’ils rapportent.',
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/pouvoirs'),
                  child: const Text('Voir'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.icone,
    required this.titre,
    required this.sous,
    required this.onTap,
    this.verrouille = false,
  });
  final IconData icone;
  final String titre;
  final String sous;
  final VoidCallback onTap;
  final bool verrouille;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: titre,
      excludeSemantics: true,
      child: Pressable(
        onTap: onTap,
        child: Bloc(
          padding: 12,
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6EBF2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icone, color: LiveColors.bleu, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titre,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      sous,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: LiveColors.gris,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                verrouille
                    ? Icons.lock_outline_rounded
                    : Icons.chevron_right_rounded,
                color: verrouille ? LiveColors.orangeVif : LiveColors.gris,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
