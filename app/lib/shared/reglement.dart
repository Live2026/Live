import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/format.dart';
import '../core/theme.dart';
import '../data/modeles.dart';

/// Ce qui se paie où : dans Live (protégé), sur place après avoir vu, ou en
/// direct au propriétaire ou à l'organisme. Affiché sur toutes les fiches.

/// Pastille « Dans Live », « Sur place » ou « En direct ».
class PastilleReglement extends StatelessWidget {
  const PastilleReglement(this.reglement, {super.key, this.long = false});
  final Reglement reglement;
  final bool long;

  @override
  Widget build(BuildContext context) {
    final c = reglement.couleur;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(reglement.icone, size: 13, color: c),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              long ? reglement.libelle : reglement.court,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: c,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Une somme et l'endroit où elle se paie.
class LigneReglement {
  const LigneReglement(
    this.libelle,
    this.reglement, {
    this.montant,
    this.detail,
  });
  final String libelle;
  final Reglement reglement;
  final int? montant;
  final String? detail;
}

/// Bloc « Comment ça se paie » : chaque somme avec son mode de règlement.
class BlocReglement extends StatelessWidget {
  const BlocReglement({
    super.key,
    required this.lignes,
    this.titre = 'Comment ça se paie',
    this.note,
  });
  final List<LigneReglement> lignes;
  final String titre;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4E8EE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.payments_outlined, color: LiveColors.bleu),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  titre,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final l in lignes)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.libelle,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        if (l.detail != null)
                          Text(
                            l.detail!,
                            style: const TextStyle(
                              color: LiveColors.gris,
                              fontSize: 12.5,
                            ),
                          ),
                        const SizedBox(height: 4),
                        PastilleReglement(l.reglement, long: true),
                      ],
                    ),
                  ),
                  if (l.montant != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      l.montant == 0 ? 'Gratuit' : fcfa(l.montant!),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ],
              ),
            ),
          if (note != null) ...[
            const Divider(height: 18),
            Text(
              note!,
              style: const TextStyle(color: LiveColors.gris, fontSize: 12.5),
            ),
          ],
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 36),
              ),
              onPressed: () => context.push('/paiements'),
              child: const Text('Comprendre les paiements sur Live'),
            ),
          ),
        ],
      ),
    );
  }
}

/// En-tête d'un assistant par étapes : barre de progression et titre.
class EtapesAssistant extends StatelessWidget {
  const EtapesAssistant({super.key, required this.titres, required this.etape});
  final List<String> titres;
  final int etape;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var i = 0; i < titres.length; i++)
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: i <= etape
                        ? LiveColors.bleu
                        : const Color(0xFFE4E8EE),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Étape ${etape + 1} sur ${titres.length}',
          style: const TextStyle(color: LiveColors.gris, fontSize: 13),
        ),
        Text(
          titres[etape],
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

/// Boutons Retour / Continuer d'un assistant par étapes.
class BoutonsAssistant extends StatelessWidget {
  const BoutonsAssistant({
    super.key,
    required this.etape,
    required this.derniere,
    required this.onRetour,
    required this.onSuivant,
    this.libelleFin = 'Publier',
  });
  final int etape;
  final bool derniere;
  final VoidCallback onRetour;
  final VoidCallback? onSuivant;
  final String libelleFin;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (etape > 0) ...[
          Expanded(
            child: OutlinedButton(
              onPressed: onRetour,
              child: const Text('Retour'),
            ),
          ),
          const SizedBox(width: 10),
        ],
        Expanded(
          flex: 2,
          child: FilledButton(
            onPressed: onSuivant,
            child: Text(derniere ? libelleFin : 'Continuer'),
          ),
        ),
      ],
    );
  }
}
