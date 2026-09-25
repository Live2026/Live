part of 'publish_screen.dart';

/// E-PUB-02 — Photos et vidéo : filmer ou choisir, légende, lien vers une annonce.
class EcranPublierMedia extends StatefulWidget {
  const EcranPublierMedia({super.key});

  @override
  State<EcranPublierMedia> createState() => _EcranPublierMediaState();
}

class _EcranPublierMediaState extends State<EcranPublierMedia> {
  var _choisi = 0;
  var _lien = 'Aucune';
  final _legende = TextEditingController(
    text: 'Nouvel arrivage ! Livraison 24 h à Brazzaville.',
  );

  static const _galerie = [
    Color(0xFFB45309),
    Color(0xFF334155),
    Color(0xFF166534),
    Color(0xFF7E22CE),
    Color(0xFF0E7490),
    Color(0xFF9A3412),
    Color(0xFF1E3A8A),
    Color(0xFF3F6212),
  ];

  @override
  Widget build(BuildContext context) {
    final grand = context.grandEcran;
    final apercu = AspectRatio(
      aspectRatio: 9 / 16,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Vignette(
            couleur: _galerie[_choisi],
            icone: Icons.videocam_rounded,
            rayon: 16,
          ),
          Positioned(
            right: 10,
            top: 10,
            child: Column(
              children: [
                for (final (icone, nom) in const [
                  (Icons.music_note_rounded, 'Son'),
                  (Icons.text_fields_rounded, 'Texte'),
                  (Icons.auto_fix_high_rounded, 'Filtres'),
                  (Icons.speed_rounded, 'Vitesse'),
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: BoutonVerre(
                      icone: icone,
                      libelle: nom,
                      onTap: () {},
                    ),
                  ),
              ],
            ),
          ),
          const Positioned(
            left: 12,
            bottom: 12,
            child: Etiquette(
              '0:24 / 1:00',
              fond: Color(0x99041936),
              couleur: Colors.white,
            ),
          ),
        ],
      ),
    );
    final formulaire = <Widget>[
      const Text('Galerie', style: TextStyle(fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      SizedBox(
        height: 84,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _galerie.length,
          separatorBuilder: (_, _) => const SizedBox(width: 6),
          itemBuilder: (_, i) => Semantics(
            button: true,
            selected: i == _choisi,
            label: 'Vidéo ${i + 1}',
            excludeSemantics: true,
            child: GestureDetector(
              onTap: () => setState(() => _choisi = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 60,
                padding: EdgeInsets.all(i == _choisi ? 2 : 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: i == _choisi
                        ? LiveColors.orangeVif
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Vignette(
                  couleur: _galerie[i],
                  icone: Icons.play_arrow_rounded,
                  rayon: 8,
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 16),
      TextField(
        controller: _legende,
        maxLines: 2,
        decoration: const InputDecoration(
          labelText: 'Légende',
          hintText: 'Décrivez votre vidéo, #hashtags',
        ),
      ),
      const SizedBox(height: 16),
      const Text(
        'Lier à une annonce',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      const Text(
        'Un bouton « Acheter » apparaîtra sur la vidéo.',
        style: TextStyle(color: LiveColors.gris, fontSize: 13),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final l in const [
            'Aucune',
            'Robe wax longue',
            'iPhone 11 64 Go',
            'Sac à main cuir',
          ])
            ChoiceChip(
              label: Text(l),
              selected: _lien == l,
              onSelected: (_) => setState(() => _lien = l),
            ),
        ],
      ),
      const SizedBox(height: 12),
      const LigneMenu(
        icone: Icons.public_rounded,
        titre: 'Qui peut voir',
        valeur: 'Tout le monde',
      ),
      const LigneMenu(
        icone: Icons.location_on_outlined,
        titre: 'Lieu',
        valeur: 'Moungali',
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle vidéo')),
      body: grand
          ? DeuxColonnes(
              ratio: 2 / 3,
              principale: [Center(child: SizedBox(width: 320, child: apercu))],
              secondaire: formulaire,
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(child: SizedBox(width: 220, child: apercu)),
                const SizedBox(height: 16),
                ...formulaire,
              ],
            ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: () => context.pushReplacement('/publier/envois'),
          child: const Text('Publier la vidéo'),
        ),
      ),
    );
  }
}

/// E-PUB-06 — Envois en cours : compression, envoi, publication, reprise.
class EcranEnvois extends StatefulWidget {
  const EcranEnvois({super.key});

  @override
  State<EcranEnvois> createState() => _EcranEnvoisState();
}

class _EcranEnvoisState extends State<EcranEnvois> {
  var _wifi = false;
  var _repris = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Envois en cours')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _Envoi(
            titre: 'Nouvel arrivage ! Livraison 24 h…',
            etape: 'Compression pour réseau mobile',
            progression: 0.62,
            couleur: Color(0xFFB45309),
          ),
          const _Envoi(
            titre: 'Robe wax longue · photos',
            etape: 'Publié il y a 2 min',
            progression: 1,
            couleur: Color(0xFF9A3412),
          ),
          _Envoi(
            titre: 'Visite du studio',
            etape: _repris ? 'Reprise de l’envoi…' : 'Connexion perdue à 48 %',
            progression: _repris ? 0.55 : 0.48,
            couleur: const Color(0xFF334155),
            erreur: !_repris,
            onReprendre: () => setState(() => _repris = true),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Envoyer seulement en Wi-Fi'),
            subtitle: const Text(
              'Les vidéos attendent une connexion Wi-Fi pour économiser vos données.',
            ),
            value: _wifi,
            onChanged: (v) => setState(() => _wifi = v),
          ),
          const Text(
            'L’envoi reprend là où il s’est arrêté si la connexion coupe : rien n’est perdu.',
            style: TextStyle(color: LiveColors.gris, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _Envoi extends StatelessWidget {
  const _Envoi({
    required this.titre,
    required this.etape,
    required this.progression,
    required this.couleur,
    this.erreur = false,
    this.onReprendre,
  });
  final String titre;
  final String etape;
  final double progression;
  final Color couleur;
  final bool erreur;
  final VoidCallback? onReprendre;

  @override
  Widget build(BuildContext context) {
    final fini = progression >= 1;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Bloc(
        padding: 12,
        child: Row(
          children: [
            SizedBox(
              width: 48,
              height: 64,
              child: Vignette(
                couleur: couleur,
                icone: Icons.play_arrow_rounded,
                rayon: 8,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    etape,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: erreur
                          ? LiveColors.erreur
                          : fini
                          ? LiveColors.succes
                          : LiveColors.gris,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TweenAnimationBuilder<double>(
                    tween: Tween(end: progression),
                    duration: const Duration(milliseconds: 900),
                    curve: courbeDouce,
                    builder: (_, v, _) => LinearProgressIndicator(
                      value: v,
                      minHeight: 5,
                      borderRadius: BorderRadius.circular(3),
                      color: erreur
                          ? LiveColors.erreur
                          : fini
                          ? LiveColors.succes
                          : LiveColors.bleu,
                    ),
                  ),
                ],
              ),
            ),
            if (erreur)
              IconButton(
                tooltip: 'Reprendre',
                onPressed: onReprendre,
                icon: const Icon(Icons.refresh_rounded),
              )
            else if (fini)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: LiveColors.succes,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
