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

part 'fans.dart';

/// Seuil d'audience du programme Créateurs (document 03, C-CREATEUR).
const seuilCreateur = 500;

/// E-CRE-01 — Studio créateur (Live Créateurs, phase 2) : statistiques,
/// outils de création, progression vers la monétisation, sources de revenus.
class EcranStudio extends ConsumerStatefulWidget {
  const EcranStudio({super.key});

  @override
  ConsumerState<EcranStudio> createState() => _EcranStudioState();
}

class _EcranStudioState extends ConsumerState<EcranStudio> {
  var _periode = 28;

  @override
  Widget build(BuildContext context) {
    final etat = ref.watch(liveProvider);
    const abonnes = 128;
    final marge = context.grandEcran ? 24.0 : 16.0;
    final facteur = _periode == 7 ? 1 : 4;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Studio créateur'),
        actions: [
          for (final p in const [7, 28])
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ChoiceChip(
                label: Text('$p j'),
                selected: _periode == p,
                onSelected: (_) => setState(() => _periode = p),
              ),
            ),
          const SizedBox(width: 6),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 32),
        children: [
          const BandeauApercu(module: 'Live Créateurs', phase: 2),
          const SizedBox(height: 12),
          GrilleAdaptative(
            largeurMax: 200,
            espacement: 10,
            hauteur: 112,
            enfants: [
              TuileChiffre(
                libelle: 'Vues',
                valeur: compact(3100 * facteur),
                icone: Icons.visibility_outlined,
                detail: '+12 % sur la période',
              ),
              TuileChiffre(
                libelle: 'Temps de visionnage',
                valeur: '${42 * facteur} h',
                icone: Icons.schedule_rounded,
                detail: 'moyenne 38 s par vidéo',
              ),
              TuileChiffre(
                libelle: 'Nouveaux abonnés',
                valeur: '+${9 * facteur}',
                icone: Icons.person_add_alt_1_outlined,
                detail: 'grâce à vos directs',
                couleur: LiveColors.succes,
              ),
              TuileChiffre(
                libelle: 'Cadeaux reçus',
                valeur: '0 FCFA',
                icone: Icons.card_giftcard_rounded,
                detail: 'dès $seuilCreateur abonnés',
                couleur: LiveColors.cuivre,
              ),
            ],
          ),
          const SizedBox(height: 14),
          _CarteMonetisation(abonnes: abonnes, identite: etat.identiteVerifiee),
          const EnTeteSection('Outils de création'),
          GrilleAdaptative(
            largeurMax: 130,
            espacement: 8,
            hauteur: 92,
            enfants: [
              for (final (icone, libelle, route) in const [
                (Icons.videocam_rounded, 'Vidéo', '/publier/media'),
                (Icons.podcasts_rounded, 'Direct', '/direct/lancer'),
                (Icons.school_rounded, 'Cours', '/apprendre/vendre'),
                (Icons.poll_rounded, 'Sondage', ''),
                (Icons.event_rounded, 'Programmer', ''),
              ])
                Semantics(
                  button: true,
                  label: libelle,
                  excludeSemantics: true,
                  child: Pressable(
                    onTap: () => route.isEmpty
                        ? informer(
                            context,
                            '$libelle : prévu avec Live Créateurs (phase 2).',
                          )
                        : context.push(route),
                    child: Bloc(
                      padding: 8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icone, color: LiveColors.orangeVif, size: 28),
                          const SizedBox(height: 6),
                          Text(
                            libelle,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const EnTeteSection('Comment les créateurs gagnent'),
          for (final (icone, titre, texte) in const [
            (
              Icons.card_giftcard_rounded,
              'Cadeaux',
              'Offerts par les fans pendant les directs et sous les vidéos.',
            ),
            (
              Icons.star_rounded,
              'Abonnements de fans',
              '500 ou 1 500 FCFA par mois : badge et contenus réservés.',
            ),
            (
              Icons.shopping_bag_rounded,
              'Live shopping',
              'Vos produits, ou ceux d’une boutique partenaire, vendus en direct.',
            ),
            (
              Icons.handshake_rounded,
              'Partenariats de marques',
              'Contrats signés dans Live, paiement garanti.',
            ),
          ])
            LigneMenu(icone: icone, titre: titre, detail: texte),
          const SizedBox(height: 8),
          const Text(
            'Vous gardez 75 % des cadeaux et des abonnements de fans ; Live '
            'garde 25 % (document 02). Retrait sur MoMo ou Airtel Money.',
            style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => context.push('/fans/kimbembe'),
            icon: const Icon(Icons.visibility_outlined),
            label: const Text('Voir la page fans d’un créateur'),
          ),
        ],
      ),
    );
  }
}

/// Progression vers la monétisation : 500 abonnés et identité vérifiée.
class _CarteMonetisation extends StatelessWidget {
  const _CarteMonetisation({required this.abonnes, required this.identite});
  final int abonnes;
  final bool identite;

  @override
  Widget build(BuildContext context) {
    final part = (abonnes / seuilCreateur).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [LiveColors.bleu, LiveColors.nuit],
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 84,
            height: 84,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: part),
              duration: const Duration(milliseconds: 900),
              curve: courbeDouce,
              builder: (_, v, _) => Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: v,
                    strokeWidth: 8,
                    color: LiveColors.orangeVif,
                    backgroundColor: Colors.white24,
                  ),
                  Center(
                    child: Text(
                      '${(v * 100).round()} %',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Programme Créateurs',
                  style: TextStyle(
                    color: LiveColors.ambreClair,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$abonnes / $seuilCreateur abonnés · il en manque ${seuilCreateur - abonnes}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  identite ? 'Identité vérifiée' : 'Identité à vérifier',
                  style: TextStyle(
                    color: identite ? const Color(0xFF86EFAC) : Colors.white70,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Ensuite : cadeaux, abonnements de fans et partenariats.',
                  style: TextStyle(color: Colors.white70, fontSize: 12.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
