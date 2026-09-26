part of 'feed_screen.dart';

/// E-FEED-03 — Commentaires d'une vidéo (panneau du bas, 70 % de l'écran).
Future<void> ouvrirCommentaires(BuildContext context, Publication p) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: LiveColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => FractionallySizedBox(
      heightFactor: 0.72,
      child: _FeuilleCommentaires(pub: p),
    ),
  );
}

class _FeuilleCommentaires extends StatefulWidget {
  const _FeuilleCommentaires({required this.pub});
  final Publication pub;

  @override
  State<_FeuilleCommentaires> createState() => _FeuilleCommentairesState();
}

class _FeuilleCommentairesState extends State<_FeuilleCommentaires> {
  final _saisie = TextEditingController();
  final _miens = <Commentaire>[];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: LiveColors.brume,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  context.t.accueilNCommentaires(widget.pub.commentaires),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              IconButton(
                tooltip: context.t.fermer,
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              for (final c in [...commentairesDemo, ..._miens])
                LigneCommentaire(c: c),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              12,
              8,
              12,
              8 + MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: Row(
              children: [
                const Avatar(
                  nom: 'Grâce Mabiala',
                  couleur: LiveColors.bleu,
                  taille: 36,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _saisie,
                    decoration: InputDecoration(
                      hintText: context.t.accueilAjouterCommentaire,
                    ),
                    onSubmitted: (_) => _publier(),
                  ),
                ),
                IconButton(
                  tooltip: context.t.accueilPublier,
                  onPressed: _publier,
                  icon: const Icon(Icons.send_rounded, color: LiveColors.bleu),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _publier() {
    final t = _saisie.text.trim();
    if (t.isEmpty) return;
    setState(
      () => _miens.add(
        Commentaire(
          'Grâce Mabiala',
          t,
          'maintenant',
          0,
          couleur: LiveColors.bleu,
        ),
      ),
    );
    _saisie.clear();
  }
}

/// Un commentaire : avatar, auteur (badge si c'est le vendeur), texte, j'aime.
class LigneCommentaire extends StatefulWidget {
  const LigneCommentaire({super.key, required this.c});
  final Commentaire c;

  @override
  State<LigneCommentaire> createState() => _LigneCommentaireState();
}

class _LigneCommentaireState extends State<LigneCommentaire> {
  var _aime = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.c;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar(nom: c.auteur, couleur: c.couleur, taille: 36),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      c.auteur,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: LiveColors.gris,
                      ),
                    ),
                    if (c.vendeur) ...[
                      const SizedBox(width: 6),
                      Etiquette(
                        context.t.accueilVendeur,
                        fond: LiveColors.voile,
                        couleur: LiveColors.bleu,
                      ),
                    ],
                  ],
                ),
                Text(c.texte),
                Text(
                  context.t.accueilRepondreQuand(c.quand),
                  style: const TextStyle(fontSize: 12, color: LiveColors.gris),
                ),
              ],
            ),
          ),
          Semantics(
            button: true,
            label: context.t.accueilAimeCommentaire,
            excludeSemantics: true,
            child: GestureDetector(
              onTap: () => setState(() => _aime = !_aime),
              child: Column(
                children: [
                  Icon(
                    _aime
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 18,
                    color: _aime ? const Color(0xFFFF4D67) : LiveColors.gris,
                  ),
                  Text(
                    '${c.likes + (_aime ? 1 : 0)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: LiveColors.gris,
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
