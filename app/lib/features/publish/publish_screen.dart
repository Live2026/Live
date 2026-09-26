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
import '../../l10n/textes.dart';

part 'publier_media.dart';
part 'publier_legende.dart';
part 'publier_envois.dart';
part 'publier_bien.dart';
part 'publier_bien_elements.dart';
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
        context.t.publishVideoOuPhoto,
        context.t.publishPartagerDansLeFil,
        '/publier/media',
        true,
      ),
      (
        Icons.sell_rounded,
        context.t.publishVendreUnProduit,
        context.t.publishTelephoneModeMaison0,
        '/vendre',
        true,
      ),
      (
        Icons.home_work_rounded,
        context.t.publishLouerOuVendreUn,
        context.t.publishAppartementMaisonTerrainLocal,
        '/publier/bien',
        etat.identiteVerifiee,
      ),
      (
        Icons.handyman_rounded,
        context.t.publishProposerUnService,
        context.t.publishArtisanBeauteCoursEvenement,
        '/publier/service',
        etat.identiteVerifiee,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.publishPublier),
        actions: [
          TextButton(
            onPressed: () => context.push('/publier/envois'),
            child: Text(context.t.publishEnvoisEnCours),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 24),
        children: [
          Text(
            context.t.publishToutLeMondePeut,
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
                            titre: context.t.publishVerificationRequise,
                            raison: context.t.publishPouvoirVerifiez(titre),
                            route: '/verifier',
                            action: context.t.publishVerifierMonIdentite,
                          ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Bloc(
            fond: LiveColors.champ,
            child: Row(
              children: [
                const Icon(Icons.bolt_rounded, color: LiveColors.orangeVif),
                const SizedBox(width: 10),
                Expanded(child: Text(context.t.publishVoirTousMesSuper)),
                TextButton(
                  onPressed: () => context.push('/pouvoirs'),
                  child: Text(context.t.publishVoir),
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
                  color: LiveColors.voile,
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
