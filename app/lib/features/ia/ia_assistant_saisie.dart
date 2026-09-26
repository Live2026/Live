part of 'ia_screens.dart';

/// Zone de saisie de l'Assistant : fichiers joints, texte sur plusieurs
/// lignes, bouton + (joindre), dictée, mode vocal et envoi.
class _Saisie extends StatelessWidget {
  const _Saisie({
    required this.controleur,
    required this.joints,
    required this.onJoindre,
    required this.onRetirer,
    required this.onEnvoyer,
    required this.onDicter,
    required this.onVocal,
  });
  final TextEditingController controleur;
  final List<_Fichier> joints;
  final ValueChanged<_Fichier> onJoindre;
  final ValueChanged<_Fichier> onRetirer;
  final VoidCallback onEnvoyer;
  final VoidCallback onDicter;
  final VoidCallback onVocal;

  @override
  Widget build(BuildContext context) {
    final pret = controleur.text.trim().isNotEmpty || joints.isNotEmpty;
    return SafeArea(
      top: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 792),
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 4, 12, 10),
            padding: const EdgeInsets.fromLTRB(12, 8, 8, 6),
            decoration: BoxDecoration(
              color: LiveColors.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: LiveColors.brume),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (joints.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final f in joints)
                          _PuceFichier(
                            fichier: f,
                            onRetirer: () => onRetirer(f),
                          ),
                      ],
                    ),
                  ),
                TextField(
                  controller: controleur,
                  minLines: 1,
                  maxLines: 6,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onEnvoyer(),
                  decoration: InputDecoration(
                    hintText: context.t.iaEcrivezALive,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      tooltip: context.t.iaJoindreUnFichier,
                      onPressed: () => _joindre(context),
                      icon: const Icon(Icons.add_rounded),
                    ),
                    IconButton(
                      tooltip: context.t.iaDicter,
                      onPressed: onDicter,
                      icon: const Icon(Icons.mic_none_rounded),
                    ),
                    const Spacer(),
                    if (pret)
                      IconButton.filled(
                        tooltip: context.t.iaEnvoyer,
                        onPressed: onEnvoyer,
                        style: IconButton.styleFrom(
                          backgroundColor: LiveColors.orangeVif,
                        ),
                        icon: const Icon(Icons.arrow_upward_rounded),
                      )
                    else
                      IconButton.filled(
                        tooltip: context.t.iaModeVocal,
                        onPressed: onVocal,
                        style: IconButton.styleFrom(
                          backgroundColor: LiveColors.nuit,
                        ),
                        icon: const Icon(Icons.graphic_eq_rounded),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Panneau « Joindre » : photo, appareil photo, fichier, Mes documents.
  void _joindre(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: LiveColors.surface,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(context.t.iaPhotos),
                subtitle: Text(context.t.iaUneImageUneCapture),
                onTap: () {
                  Navigator.pop(ctx);
                  onJoindre(_fichiersDemo.last);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text(context.t.iaAppareilPhoto),
                subtitle: Text(context.t.iaPhotographierUnDocument),
                onTap: () {
                  Navigator.pop(ctx);
                  onJoindre(_fichiersDemo.last);
                },
              ),
              ListTile(
                leading: const Icon(Icons.upload_file_rounded),
                title: Text(context.t.iaFichier),
                subtitle: Text(context.t.iaPdfWordExcelPowerpoint),
                onTap: () {
                  Navigator.pop(ctx);
                  _choisirFichier(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder_open_rounded),
                title: Text(context.t.iaMesDocumentsLiveIa),
                subtitle: Text(context.t.iaCvLettresBusinessPlans),
                onTap: () {
                  Navigator.pop(ctx);
                  onJoindre(_fichiersDemo[2]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Sélecteur de fichiers simulé (le vrai ouvre celui du téléphone ou de
  /// l'ordinateur).
  void _choisirFichier(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: LiveColors.surface,
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(ctx).height * 0.8,
          ),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Text(
                  context.t.iaTelechargements,
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                ),
              ),
              for (final f in _fichiersDemo)
                ListTile(
                  leading: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: f.couleur,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(f.icone, color: Colors.white, size: 22),
                  ),
                  title: Text(f.nom),
                  subtitle: Text(context.t.iaTaillePages(f.taille, f.pages)),
                  onTap: () {
                    Navigator.pop(ctx);
                    onJoindre(f);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
