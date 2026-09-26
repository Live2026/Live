part of 'auth_screens.dart';

/// E-AUTH-09 — Connexion sur ordinateur par code QR, comme WhatsApp Web :
/// le téléphone déjà connecté scanne le code (Paramètres › Appareils
/// connectés). Pas de SMS à payer, pas de code à recopier. Le code change
/// toutes les 30 secondes : une photo de l'écran ne suffit pas.
class EcranConnexionQr extends ConsumerStatefulWidget {
  const EcranConnexionQr({super.key});

  @override
  ConsumerState<EcranConnexionQr> createState() => _EcranConnexionQrState();
}

class _EcranConnexionQrState extends ConsumerState<EcranConnexionQr> {
  static const _duree = 30;
  var _jeton = 1;
  var _reste = _duree;
  var _resterConnecte = true;
  Timer? _minuteur;

  @override
  void initState() {
    super.initState();
    _minuteur = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (--_reste == 0) {
          _jeton++;
          _reste = _duree;
        }
      });
    });
  }

  @override
  void dispose() {
    _minuteur?.cancel();
    super.dispose();
  }

  Future<void> _scanner() async {
    if (!await simulerScan(context, quoi: context.t.demarrageLeCodeConnexion)) return;
    ref
        .read(liveProvider.notifier)
        .connecter(
          prenom: 'Grâce',
          telephone: '06 123 45 67',
          operateur: 'MTN',
        );
    if (mounted) context.go('/accueil');
  }

  @override
  Widget build(BuildContext context) {
    final large = context.taille == Taille.etendue;
    final etapes = _Etapes(onAide: () => context.push('/aide'));
    final code = _CodeQr(jeton: _jeton, reste: _reste, onScan: _scanner);
    final resterConnecte = CheckboxListTile(
      value: _resterConnecte,
      onChanged: (v) => setState(() => _resterConnecte = v!),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      title: Text(
        context.t.demarrageResterConnecte,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
    final autreMoyen = TextButton.icon(
      onPressed: () => context.go('/connexion'),
      iconAlignment: IconAlignment.end,
      icon: const Icon(Icons.chevron_right_rounded),
      label: Text(context.t.demarrageConnexionNumero),
    );
    return Scaffold(
      backgroundColor: LiveColors.surface,
      appBar: large ? null : const BarreDemarrage(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 16),
        children: [
          Text(
            context.t.demarrageScannezConnexion,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),
          if (large)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: etapes),
                const SizedBox(width: 28),
                code,
              ],
            )
          else ...[
            Center(child: code),
            const SizedBox(height: 20),
            etapes,
          ],
          const SizedBox(height: 18),
          if (large)
            Row(
              children: [
                Expanded(child: resterConnecte),
                autreMoyen,
              ],
            )
          else ...[
            resterConnecte,
            autreMoyen,
          ],
        ],
      ),
    );
  }
}

class _Etapes extends StatelessWidget {
  const _Etapes({required this.onAide});
  final VoidCallback onAide;

  static List<String> _textes(Textes t) => [t.demarrageQrEtape1, t.demarrageQrEtape2, t.demarrageQrEtape3];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (i, t) in _textes(context.t).indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: LiveColors.bleu),
                  ),
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(t, style: const TextStyle(fontSize: 15.5)),
                ),
              ],
            ),
          ),
        TextButton.icon(
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          onPressed: onAide,
          iconAlignment: IconAlignment.end,
          icon: const Icon(Icons.north_east_rounded, size: 16),
          label: Text(context.t.demarrageBesoinAide),
        ),
      ],
    );
  }
}

class _CodeQr extends StatelessWidget {
  const _CodeQr({
    required this.jeton,
    required this.reste,
    required this.onScan,
  });
  final int jeton;
  final int reste;
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Semantics(
          label: context.t.demarrageCodeQrConnexion,
          image: true,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Stack(
              key: ValueKey(jeton),
              alignment: Alignment.center,
              children: [
                QrImageView(
                  data: 'https://live.africa/connexion/$jeton',
                  size: 200,
                  padding: const EdgeInsets.all(8),
                  backgroundColor: Colors.white,
                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: LiveColors.nuit,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: LiveColors.nuit,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  color: Colors.white,
                  child: const LogoLive(taille: 34, nom: false),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.t.demarrageNouveauCodeDans(reste),
          style: const TextStyle(color: LiveColors.gris, fontSize: 12.5),
        ),
        TextButton(onPressed: onScan, child: Text(context.t.demarrageSimulerScan)),
      ],
    );
  }
}
