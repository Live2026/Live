part of 'messages_screens.dart';

/// Message d'un membre dans un groupe ou un canal.
class _MessageGroupe {
  const _MessageGroupe(
    this.auteur,
    this.couleur,
    this.texte,
    this.heure, {
    this.moi = false,
    this.pdf,
    this.reactions = const [],
  });
  final String auteur;
  final Color couleur;
  final String texte;
  final String heure;
  final bool moi;

  /// Pièce jointe : (nom, poids et pages).
  final (String, String)? pdf;
  final List<(String, int)> reactions;
}

const _messagesGroupe = [
  _MessageGroupe(
    'Prof. Kimbembe',
    Color(0xFF1D4ED8),
    'Bonjour à tous. Voici les annales corrigées pour samedi.',
    '09:58',
    pdf: ('Annales_Maths_2025.pdf', '2,4 Mo · 12 pages'),
    reactions: [('👍', 24), ('🙏', 9)],
  ),
  _MessageGroupe(
    'Merveille K.',
    Color(0xFF7E22CE),
    'Merci Prof ! L’exercice 3 on le fait comment ?',
    '10:01',
    reactions: [('❤️', 3)],
  ),
  _MessageGroupe(
    'Jordy M.',
    Color(0xFF0F766E),
    'Il faut dériver deux fois, c’est dans la leçon 3 du cours.',
    '10:03',
  ),
  _MessageGroupe(
    'Vous',
    LiveColors.bleu,
    'Je serai là samedi 👍',
    '10:05',
    moi: true,
    reactions: [('😄', 2)],
  ),
];

const _messagesCanal = [
  _MessageGroupe(
    'Live Opportunités',
    Color(0xFFEA580C),
    '🎓 Bourse d’excellence 2027 : 40 places, 75 000 FCFA par mois. '
        'Gratuit, date limite le 15 octobre.',
    '08:30',
    reactions: [('🔥', 412), ('🙏', 96)],
  ),
  _MessageGroupe(
    'Live Opportunités',
    Color(0xFFEA580C),
    'Rappel : aucune bourse ne se « débloque » en payant. Signalez ces messages.',
    '08:31',
    pdf: ('Guide_candidature_bourses.pdf', '640 Ko · 4 pages'),
    reactions: [('👍', 230)],
  ),
];

/// E-CHAT-04 — Groupe ou canal : membres, message épinglé, PDF, réactions.
/// Dans un canal, seuls les administrateurs publient ; les abonnés réagissent.
class EcranGroupe extends StatefulWidget {
  const EcranGroupe({super.key, required this.id});
  final String id;

  @override
  State<EcranGroupe> createState() => _EcranGroupeState();
}

class _EcranGroupeState extends State<EcranGroupe> {
  final _envoyes = <_MessageGroupe>[];
  final _saisie = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final c = [
      ...conversations,
      ...conversationsArchivees,
    ].firstWhere((x) => x.id == widget.id, orElse: () => conversations[1]);
    final canal = c.type == TypeConversation.canal;
    final messages = [
      ...(canal ? _messagesCanal : _messagesGroupe),
      ..._envoyes,
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFEEF1F5),
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Avatar(nom: c.nom, couleur: c.couleur, taille: 38),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.nom,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    canal
                        ? 'Canal · ${compact(c.membres)} abonnés'
                        : 'Groupe · ${c.membres} membres',
                    style: const TextStyle(
                      fontSize: 12,
                      color: LiveColors.gris,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Options',
            onPressed: () =>
                signaler(context, canal ? 'ce canal' : 'ce groupe'),
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: BandeauApercu(module: 'Groupes et canaux', phase: 2),
          ),
          Material(
            color: Colors.white,
            child: ListTile(
              dense: true,
              leading: const Icon(
                Icons.push_pin_rounded,
                color: LiveColors.orangeVif,
              ),
              title: const Text(
                'Message épinglé',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                canal
                    ? 'Postuler sur Live est toujours gratuit.'
                    : 'Révision samedi 10 h, salle 4. Apportez les annales.',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            child: CustomPaint(
              painter: _MotifFond(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                children: [
                  const _Pastille('Aujourd’hui'),
                  for (final m in messages) _BulleGroupe(m: m, canal: canal),
                ],
              ),
            ),
          ),
          if (canal)
            SafeArea(
              top: false,
              child: Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(14),
                child: const Text(
                  'Seuls les administrateurs publient. Réagissez aux messages '
                  'avec un appui long.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: LiveColors.gris),
                ),
              ),
            )
          else
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _saisie,
                        decoration: const InputDecoration(
                          hintText: 'Message au groupe',
                          prefixIcon: Icon(Icons.attach_file_rounded),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton.filled(
                      tooltip: 'Envoyer',
                      style: IconButton.styleFrom(
                        minimumSize: const Size(48, 48),
                      ),
                      onPressed: () {
                        if (_saisie.text.trim().isEmpty) return;
                        setState(
                          () => _envoyes.add(
                            _MessageGroupe(
                              'Vous',
                              LiveColors.bleu,
                              _saisie.text.trim(),
                              'maintenant',
                              moi: true,
                            ),
                          ),
                        );
                        _saisie.clear();
                      },
                      icon: const Icon(Icons.send_rounded),
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

/// Bulle d'un message de groupe : nom de l'auteur, PDF, réactions.
class _BulleGroupe extends StatelessWidget {
  const _BulleGroupe({required this.m, required this.canal});
  final _MessageGroupe m;
  final bool canal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: m.moi
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        _Conteneur(
          moi: m.moi,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!m.moi && !canal)
                Text(
                  m.auteur,
                  style: TextStyle(
                    color: m.couleur,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              if (m.pdf != null) _Pdf(nom: m.pdf!.$1, detail: m.pdf!.$2),
              Text(m.texte, style: const TextStyle(fontSize: 15)),
              Align(
                alignment: Alignment.centerRight,
                child: _Horodatage(m.heure, moi: m.moi),
              ),
            ],
          ),
        ),
        if (m.reactions.isNotEmpty)
          Transform.translate(
            offset: const Offset(0, -8),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE4E8EE)),
              ),
              child: Text(
                [for (final (e, n) in m.reactions) '$e ${compact(n)}']
                    .join('  '),
                style: const TextStyle(fontSize: 12.5),
              ),
            ),
          ),
      ],
    );
  }
}

/// Pièce jointe PDF dans une bulle : nom, poids, pages, téléchargement.
class _Pdf extends StatelessWidget {
  const _Pdf({required this.nom, required this.detail});
  final String nom;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.picture_as_pdf_rounded,
            color: Color(0xFFDC2626),
            size: 34,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nom,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  detail,
                  style: const TextStyle(color: LiveColors.gris, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          const Icon(
            Icons.download_rounded,
            color: LiveColors.bleu,
            semanticLabel: 'Télécharger',
          ),
        ],
      ),
    );
  }
}
