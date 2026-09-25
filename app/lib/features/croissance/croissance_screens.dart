import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptatif.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/mock.dart';
import '../../data/store.dart';
import '../../shared/animations.dart';
import '../../shared/widgets.dart';

part 'sejour.dart';
part 'live_plus.dart';
part 'publicite.dart';
part 'offres_pro.dart';

/// Lance un paiement commun (écran de paiement de Live).
void _payer(
  BuildContext context,
  WidgetRef ref,
  TypePaiement type,
  int montant,
  String libelle,
  String cibleId, {
  String beneficiaire = 'Live',
}) {
  ref
      .read(liveProvider.notifier)
      .preparerPaiement(
        PaiementEnCours(
          type: type,
          montant: montant,
          libelle: libelle,
          beneficiaire: beneficiaire,
          cibleId: cibleId,
        ),
      );
  context.push('/payer');
}

/// E-SEJ-01 — Séjours meublés (location de courte durée, phase 2) : payés
/// dans Live et versés à l'hôte après l'arrivée, contrairement aux loyers.
class EcranSejours extends ConsumerWidget {
  const EcranSejours({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reserves = ref.watch(liveProvider.select((e) => e.sejoursReserves));
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Séjours meublés'),
        actions: [
          IconButton(
            tooltip: 'Voir sur la carte',
            onPressed: () => context.push('/carte'),
            icon: const Icon(Icons.map_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 32),
        children: [
          const BandeauApercu(module: 'La location de courte durée', phase: 2),
          if (reserves.isNotEmpty) ...[
            const SizedBox(height: 12),
            Bloc(
              fond: const Color(0xFFE7F4EC),
              child: Row(
                children: [
                  const Icon(
                    Icons.event_available_rounded,
                    color: LiveColors.succes,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Réservation ${reserves.first} confirmée. Le code d’accès '
                      'arrive la veille par message.',
                    ),
                  ),
                ],
              ),
            ),
          ],
          const EnTeteSection('Pour quelques nuits'),
          GrilleAdaptative(
            largeurMax: 320,
            espacement: 14,
            enfants: [
              for (final (i, s) in sejours.indexed)
                Apparition(
                  rang: i,
                  child: _CarteSejour(sejour: s),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const BlocReglement(
            lignes: [
              LigneReglement(
                'Nuits réservées',
                Reglement.dansLive,
                detail: 'Versées à l’hôte après votre arrivée (QR à l’entrée)',
              ),
              LigneReglement(
                'Caution éventuelle',
                Reglement.direct,
                detail: 'Remise à l’hôte, rendue au départ',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CarteSejour extends StatelessWidget {
  const _CarteSejour({required this.sejour});
  final Sejour sejour;

  @override
  Widget build(BuildContext context) {
    final s = sejour;
    return Semantics(
      button: true,
      label: '${s.titre}, ${fcfa(s.nuit)} la nuit',
      excludeSemantics: true,
      child: Pressable(
        onTap: () => context.push('/sejour/${s.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Vignette(couleur: s.couleur, icone: Icons.king_bed_rounded),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Etiquette(
                      '${s.voyageurs} voyageur${s.voyageurs > 1 ? 's' : ''}',
                      icone: Icons.people_alt_rounded,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Etiquette(
                      note(s.note).replaceAll('/5', ''),
                      icone: Icons.star_rounded,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              s.titre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              '${s.quartier} · ${s.hote.nom}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: LiveColors.gris, fontSize: 12.5),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: fcfa(s.nuit),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const TextSpan(
                    text: ' la nuit',
                    style: TextStyle(color: LiveColors.gris),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
