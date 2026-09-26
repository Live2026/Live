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

/// E-AUTH-01 — Bienvenue : fond animé, slogan qui change, espaces de Live,
/// moyens de paiement, puis Commencer, Découvrir ou Se connecter.
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
    // Sur ordinateur, la présentation est à gauche (CadreDemarrage) : la
    // carte de droite ne garde que l'essentiel.
    if (context.taille == Taille.etendue) return _bienvenueCarte(context, ref);
    return Scaffold(
      body: FondDemarrage(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, c) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: c.maxHeight - 40),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Row(
                        children: [
                          _LogoHalo(taille: 44),
                          SizedBox(width: 10),
                          Text(
                            'Live',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const SloganAnime(),
                      const SizedBox(height: 12),
                      const Text(
                        'La place de marché sociale de l’Afrique centrale : '
                        'produits, logements, services, cours et créateurs.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final (i, (icone, nom, couleur))
                              in espacesLive.indexed)
                            Apparition(
                              rang: i + 2,
                              child: PastilleEspace(
                                icone: icone,
                                nom: nom,
                                couleur: couleur,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const _Paiements(),
                      const Spacer(),
                      const SizedBox(height: 24),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: LiveColors.orange,
                          foregroundColor: LiveColors.nuit,
                          minimumSize: const Size.fromHeight(52),
                        ),
                        onPressed: () => context.push('/telephone'),
                        child: const Text(
                          'Commencer',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                          minimumSize: const Size.fromHeight(48),
                        ),
                        onPressed: () => _decouvrir(context, ref),
                        child: const Text('Découvrir sans compte'),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: LiveColors.ambreClair,
                        ),
                        onPressed: () => context.push('/connexion'),
                        child: const Text("J'ai déjà un compte"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bienvenueCarte(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, c) => SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: (c.maxHeight - 64).clamp(0, double.infinity),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bienvenue sur Live',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Créez votre compte avec votre numéro de téléphone, ou '
                  'découvrez l’application sans compte.',
                  style: TextStyle(color: LiveColors.gris, fontSize: 15),
                ),
                const SizedBox(height: 28),
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
                  ),
                  onPressed: () => _decouvrir(context, ref),
                  child: const Text('Découvrir sans compte'),
                ),
                const SizedBox(height: 18),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Déjà inscrit ?',
                        style: TextStyle(color: LiveColors.gris),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => context.push('/connexion'),
                  child: const Text("J'ai déjà un compte"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Moyens de paiement acceptés, sans nommer un seul pays.
class _Paiements extends StatelessWidget {
  const _Paiements();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x14FFFFFF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.lock_rounded, color: LiveColors.ambre),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Mobile Money, carte bancaire ou solde Live. '
              'Votre argent est protégé jusqu’à la remise.',
              style: TextStyle(color: Colors.white, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
