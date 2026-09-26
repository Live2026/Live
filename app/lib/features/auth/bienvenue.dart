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
    _suite = Timer(const Duration(milliseconds: 1500), () {
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
    // Comme l'ouverture de WhatsApp : fond blanc, le logo seul au centre,
    // la signature en bas. Sobre et rapide.
    final reduit = MediaQuery.disableAnimationsOf(context);
    return Scaffold(
      backgroundColor: LiveColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: reduit ? 1 : 0, end: 1),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  builder: (context, t, enfant) => Opacity(
                    opacity: t,
                    child: Transform.scale(scale: 0.9 + 0.1 * t, child: enfant),
                  ),
                  child: const LogoLive(taille: 128, nom: false),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: Column(
                children: [
                  const Text(
                    'Live',
                    style: TextStyle(
                      color: LiveColors.bleu,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.t.signature,
                    style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
    return Scaffold(
      backgroundColor: fondMotif,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const MotifLive(rayonnant: true),
          const Apparition(child: LogoMotif()),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            context.t.bienvenueTitre,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: couleurMotif,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.t.bienvenueTexte,
            textAlign: TextAlign.center,
            style: const TextStyle(color: LiveColors.gris, fontSize: 15.5),
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
              onPressed: () => context.push('/langue'),
              child: Text(context.t.commencer),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: LiveColors.surface,
              ),
              onPressed: onDecouvrir,
              child: Text(context.t.decouvrirSansCompte),
            ),
            const SizedBox(height: 6),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(context.t.dejaUnCompte),
                TextButton(
                  onPressed: () => context.push('/connexion'),
                  child: Text(context.t.seConnecter),
                ),
              ],
            ),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final (i, (nom, route)) in [
                  (context.t.conditionsUtilisation, '/legal/cgu'),
                  (context.t.confidentialite, '/legal/confidentialite'),
                  (context.t.aide, '/aide'),
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
