part of 'publish_screen.dart';

/// Bouton rond translucide de la caméra (fermer).
class _BoutonCamera extends StatelessWidget {
  const _BoutonCamera({required this.icone, required this.libelle, this.onTap});
  final IconData icone;
  final String libelle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: libelle,
      onPressed: onTap,
      style: IconButton.styleFrom(backgroundColor: Colors.black38),
      icon: Icon(icone, color: Colors.white),
    );
  }
}

/// Outil de la colonne de droite : icône et libellé dessous, comme TikTok.
class _OutilCamera extends StatelessWidget {
  const _OutilCamera({required this.icone, required this.libelle, this.onTap});
  final IconData icone;
  final String libelle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: libelle,
      excludeSemantics: true,
      child: Pressable(
        echelle: 0.85,
        onTap: onTap ?? () {},
        child: SizedBox(
          width: 60,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                Icon(
                  icone,
                  color: Colors.white,
                  size: 28,
                  shadows: const [Shadow(blurRadius: 8)],
                ),
                const SizedBox(height: 2),
                Text(
                  libelle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    shadows: [Shadow(blurRadius: 6)],
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

/// Miniature « Galerie » en bas à gauche, avec le nombre de médias choisis.
class _MiniatureGalerie extends StatelessWidget {
  const _MiniatureGalerie({
    required this.couleur,
    required this.nombre,
    required this.onTap,
  });
  final Color couleur;
  final int nombre;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: context.t.publishGalerie,
      excludeSemantics: true,
      child: Pressable(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Badge(
              isLabelVisible: nombre > 0,
              label: Text('$nombre'),
              backgroundColor: LiveColors.orangeVif,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: LiveColors.surface, width: 2),
                ),
                child: Vignette(
                  couleur: couleur,
                  icone: Icons.photo_library_rounded,
                  rayon: 8,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.t.publishGalerie,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Gros bouton d'enregistrement : anneau de progression, rond rouge qui
/// devient un carré pendant l'enregistrement.
class _BoutonEnregistrer extends StatelessWidget {
  const _BoutonEnregistrer({
    required this.enCours,
    required this.progression,
    required this.onTap,
  });
  final bool enCours;
  final double progression;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: enCours ? context.t.publishArreter : context.t.enregistrer,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 84,
          height: 84,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.expand(
                child: CircularProgressIndicator(
                  value: progression,
                  strokeWidth: 5,
                  color: LiveColors.orangeVif,
                  backgroundColor: Colors.white54,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: courbeDouce,
                width: enCours ? 30 : 64,
                height: enCours ? 30 : 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFFE2C55),
                  borderRadius: BorderRadius.circular(enCours ? 8 : 32),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Deuxième étape, façon Instagram : légende, lien vers une annonce (bouton
/// « Acheter » sur la vidéo), visibilité, lieu, commentaires.
class _EtapeLegende extends StatefulWidget {
  const _EtapeLegende({
    required this.couleur,
    required this.duree,
    required this.photos,
    required this.onRetour,
  });
  final Color couleur;
  final int duree;
  final int photos;
  final VoidCallback onRetour;

  @override
  State<_EtapeLegende> createState() => _EtapeLegendeState();
}

class _EtapeLegendeState extends State<_EtapeLegende> {
  late final _legende = TextEditingController(
    text: context.t.publishLegendeDemo,
  );
  var _lien = 'Robe wax longue';
  var _qui = 'Tout le monde';
  var _commentaires = true;
  var _whatsapp = true;

  @override
  Widget build(BuildContext context) {
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: context.t.publishRetourALaCamera,
          onPressed: widget.onRetour,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(context.t.publishNouvellePublication),
        actions: [
          TextButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.t.publishBrouillonEnregistre)),
            ),
            child: Text(context.t.publishBrouillon),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 8, marge, 24),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 96,
                height: 170,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Vignette(
                      couleur: widget.couleur,
                      icone: Icons.play_arrow_rounded,
                      rayon: 10,
                    ),
                    Positioned(
                      left: 6,
                      bottom: 6,
                      child: Etiquette(
                        widget.duree > 0
                            ? '0:${widget.duree.toString().padLeft(2, '0')}'
                            : context.t.publishNPhotos(widget.photos),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _legende,
                  minLines: 6,
                  maxLines: 8,
                  maxLength: 300,
                  decoration: InputDecoration(
                    hintText: context.t.publishDecrivezVotreVideoAjoutez,
                  ),
                ),
              ),
            ],
          ),
          EnTeteSection(context.t.publishLierAUneAnnonce),
          Text(
            context.t.publishUnBoutonAcheterApparait,
            style: TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final l in const [
                'Aucune',
                'Robe wax longue',
                'Pagne wax 6 yards',
                'Sac à main cuir',
              ])
                ChoiceChip(
                  label: Text(l == 'Aucune' ? context.t.publishAucune : l),
                  selected: _lien == l,
                  onSelected: (_) => setState(() => _lien = l),
                ),
            ],
          ),
          const SizedBox(height: 12),
          LigneMenu(
            icone: Icons.public_rounded,
            titre: context.t.publishQuiPeutVoir,
            valeur: _qui == 'Tout le monde'
                ? context.t.publishToutLeMonde
                : context.t.publishMesAbonnes,
            onTap: () => setState(
              () => _qui = _qui == 'Tout le monde'
                  ? 'Mes abonnés'
                  : 'Tout le monde',
            ),
          ),
          LigneMenu(
            icone: Icons.location_on_outlined,
            titre: context.t.publishLieu,
            valeur: 'Moungali',
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _commentaires,
            onChanged: (v) => setState(() => _commentaires = v),
            title: Text(context.t.publishAutoriserLesCommentaires),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _whatsapp,
            onChanged: (v) => setState(() => _whatsapp = v),
            title: Text(context.t.publishPartagerAussiEnStatut),
          ),
          const SizedBox(height: 4),
          Text(
            context.t.publishLaVideoEstCompressee,
            style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: () => context.pushReplacement('/publier/envois'),
          child: Text(context.t.publishPublier),
        ),
      ),
    );
  }
}
