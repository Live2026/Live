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

part 'tontines.dart';
part 'tontine_detail.dart';
part 'achats_groupes.dart';
part 'diaspora.dart';
part 'transfert.dart';
part 'factures.dart';
part 'adresse_points.dart';

/// Piliers « référence » de Live (docs/21) : tontines, achats groupés,
/// diaspora, factures du quotidien, Adresse Live et points relais.

/// Lance l'écran de paiement commun de Live.
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

/// Bandeau d'en-tête des piliers : dégradé, icône, titre, promesse.
class _Banniere extends StatelessWidget {
  const _Banniere({
    required this.icone,
    required this.titre,
    required this.texte,
    required this.couleurs,
    this.enfant,
  });
  final IconData icone;
  final String titre;
  final String texte;
  final List<Color> couleurs;
  final Widget? enfant;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: couleurs,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(
            titre,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            texte,
            style: const TextStyle(color: Colors.white, height: 1.35),
          ),
          if (enfant != null) ...[const SizedBox(height: 14), enfant!],
        ],
      ),
    );
  }
}
