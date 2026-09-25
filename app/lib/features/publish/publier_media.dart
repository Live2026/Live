part of 'publish_screen.dart';

/// Couleurs des vidéos et photos de la galerie simulée.
const _galerie = [
  Color(0xFFB45309),
  Color(0xFF334155),
  Color(0xFF166534),
  Color(0xFF7E22CE),
  Color(0xFF0E7490),
  Color(0xFF9A3412),
  Color(0xFF1E3A8A),
  Color(0xFF3F6212),
  Color(0xFF9D174D),
  Color(0xFF0F766E),
  Color(0xFF475569),
  Color(0xFFC27A25),
];

/// E-PUB-02 — Créer une vidéo, plein écran comme TikTok ou Reels : viseur,
/// outils à droite, bouton d'enregistrement avec progression jusqu'à 60 s
/// (D-05), galerie en panneau (10 photos + 1 vidéo). « Suivant » ouvre la
/// légende et le lien vers une annonce.
class EcranPublierMedia extends StatefulWidget {
  const EcranPublierMedia({super.key});

  @override
  State<EcranPublierMedia> createState() => _EcranPublierMediaState();
}

class _EcranPublierMediaState extends State<EcranPublierMedia>
    with SingleTickerProviderStateMixin {
  // L'enregistrement simulé avance quatre fois plus vite que le temps réel.
  late final _enregistrement = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 15),
  )..addListener(() => setState(() {}));
  var _couleur = 0;
  var _vitesse = 1.0;
  var _flash = false;
  var _avant = false;
  var _filtre = 'Original';
  final _choisis = <int>{};
  var _legende = false;

  bool get _enCours => _enregistrement.isAnimating;
  int get _secondes => (_enregistrement.value * 60).round();
  bool get _pret => _secondes > 0 || _choisis.isNotEmpty;

  @override
  void dispose() {
    _enregistrement.dispose();
    super.dispose();
  }

  void _basculer() {
    if (_enCours) {
      _enregistrement.stop();
    } else if (_enregistrement.value < 1) {
      _enregistrement.forward();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_legende) {
      return _EtapeLegende(
        couleur: _galerie[_couleur],
        duree: _secondes,
        photos: _choisis.length,
        onRetour: () => setState(() => _legende = false),
      );
    }
    final ecran = Stack(
      fit: StackFit.expand,
      children: [
        // Viseur : l'image filmée occupe tout l'écran.
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          layoutBuilder: (actuel, anciens) =>
              Stack(fit: StackFit.expand, children: [...anciens, ?actuel]),
          child: Container(
            key: ValueKey('$_couleur$_avant$_filtre'),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _galerie[_couleur],
                  Color.lerp(_galerie[_couleur], Colors.black, 0.7)!,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Icon(
              _avant ? Icons.face_retouching_natural : Icons.videocam_rounded,
              size: 96,
              color: Colors.white.withValues(alpha: 0.18),
            ),
          ),
        ),
        // Progression de l'enregistrement, en haut, comme TikTok.
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: _enregistrement.value,
                    minHeight: 4,
                    color: LiveColors.orangeVif,
                    backgroundColor: Colors.white24,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _BoutonCamera(
                      icone: Icons.close_rounded,
                      libelle: 'Fermer',
                      onTap: () => context.pop(),
                    ),
                    const Spacer(),
                    Material(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => _choisirSon(context),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.music_note_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Ajouter un son',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Outils à droite.
        Positioned(
          right: 8,
          top: 110,
          child: SafeArea(
            child: Column(
              children: [
                _OutilCamera(
                  icone: Icons.flip_camera_ios_rounded,
                  libelle: 'Retourner',
                  onTap: () => setState(() => _avant = !_avant),
                ),
                _OutilCamera(
                  icone: Icons.speed_rounded,
                  libelle:
                      '×${_vitesse.toString().replaceAll('.0', '').replaceAll('.', ',')}',
                  onTap: () => setState(
                    () => _vitesse = switch (_vitesse) {
                      1.0 => 2.0,
                      2.0 => 0.5,
                      _ => 1.0,
                    },
                  ),
                ),
                _OutilCamera(
                  icone: Icons.auto_fix_high_rounded,
                  libelle: _filtre,
                  onTap: () => setState(
                    () => _filtre = switch (_filtre) {
                      'Original' => 'Lumineux',
                      'Lumineux' => 'Chaud',
                      _ => 'Original',
                    },
                  ),
                ),
                const _OutilCamera(icone: Icons.timer_outlined, libelle: '3 s'),
                _OutilCamera(
                  icone: _flash
                      ? Icons.flash_on_rounded
                      : Icons.flash_off_rounded,
                  libelle: 'Flash',
                  onTap: () => setState(() => _flash = !_flash),
                ),
                const _OutilCamera(
                  icone: Icons.text_fields_rounded,
                  libelle: 'Texte',
                ),
              ],
            ),
          ),
        ),
        // Bas : conseil, chrono, galerie, enregistrer, suivant.
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                children: [
                  AnimatedOpacity(
                    opacity: _enCours || _secondes > 0 ? 0 : 1,
                    duration: const Duration(milliseconds: 250),
                    child: const Etiquette(
                      'Filmez l’objet de près, en pleine lumière, 30 s suffisent',
                      icone: Icons.lightbulb_outline_rounded,
                      fond: Colors.black45,
                      couleur: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '0:${_secondes.toString().padLeft(2, '0')} / 1:00',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      shadows: [Shadow(blurRadius: 6)],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: _MiniatureGalerie(
                            couleur: _galerie[(_couleur + 3) % _galerie.length],
                            nombre: _choisis.length,
                            onTap: () => _ouvrirGalerie(context),
                          ),
                        ),
                      ),
                      _BoutonEnregistrer(
                        enCours: _enCours,
                        progression: _enregistrement.value,
                        onTap: _basculer,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            transitionBuilder: (c, a) =>
                                ScaleTransition(scale: a, child: c),
                            child: _pret && !_enCours
                                ? FilledButton(
                                    key: const ValueKey('suivant'),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: LiveColors.orangeVif,
                                      minimumSize: const Size(0, 44),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                      ),
                                    ),
                                    onPressed: () =>
                                        setState(() => _legende = true),
                                    child: const Text('Suivant'),
                                  )
                                : const SizedBox(key: ValueKey('vide')),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: context.grandEcran
          ? Center(
              child: AspectRatio(aspectRatio: 9 / 16, child: ecran),
            )
          : ecran,
    );
  }

  void _choisirSon(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (titre, auteur) in const [
              ('Son original', 'Votre voix'),
              ('Ndombolo 2026', 'Tendance près de chez vous'),
              ('Rumba douce', 'Musique libre de droits'),
              ('Afro beat', 'Musique libre de droits'),
            ])
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFEFF2F6),
                  child: Icon(Icons.music_note_rounded, color: LiveColors.bleu),
                ),
                title: Text(titre),
                subtitle: Text(auteur),
                onTap: () => Navigator.pop(ctx),
              ),
          ],
        ),
      ),
    );
  }

  /// Galerie : jusqu'à 10 photos et 1 vidéo, avec compteur.
  void _ouvrirGalerie(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, maj) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Galerie',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      '${_choisis.length} / 10 + 1 vidéo',
                      style: const TextStyle(color: LiveColors.gris),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                GridView.extent(
                  shrinkWrap: true,
                  maxCrossAxisExtent: 90,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  childAspectRatio: 9 / 14,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (var i = 0; i < _galerie.length; i++)
                      Semantics(
                        button: true,
                        selected: _choisis.contains(i),
                        label: 'Média ${i + 1}',
                        excludeSemantics: true,
                        child: GestureDetector(
                          onTap: () {
                            void f() => _choisis.contains(i)
                                ? _choisis.remove(i)
                                : _choisis.length < 10
                                ? _choisis.add(i)
                                : null;
                            maj(f);
                            setState(() => _couleur = i);
                          },
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Vignette(
                                couleur: _galerie[i],
                                icone: i % 3 == 0
                                    ? Icons.play_arrow_rounded
                                    : Icons.photo_rounded,
                                rayon: 6,
                              ),
                              if (i % 3 == 0)
                                const Positioned(
                                  left: 4,
                                  bottom: 4,
                                  child: Etiquette('0:42'),
                                ),
                              Positioned(
                                right: 4,
                                top: 4,
                                child: CircleAvatar(
                                  radius: 11,
                                  backgroundColor: _choisis.contains(i)
                                      ? LiveColors.orangeVif
                                      : Colors.black26,
                                  child: _choisis.contains(i)
                                      ? Text(
                                          '${_choisis.toList().indexOf(i) + 1}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Valider'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
