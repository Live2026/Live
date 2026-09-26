part of 'messages_screens.dart';

const _vertMoi = Color(0xFFDCEBFA);

/// Forme de bulle avec une petite pointe du côté de l'auteur.
BorderRadius _forme(bool moi) => BorderRadius.only(
  topLeft: Radius.circular(moi ? 14 : 4),
  topRight: Radius.circular(moi ? 4 : 14),
  bottomLeft: const Radius.circular(14),
  bottomRight: const Radius.circular(14),
);

/// Heure et coches de lecture, en bas à droite de la bulle.
class _Horodatage extends StatelessWidget {
  const _Horodatage(this.heure, {required this.moi});
  final String heure;
  final bool moi;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          heure,
          style: const TextStyle(fontSize: 11, color: LiveColors.gris),
        ),
        if (moi) ...[
          const SizedBox(width: 3),
          const Icon(
            Icons.done_all_rounded,
            size: 15,
            color: Color(0xFF3B82F6),
          ),
        ],
      ],
    );
  }
}

class _Conteneur extends StatelessWidget {
  const _Conteneur({required this.moi, required this.child});
  final bool moi;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: moi ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 6,
          left: moi ? 48 : 0,
          right: moi ? 0 : 48,
        ),
        padding: const EdgeInsets.fromLTRB(10, 7, 10, 5),
        constraints: const BoxConstraints(maxWidth: 360),
        decoration: BoxDecoration(
          color: moi ? _vertMoi : LiveColors.surface,
          borderRadius: _forme(moi),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14041936),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _BulleTexte extends StatelessWidget {
  const _BulleTexte(this.m);
  final _Texte m;

  @override
  Widget build(BuildContext context) {
    return _Conteneur(
      moi: m.moi,
      child: Wrap(
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: 8,
        children: [
          Text(m.texte, style: const TextStyle(fontSize: 15)),
          _Horodatage(m.heure, moi: m.moi),
        ],
      ),
    );
  }
}

/// Note vocale : bouton lecture, onde, durée (F-CHAT-02).
class _BulleVocale extends StatelessWidget {
  const _BulleVocale(this.m);
  final _Vocal m;

  @override
  Widget build(BuildContext context) {
    const hauteurs = [
      6.0,
      12,
      18,
      9,
      22,
      14,
      8,
      20,
      16,
      10,
      24,
      12,
      7,
      15,
      19,
      9,
      13,
      6,
    ];
    return _Conteneur(
      moi: m.moi,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.play_arrow_rounded,
            color: LiveColors.bleu,
            size: 30,
          ),
          const SizedBox(width: 4),
          for (final h in hauteurs)
            Container(
              width: 3,
              height: h.toDouble(),
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: LiveColors.bleu.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                m.duree,
                style: const TextStyle(fontSize: 12, color: LiveColors.gris),
              ),
              _Horodatage(m.heure, moi: m.moi),
            ],
          ),
        ],
      ),
    );
  }
}

/// Lieu de rendez-vous proposé (E-CHAT-03).
class _BulleLieu extends StatelessWidget {
  const _BulleLieu(this.m);
  final _Lieu m;

  @override
  Widget build(BuildContext context) {
    return _Conteneur(
      moi: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 90,
            width: 240,
            decoration: BoxDecoration(
              color: const Color(0xFFD9E6F2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: LiveColors.bleu,
              size: 36,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Rendez-vous : ${m.lieu}',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const Text(
            'Lieu public recommandé par Live',
            style: TextStyle(fontSize: 12.5, color: LiveColors.gris),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _Horodatage(m.heure, moi: true),
          ),
        ],
      ),
    );
  }
}

/// Carte d'offre ou de contre-offre, avec son action.
class _CarteOffre extends StatelessWidget {
  const _CarteOffre({
    required this.titre,
    required this.detail,
    this.action,
    this.moi = false,
  });
  final String titre;
  final String detail;
  final Widget? action;
  final bool moi;

  @override
  Widget build(BuildContext context) {
    return _Conteneur(
      moi: moi,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_offer_outlined,
                size: 16,
                color: LiveColors.bleu,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  titre,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                  ),
                ),
              ),
            ],
          ),
          Text(detail, style: const TextStyle(color: LiveColors.gris)),
          if (action != null) ...[const SizedBox(height: 8), action!],
        ],
      ),
    );
  }
}

/// Pastille de date centrée (« Aujourd'hui »).
class _Pastille extends StatelessWidget {
  const _Pastille(this.texte);
  final String texte;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: LiveColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          texte,
          style: const TextStyle(fontSize: 12, color: LiveColors.gris),
        ),
      ),
    );
  }
}

/// Message d'information de Live, centré.
class _Info extends StatelessWidget {
  const _Info(this.texte);
  final String texte;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: LiveColors.voile,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.verified_user, size: 16, color: LiveColors.bleu),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                texte,
                style: const TextStyle(fontSize: 12.5, color: LiveColors.bleu),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Alerte automatique quand un message propose de payer hors de Live (F-CHAT-05).
class _AlerteArnaque extends StatelessWidget {
  const _AlerteArnaque();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: LiveColors.teinteAmbre,
        border: Border.all(color: LiveColors.ambreClair),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: LiveColors.cuivre),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "Attention : ce message propose un paiement en dehors de Live. Si vous payez hors de l'application, vous n'êtes PAS protégé et ne pourrez pas être remboursé.",
            ),
          ),
        ],
      ),
    );
  }
}

/// Motif discret du fond de discussion (petits points), comme WhatsApp.
class _MotifFond extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()..color = const Color(0xFFDDE3EB);
    for (double y = 10; y < s.height; y += 28) {
      for (double x = (y ~/ 28).isEven ? 10 : 24; x < s.width; x += 28) {
        canvas.drawCircle(Offset(x, y), 1.4, p);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
