part of 'apprendre_screens.dart';

/// E-APP-05 — Lecteur : vidéo ou document en haut, leçons en dessous,
/// fonctionne hors connexion après téléchargement.
class EcranLecteur extends StatefulWidget {
  const EcranLecteur({super.key, required this.id});
  final String id;

  @override
  State<EcranLecteur> createState() => _EcranLecteurState();
}

class _EcranLecteurState extends State<EcranLecteur> {
  var _lecon = 0;
  var _lecture = false;

  @override
  Widget build(BuildContext context) {
    final c = contenuParId(widget.id);
    final document = c.type == TypeContenu.pdf || c.type == TypeContenu.livre;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(c.titre, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Etiquette(
              'Hors connexion',
              icone: Icons.offline_pin_rounded,
              fond: Color(0xFFE7F4EC),
              couleur: LiveColors.succes,
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: document ? 4 / 3 : 16 / 9,
            child: document
                ? _Page(contenu: c, page: _lecon)
                : _Video(
                    contenu: c,
                    lecture: _lecture,
                    onTap: () => setState(() => _lecture = !_lecture),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              c.programme.isEmpty ? c.titre : c.programme[_lecon],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${document ? 'Chapitre' : 'Leçon'} ${_lecon + 1} sur ${c.programme.length} · ${c.auteur.nom}',
              style: const TextStyle(color: LiveColors.gris),
            ),
          ),
          const Divider(height: 24),
          for (final (i, t) in c.programme.indexed)
            ListTile(
              selected: i == _lecon,
              leading: Icon(
                i < _lecon
                    ? Icons.check_circle_rounded
                    : i == _lecon
                    ? Icons.play_circle_fill_rounded
                    : Icons.play_circle_outline_rounded,
                color: i < _lecon ? LiveColors.succes : LiveColors.bleu,
              ),
              title: Text(t),
              onTap: () => setState(() {
                _lecon = i;
                _lecture = false;
              }),
            ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: Row(
          children: [
            IconButton.outlined(
              tooltip: 'Poser une question à l’auteur',
              style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: () => context.push('/conversation'),
              icon: const Icon(Icons.forum_outlined),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton(
                onPressed: _lecon < c.programme.length - 1
                    ? () => setState(() {
                        _lecon++;
                        _lecture = false;
                      })
                    : null,
                child: Text(document ? 'Chapitre suivant' : 'Leçon suivante'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Video extends StatelessWidget {
  const _Video({
    required this.contenu,
    required this.lecture,
    required this.onTap,
  });
  final Contenu contenu;
  final bool lecture;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Vignette(
            couleur: contenu.couleur,
            icone: contenu.type.icone,
            rayon: 0,
          ),
          Center(
            child: Icon(
              lecture ? Icons.pause_circle_filled : Icons.play_circle_fill,
              color: Colors.white,
              size: 64,
              semanticLabel: lecture ? 'Pause' : 'Lire',
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 10,
            child: Row(
              children: [
                const Text('02:14', style: TextStyle(color: Colors.white)),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: const LinearProgressIndicator(
                      value: 0.3,
                      minHeight: 4,
                      color: LiveColors.orangeVif,
                      backgroundColor: Colors.white30,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('07:40', style: TextStyle(color: Colors.white)),
                const SizedBox(width: 8),
                const Etiquette('×1,25'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Page de document (PDF ou livre) simulée : lignes de texte grisées.
class _Page extends StatelessWidget {
  const _Page({required this.contenu, required this.page});
  final Contenu contenu;
  final int page;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEFF2F6),
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contenu.programme.isEmpty
                  ? contenu.titre
                  : contenu.programme[page],
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            for (final l in [1.0, 0.9, 0.95, 0.7, 1.0, 0.85, 0.6])
              FractionallySizedBox(
                widthFactor: l,
                child: Container(
                  height: 7,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDE3EB),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'Page ${page * 30 + 1}',
                style: const TextStyle(color: LiveColors.gris, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
