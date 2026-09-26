part of 'auth_screens.dart';

/// Écran d'ouverture : le logo apparaît, puis la bienvenue.
class EcranSplash extends StatefulWidget {
  const EcranSplash({super.key});

  @override
  State<EcranSplash> createState() => _EcranSplashState();
}

class _EcranSplashState extends State<EcranSplash> {
  Timer? _suite;

  @override
  void initState() {
    super.initState();
    _suite = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) context.go('/bienvenue');
    });
  }

  @override
  void dispose() {
    _suite?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduit = MediaQuery.disableAnimationsOf(context);
    return Scaffold(
      body: FondDemarrage(
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: reduit ? 1 : 0, end: 1),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutBack,
            builder: (context, t, enfant) => Opacity(
              opacity: t.clamp(0, 1),
              child: Transform.scale(scale: 0.6 + 0.4 * t, child: enfant),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LogoHalo(taille: 116),
                SizedBox(height: 18),
                Text(
                  'Live',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'La place de marché sociale',
                  style: TextStyle(color: LiveColors.ambreClair, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Logo posé sur un disque blanc lumineux.
class _LogoHalo extends StatelessWidget {
  const _LogoHalo({required this.taille});
  final double taille;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: taille,
      height: taille,
      padding: EdgeInsets.all(taille * 0.16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(taille * 0.3),
        boxShadow: const [
          BoxShadow(color: Color(0x66FB9618), blurRadius: 40, spreadRadius: 2),
        ],
      ),
      child: LogoLive(taille: taille, nom: false),
    );
  }
}

/// E-AUTH-01 — Bienvenue, sur le modèle de l'accueil de WhatsApp : le titre
/// en haut, le médaillon de Live au milieu sur le motif qui couvre toute la
/// page, les boutons centrés en bas. Même page sur téléphone et ordinateur.
class EcranBienvenue extends ConsumerWidget {
  const EcranBienvenue({super.key});

  void _decouvrir(BuildContext context, WidgetRef ref) {
    ref
        .read(liveProvider.notifier)
        .connecter(
          prenom: 'Grâce',
          telephone: '06 123 45 67',
          operateur: 'MTN',
        );
    context.go('/accueil');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grand = context.taille == Taille.etendue;
    return Scaffold(
      backgroundColor: fondMotif,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const MotifLive(rayonnant: true),
          const Apparition(child: LogoMotif()),
          if (grand)
            const Positioned(
              left: 32,
              top: 22,
              child: SafeArea(child: LogoLive(taille: 30)),
            ),
          LayoutBuilder(
            builder: (context, c) {
              final (centre, rayon) = geometrieMotif(c.biggest);
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: c.maxHeight),
                  // Haut (titre sous le cercle) et bas (boutons) écartés ;
                  // sur un écran trop court, la page défile.
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: centre.dy + rayon + 14,
                          bottom: 20,
                        ),
                        child: const Apparition(rang: 1, child: _Titre()),
                      ),
                      Apparition(
                        rang: 2,
                        child: _Actions(
                          onDecouvrir: () => _decouvrir(context, ref),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Titre sous le cercle de dessins.
class _Titre extends StatelessWidget {
  const _Titre();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            'Bienvenue sur Live',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: couleurMotif,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Achetez, vendez, louez et payez en toute confiance.',
            textAlign: TextAlign.center,
            style: TextStyle(color: LiveColors.gris, fontSize: 15.5),
          ),
        ],
      ),
    );
  }
}

/// Bas de l'accueil : les boutons centrés, puis les liens.
class _Actions extends StatelessWidget {
  const _Actions({required this.onDecouvrir});
  final VoidCallback onDecouvrir;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () => context.push('/telephone'),
              child: const Text('Commencer'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: Colors.white,
              ),
              onPressed: onDecouvrir,
              child: const Text('Découvrir sans compte'),
            ),
            const SizedBox(height: 6),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text('Déjà un compte ?'),
                TextButton(
                  onPressed: () => context.push('/connexion'),
                  child: const Text('Se connecter'),
                ),
              ],
            ),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final (i, (nom, route)) in const [
                  ('Conditions d’utilisation', '/legal/cgu'),
                  ('Confidentialité', '/legal/confidentialite'),
                  ('Aide', '/aide'),
                ].indexed) ...[
                  if (i > 0)
                    const Text('·', style: TextStyle(color: LiveColors.gris)),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: LiveColors.gris,
                      textStyle: const TextStyle(fontSize: 12.5),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 36),
                    ),
                    onPressed: () => context.push(route),
                    child: Text(nom),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
