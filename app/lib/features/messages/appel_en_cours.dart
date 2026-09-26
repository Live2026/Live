import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';
import '../../data/mock.dart';
import '../../l10n/textes.dart';
import '../../shared/widgets.dart';
import 'appels.dart';

part 'appel_commandes.dart';
part 'appel_vues.dart';

enum _Etat { entrant, sonnerie, connecte }

/// E-CHAT-11 — Appel audio, vidéo ou en groupe, comme WhatsApp : sonnerie,
/// appel reçu (accepter, refuser, répondre par message), minuteur, micro,
/// caméra, haut-parleur, ajout de participants, réseau faible.
///
/// Prototype : l'image de l'autre est simulée. En réel, WebRTC par un
/// service géré (LiveKit ou Agora, docs/20) ; Mux reste pour les vidéos
/// publiées et les directs.
class EcranAppel extends StatefulWidget {
  const EcranAppel({
    super.key,
    required this.avec,
    this.video = false,
    this.groupe,
    this.entrant = false,
  });

  final String avec;
  final bool video;
  final String? groupe;
  final bool entrant;

  @override
  State<EcranAppel> createState() => _EcranAppelState();
}

class _EcranAppelState extends State<EcranAppel> {
  late var _etat = widget.entrant ? _Etat.entrant : _Etat.sonnerie;
  var _secondes = 0;
  var _micro = true;
  late var _camera = widget.video;
  late var _hautParleur = widget.video;
  var _avant = true;
  var _reseauFaible = false;
  var _reseauVu = false;
  final _invites = <(String, Color)>[];
  Timer? _decroche;
  Timer? _minuteur;

  Color get _couleur => [...conversations, ...conversationsArchivees]
      .firstWhere(
        (c) => c.nom == widget.avec,
        orElse: () => conversations.first,
      )
      .couleur;

  @override
  void initState() {
    super.initState();
    if (!widget.entrant) {
      _decroche = Timer(const Duration(milliseconds: 2500), _connecter);
    }
  }

  void _connecter() {
    if (!mounted) return;
    setState(() => _etat = _Etat.connecte);
    _minuteur = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _secondes++;
        // Démonstration : le réseau faiblit une fois pendant un appel vidéo.
        if (_camera && !_reseauVu && _secondes == 6) {
          _reseauFaible = _reseauVu = true;
        }
      });
    });
  }

  @override
  void dispose() {
    _decroche?.cancel();
    _minuteur?.cancel();
    super.dispose();
  }

  void _raccrocher() {
    final messager = ScaffoldMessenger.of(context);
    final texte = context.t.appelTermine(dureeAppel(_secondes));
    if (_etat == _Etat.connecte) {
      messager.showSnackBar(SnackBar(content: Text(texte)));
    }
    context.canPop() ? context.pop() : context.go('/appels');
  }

  void _ajouter() {
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
                t.appelAjouterQui,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            for (final p in participantsAppel.where(
              (p) => !_invites.contains(p),
            ))
              ListTile(
                leading: Avatar(nom: p.$1, couleur: p.$2, taille: 40),
                title: Text(p.$1),
                trailing: const Icon(Icons.add_call, color: LiveColors.bleu),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _invites.add(p));
                  informer(context, t.appelAjoute(p.$1));
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final groupe = widget.groupe != null || _invites.isNotEmpty;
    final statut = switch (_etat) {
      _Etat.entrant => widget.video ? t.appelEntrantVideo : t.appelEntrantAudio,
      _Etat.sonnerie => t.appelSonnerie,
      _Etat.connecte => dureeAppel(_secondes),
    };
    final participants = [
      if (widget.groupe != null)
        ...participantsAppel.take(
          conversations
                      .firstWhere(
                        (c) => c.id == widget.groupe,
                        orElse: () => conversations[1],
                      )
                      .membres >
                  5
              ? 5
              : 3,
        )
      else
        (widget.avec, _couleur),
      ..._invites,
    ];
    return Scaffold(
      backgroundColor: LiveColors.nuit,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (groupe && _etat == _Etat.connecte)
            _GrilleAppel(
              participants: participants,
              video: _camera,
              micro: _micro,
            )
          else if (_camera && _etat == _Etat.connecte)
            _ImageSimulee(nom: widget.avec, couleur: _couleur)
          else
            _Portrait(
              nom: widget.avec,
              couleur: _couleur,
              statut: statut,
              sonne: _etat != _Etat.connecte,
            ),
          if (_camera && !groupe && _etat == _Etat.connecte)
            Positioned(
              top: MediaQuery.paddingOf(context).top + 64,
              right: 16,
              child: _Vignette(avant: _avant),
            ),
          SafeArea(
            child: Column(
              children: [
                _Haut(
                  titre: widget.avec,
                  statut: _etat == _Etat.connecte && (_camera || groupe)
                      ? statut
                      : null,
                  onReduire: _raccrocher,
                ),
                if (_reseauFaible)
                  _BandeauReseau(
                    onAudio: () => setState(() {
                      _camera = false;
                      _reseauFaible = false;
                    }),
                    onFermer: () => setState(() => _reseauFaible = false),
                  ),
                const Spacer(),
                if (_etat == _Etat.entrant)
                  _Reponse(
                    video: widget.video,
                    onAccepter: () {
                      _connecter();
                      setState(() {});
                    },
                    onRefuser: _raccrocher,
                    onMessage: () => context.pushReplacement('/conversation'),
                  )
                else
                  _Commandes(
                    micro: _micro,
                    camera: _camera,
                    video: widget.video,
                    hautParleur: _hautParleur,
                    onMicro: () => setState(() => _micro = !_micro),
                    onCamera: () => setState(() => _camera = !_camera),
                    onHautParleur: () =>
                        setState(() => _hautParleur = !_hautParleur),
                    onRetourner: () => setState(() => _avant = !_avant),
                    onAjouter: _ajouter,
                    onRaccrocher: _raccrocher,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
