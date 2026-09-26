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
import '../../l10n/textes.dart';

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
        title: Text(context.t.croissanceSejoursMeubles),
        actions: [
          IconButton(
            tooltip: context.t.croissanceVoirSurLaCarte,
            onPressed: () => context.push('/carte'),
            icon: const Icon(Icons.map_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 32),
        children: [
          if (reserves.isNotEmpty) ...[
            const SizedBox(height: 12),
            Bloc(
              fond: LiveColors.teinteVerte,
              child: Row(
                children: [
                  const Icon(
                    Icons.event_available_rounded,
                    color: LiveColors.succes,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      context.t.croissanceReservationConfirmee(reserves.first),
                    ),
                  ),
                ],
              ),
            ),
          ],
          EnTeteSection(context.t.croissancePourQuelquesNuits),
          GrilleAdaptative(
            largeurMax: 320,
            espacement: 14,
            enfants: [
              for (final (i, s) in sejours.indexed)
                Apparition(
                  rang: i,
                  child: CarteSejour(sejour: s),
                ),
            ],
          ),
          const SizedBox(height: 16),
          BlocReglement(
            lignes: [
              LigneReglement(
                context.t.croissanceNuitsReservees,
                Reglement.dansLive,
                detail: context.t.croissanceVerseesALHote,
              ),
              LigneReglement(
                context.t.croissanceCautionEventuelle,
                Reglement.direct,
                detail: context.t.croissanceRemiseALHote,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
