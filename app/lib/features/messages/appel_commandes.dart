part of 'appel_en_cours.dart';

/// Bouton rond de l'appel, avec son nom dessous.
class _BoutonRond extends StatelessWidget {
  const _BoutonRond({
    required this.icone,
    required this.libelle,
    required this.onTap,
    this.fond,
    this.actif = false,
  });
  final IconData icone;
  final String libelle;
  final VoidCallback onTap;
  final Color? fond;
  final bool actif;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: fond == null ? actif : null,
      label: libelle,
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: fond ?? (actif ? Colors.white : Colors.white24),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              child: SizedBox(
                width: 56,
                height: 56,
                child: Icon(
                  icone,
                  color: fond == null && actif ? LiveColors.nuit : Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              libelle,
              maxLines: 1,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

/// Les commandes pendant l'appel.
class _Commandes extends StatelessWidget {
  const _Commandes({
    required this.micro,
    required this.camera,
    required this.video,
    required this.hautParleur,
    required this.onMicro,
    required this.onCamera,
    required this.onHautParleur,
    required this.onRetourner,
    required this.onAjouter,
    required this.onRaccrocher,
  });
  final bool micro, camera, video, hautParleur;
  final VoidCallback onMicro,
      onCamera,
      onHautParleur,
      onRetourner,
      onAjouter,
      onRaccrocher;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final boutons = [
      _BoutonRond(
        icone: micro ? Icons.mic_rounded : Icons.mic_off_rounded,
        libelle: t.appelMicro,
        actif: !micro,
        onTap: onMicro,
      ),
      _BoutonRond(
        icone: camera ? Icons.videocam_rounded : Icons.videocam_off_rounded,
        libelle: t.appelCamera,
        actif: camera,
        onTap: onCamera,
      ),
      if (camera)
        _BoutonRond(
          icone: Icons.cameraswitch_rounded,
          libelle: t.appelRetourner,
          onTap: onRetourner,
        )
      else
        _BoutonRond(
          icone: Icons.volume_up_rounded,
          libelle: t.appelHautParleur,
          actif: hautParleur,
          onTap: onHautParleur,
        ),
      _BoutonRond(
        icone: Icons.person_add_alt_1_rounded,
        libelle: t.appelAjouter,
        onTap: onAjouter,
      ),
      _BoutonRond(
        icone: Icons.call_end_rounded,
        libelle: t.appelRaccrocher,
        fond: LiveColors.erreur,
        onTap: onRaccrocher,
      ),
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 16),
      padding: const EdgeInsets.fromLTRB(8, 14, 8, 10),
      constraints: const BoxConstraints(maxWidth: 480),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(children: [for (final b in boutons) Expanded(child: b)]),
    );
  }
}

/// Appel reçu : refuser, accepter, ou répondre par message.
class _Reponse extends StatelessWidget {
  const _Reponse({
    required this.video,
    required this.onAccepter,
    required this.onRefuser,
    required this.onMessage,
  });
  final bool video;
  final VoidCallback onAccepter, onRefuser, onMessage;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
      child: Column(
        children: [
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            onPressed: onMessage,
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            label: Text(t.appelRepondreMessage),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _BoutonRond(
                icone: Icons.call_end_rounded,
                libelle: t.appelRefuser,
                fond: LiveColors.erreur,
                onTap: onRefuser,
              ),
              _BoutonRond(
                icone: video ? Icons.videocam_rounded : Icons.call_rounded,
                libelle: t.appelAccepter,
                fond: const Color(0xFF16A34A),
                onTap: onAccepter,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
