import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptatif.dart';
import '../../core/theme.dart';
import '../../data/mock.dart';
import '../../l10n/textes.dart';
import '../../shared/animations.dart';
import '../../shared/widgets.dart';

/// Adresse de l'écran d'appel : avec qui, en vidéo ou non, en groupe ou
/// non, reçu ou passé.
String routeAppel({
  required String avec,
  bool video = false,
  String? groupe,
  bool entrant = false,
}) => Uri(
  path: '/appel',
  queryParameters: {
    'avec': avec,
    if (video) 'video': '1',
    'groupe': ?groupe,
    if (entrant) 'entrant': '1',
  },
).toString();

/// Deux boutons d'en-tête, comme WhatsApp : appel vidéo et appel audio.
List<Widget> boutonsAppel(BuildContext context, String avec, {String? groupe}) {
  final t = context.t;
  return [
    IconButton(
      tooltip: groupe == null ? t.appelsAppelVideo : t.appelsAppelGroupe,
      onPressed: () =>
          context.push(routeAppel(avec: avec, video: true, groupe: groupe)),
      icon: const Icon(Icons.videocam_outlined),
    ),
    IconButton(
      tooltip: t.appelsAppelAudio,
      onPressed: () => context.push(routeAppel(avec: avec, groupe: groupe)),
      icon: const Icon(Icons.call_outlined),
    ),
  ];
}

/// E-CHAT-10 — Appels : historique (entrants, sortants, manqués), rappel en
/// un geste, nouvel appel. Gratuits par internet, numéro jamais montré.
class EcranAppels extends StatefulWidget {
  const EcranAppels({super.key});

  @override
  State<EcranAppels> createState() => _EcranAppelsState();
}

class _EcranAppelsState extends State<EcranAppels> {
  var _manques = false;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final liste = appelsRecents
        .where((a) => !_manques || a.sens == SensAppel.manque)
        .toList();
    return Scaffold(
      appBar: AppBar(title: Text(t.appelsTitre)),
      floatingActionButton: FloatingActionButton(
        tooltip: t.appelsNouvelAppel,
        onPressed: () => _nouvelAppel(context),
        child: const Icon(Icons.add_call),
      ),
      body: Etroit(
        largeur: 720,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 96),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  for (final (manques, libelle) in [
                    (false, t.appelsTous),
                    (true, t.appelsManques),
                  ])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(libelle),
                        selected: _manques == manques,
                        onSelected: (_) => setState(() => _manques = manques),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 16,
                    color: LiveColors.gris,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      t.appelsGratuits,
                      style: const TextStyle(
                        color: LiveColors.gris,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (liste.isEmpty)
              EtatVide(
                icone: Icons.call_missed_rounded,
                texte: t.appelsAucunManque,
              ),
            for (final (i, a) in liste.indexed)
              Apparition(
                rang: i,
                child: _LigneAppel(appel: a),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: BoutonSimulation(
                  texte: t.appelsSimulerEntrant,
                  onTap: () => context.push(
                    routeAppel(avec: 'Grâce Mode', video: true, entrant: true),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Nouvel appel : choisir une conversation, puis audio ou vidéo.
  void _nouvelAppel(BuildContext context) {
    final t = context.t;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: LiveColors.surface,
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                t.appelsChoisirContact,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            for (final c in conversations.where(
              (c) => c.type != TypeConversation.canal,
            ))
              ListTile(
                leading: Avatar(nom: c.nom, couleur: c.couleur, taille: 40),
                title: Text(
                  c.nom,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final video in [false, true])
                      IconButton(
                        tooltip: video
                            ? t.appelsAppelVideo
                            : t.appelsAppelAudio,
                        color: LiveColors.bleu,
                        onPressed: () {
                          Navigator.pop(ctx);
                          context.push(
                            routeAppel(
                              avec: c.nom,
                              video: video,
                              groupe: c.type == TypeConversation.groupe
                                  ? c.id
                                  : null,
                            ),
                          );
                        },
                        icon: Icon(
                          video ? Icons.videocam_outlined : Icons.call_outlined,
                        ),
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

class _LigneAppel extends StatelessWidget {
  const _LigneAppel({required this.appel});
  final Appel appel;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final a = appel;
    final manque = a.sens == SensAppel.manque;
    final (icone, sens) = switch (a.sens) {
      SensAppel.entrant => (Icons.call_received_rounded, t.appelsEntrant),
      SensAppel.sortant => (Icons.call_made_rounded, t.appelsSortant),
      SensAppel.manque => (Icons.call_missed_rounded, t.appelsManque),
    };
    final quand = switch (a.jour) {
      0 => t.appelsAujourdhui,
      1 => t.appelsHier,
      _ => t.appelsIlYaJours(a.jour),
    };
    return ListTile(
      leading: Avatar(
        nom: a.nom,
        couleur: a.couleur,
        taille: 44,
        enLigne: a.enLigne,
      ),
      title: Text(
        a.nom,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: manque ? LiveColors.erreur : LiveColors.encre,
        ),
      ),
      subtitle: Row(
        children: [
          Icon(
            icone,
            size: 16,
            color: manque ? LiveColors.erreur : LiveColors.succes,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              [
                t.appelsDetail(sens, quand, a.heure),
                if (a.duree > 0) dureeAppel(a.duree),
                if (a.groupe != null) t.appelsGroupeDe(a.participants),
              ].join(' · '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      trailing: IconButton(
        tooltip: a.video ? t.appelsAppelVideo : t.appelsAppelAudio,
        color: LiveColors.bleu,
        onPressed: () => context.push(
          routeAppel(avec: a.nom, video: a.video, groupe: a.groupe),
        ),
        icon: Icon(a.video ? Icons.videocam_outlined : Icons.call_outlined),
      ),
    );
  }
}

/// Durée lisible : « 3:34 » ou « 1:02:05 ».
String dureeAppel(int secondes) {
  final h = secondes ~/ 3600;
  final m = (secondes % 3600) ~/ 60;
  final s = (secondes % 60).toString().padLeft(2, '0');
  return h > 0 ? '$h:${m.toString().padLeft(2, '0')}:$s' : '$m:$s';
}
