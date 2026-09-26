part of 'market_screens.dart';

/// Live IA dans la vente : une photo suffit. L'objet est reconnu, la
/// catégorie, le titre, l'état, la description et le prix conseillé sont
/// proposés ; le vendeur vérifie et corrige.
extension _VendreAvecIa on _EcranVendreState {
  Future<void> _photoVersAnnonce() async {
    final remplir = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: LiveColors.surface,
      builder: (_) => const _AnalysePhoto(),
    );
    if (remplir != true) return;
    _maj(() {
      _categorie = 'Téléphones';
      _photos = 3;
      _titre.text = 'Samsung Galaxy A10 32 Go';
      _choix
        ..['Marque'] = 'Samsung'
        ..['Stockage'] = '32 Go';
      _etat = 'Très bon état';
      _description.text = context.t.marketDescriptionIa(_quartier);
      _prix.text = '30000';
      _etape = 2;
    });
  }
}

/// Bannière de la première étape : vendre à partir d'une photo.
class _BanniereIa extends StatelessWidget {
  const _BanniereIa({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6D28D9), LiveColors.bleu],
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Row(
              children: [
                Icon(Icons.photo_camera_rounded, color: Colors.white, size: 30),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.t.marketUnePhotoEtC,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        context.t.marketLiveIaReconnaitL,
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Analyse de la photo, étape par étape, puis le résultat à valider.
class _AnalysePhoto extends StatefulWidget {
  const _AnalysePhoto();

  @override
  State<_AnalysePhoto> createState() => _AnalysePhotoState();
}

class _AnalysePhotoState extends State<_AnalysePhoto> {
  late final _etapes = [
    (
      Icons.center_focus_strong_rounded,
      context.t.marketObjetReconnu,
      'Samsung Galaxy A10',
    ),
    (Icons.category_rounded, context.t.marketCategorie, 'Téléphones · 32 Go'),
    (Icons.verified_rounded, context.t.marketEtatEstime, 'Très bon état'),
    (
      Icons.sell_rounded,
      context.t.marketPrixConseille,
      context.t.marketN28000A34,
    ),
  ];
  var _faites = 0;
  Timer? _minuteur;

  @override
  void initState() {
    super.initState();
    _minuteur = Timer.periodic(const Duration(milliseconds: 550), (t) {
      if (_faites >= _etapes.length) {
        t.cancel();
        return;
      }
      setState(() => _faites++);
    });
  }

  @override
  void dispose() {
    _minuteur?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fini = _faites >= _etapes.length;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 150,
              child: Vignette(
                couleur: Color(0xFF334155),
                icone: Icons.phone_android_rounded,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              fini
                  ? context.t.marketAnnoncePreteAVerifier
                  : context.t.marketLiveIaAnalyseLa,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            for (final (i, (icone, titre, valeur)) in _etapes.indexed)
              AnimatedOpacity(
                opacity: i < _faites ? 1 : 0.25,
                duration: const Duration(milliseconds: 300),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    i < _faites ? Icons.check_circle_rounded : icone,
                    color: i < _faites ? LiveColors.succes : LiveColors.gris,
                  ),
                  title: Text(titre),
                  trailing: Text(
                    valeur,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: fini ? () => Navigator.pop(context, true) : null,
              icon: const Icon(Icons.auto_awesome_rounded),
              label: Text(context.t.marketRemplirLAnnonce),
            ),
            const SizedBox(height: 6),
            Text(
              context.t.marketVousVerifiezToutAvant,
              textAlign: TextAlign.center,
              style: TextStyle(color: LiveColors.gris, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
