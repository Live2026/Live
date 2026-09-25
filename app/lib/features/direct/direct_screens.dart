import 'dart:async';

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

part 'direct_lecteur.dart';
part 'direct_blocs.dart';
part 'direct_lancer.dart';

/// E-DIR-01 — Directs (Live Direct, phase 2) : directs en cours en grille
/// verticale façon TikTok Live, directs à venir avec rappel.
class EcranDirects extends ConsumerStatefulWidget {
  const EcranDirects({super.key});

  @override
  ConsumerState<EcranDirects> createState() => _EcranDirectsState();
}

class _EcranDirectsState extends ConsumerState<EcranDirects> {
  final _rappels = <String>{};

  @override
  Widget build(BuildContext context) {
    final marge = context.grandEcran ? 24.0 : 16.0;
    final enCours = directs.where((d) => d.enCours).toList();
    final aVenir = directs.where((d) => !d.enCours).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Directs'),
        actions: const [BoutonNotifications(), BoutonMessages()],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/direct/lancer'),
        backgroundColor: const Color(0xFFFE2C55),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.videocam_rounded),
        label: const Text('Lancer un direct'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(marge, 4, marge, 8),
            child: const BandeauApercu(module: 'Live Direct', phase: 2),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: const EnTeteSection('En direct maintenant'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: GrilleAdaptative(
              largeurMax: 220,
              espacement: 10,
              hauteur: 300,
              enfants: [
                for (final (i, d) in enCours.indexed)
                  Apparition(
                    rang: i,
                    child: _CarteDirect(direct: d),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: const EnTeteSection('À venir'),
          ),
          for (final d in aVenir)
            Padding(
              padding: EdgeInsets.fromLTRB(marge, 0, marge, 10),
              child: Bloc(
                padding: 12,
                child: Row(
                  children: [
                    Avatar(
                      nom: d.hote.nom,
                      couleur: d.hote.couleur,
                      taille: 48,
                      verifie: true,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d.titre,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '${d.hote.nom} · ${d.quand}',
                            style: const TextStyle(
                              color: LiveColors.gris,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      tooltip: _rappels.contains(d.id)
                          ? 'Rappel activé'
                          : 'Me rappeler',
                      onPressed: () {
                        setState(
                          () => _rappels.contains(d.id)
                              ? _rappels.remove(d.id)
                              : _rappels.add(d.id),
                        );
                        if (_rappels.contains(d.id)) {
                          informer(
                            context,
                            'Vous serez prévenu au début du direct.',
                          );
                        }
                      },
                      icon: Icon(
                        _rappels.contains(d.id)
                            ? Icons.notifications_active_rounded
                            : Icons.notifications_none_rounded,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Vignette verticale d'un direct : pastille EN DIRECT, spectateurs, hôte.
class _CarteDirect extends StatelessWidget {
  const _CarteDirect({required this.direct});
  final Direct direct;

  @override
  Widget build(BuildContext context) {
    final d = direct;
    return Semantics(
      button: true,
      label: 'Direct de ${d.hote.nom} : ${d.titre}',
      excludeSemantics: true,
      child: Pressable(
        onTap: () => context.push('/direct/${d.id}'),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Vignette(
                couleur: d.couleur,
                icone: Icons.videocam_rounded,
                rayon: 0,
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Color(0xCC000000)],
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                left: 8,
                top: 8,
                right: 8,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _PastilleDirect(spectateurs: d.spectateurs),
                ),
              ),
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.titre,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Avatar(
                          nom: d.hote.nom,
                          couleur: d.hote.couleur,
                          taille: 24,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            d.hote.nom,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pastille rouge « EN DIRECT » qui pulse doucement.
class _PastilleDirect extends StatelessWidget {
  const _PastilleDirect({this.spectateurs});
  final int? spectateurs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFE2C55),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, size: 7, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            spectateurs == null
                ? 'EN DIRECT'
                : 'EN DIRECT · ${compact(spectateurs!)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
