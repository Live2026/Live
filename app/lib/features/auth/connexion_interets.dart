part of 'auth_screens.dart';

/// E-AUTH-08 — Connexion d'un utilisateur qui revient : numéro, code SMS, code secret.
class EcranConnexion extends ConsumerStatefulWidget {
  const EcranConnexion({super.key});

  @override
  ConsumerState<EcranConnexion> createState() => _EcranConnexionState();
}

class _EcranConnexionState extends ConsumerState<EcranConnexion> {
  var _etape = 0; // 0 numéro, 1 code SMS, 2 code secret
  final _tel = TextEditingController(text: '06 123 45 67');
  var _pays = 0;

  Future<void> _oublie() async {
    if (await confirmer(
      context,
      titre: 'Code secret oublié',
      texte:
          'Nous envoyons un code par SMS à votre numéro. Vous pourrez '
          'ensuite choisir un nouveau code secret.',
      action: 'Recevoir le code',
    )) {
      if (mounted) informer(context, 'Code envoyé par SMS.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final (icone, couleurs, titre, texte) = switch (_etape) {
      0 => (
        Icons.waving_hand_rounded,
        const [LiveColors.ambre, LiveColors.orangeVif],
        'Bon retour sur Live',
        'Entrez le numéro de votre compte : nous vous envoyons un code.',
      ),
      1 => (
        Icons.sms_rounded,
        const [Color(0xFF38BDF8), Color(0xFF0369A1)],
        'Code reçu par SMS',
        'Envoyé au ${paysTelephone[_pays].indicatif} ${_tel.text}. '
            'Prototype : 6 chiffres au choix.',
      ),
      _ => (
        Icons.lock_rounded,
        const [Color(0xFF34D399), Color(0xFF15803D)],
        'Votre code secret',
        'Pour protéger votre compte sur cet appareil.',
      ),
    };
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: EnTeteDemarrage(
              key: ValueKey(_etape),
              icone: icone,
              couleurs: couleurs,
              titre: titre,
              texte: texte,
            ),
          ),
          if (_etape == 0)
            ChampTelephone(
              controleur: _tel,
              pays: _pays,
              onPays: (i) => setState(() => _pays = i),
              onChanged: () => setState(() {}),
            )
          else if (_etape == 1)
            ChampCode(onComplet: (_) => setState(() => _etape = 2))
          else ...[
            ClavierPin(
              onComplet: (_) {
                ref
                    .read(liveProvider.notifier)
                    .connecter(
                      prenom: 'Grâce',
                      telephone: _tel.text,
                      operateur:
                          paysTelephone[_pays].operateur(_tel.text) ??
                          paysTelephone[_pays].operateurs.first,
                    );
                context.go('/accueil');
              },
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: _oublie,
                child: const Text('Code secret oublié ?'),
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: _etape == 0
          ? BarreAction(
              child: FilledButton(
                onPressed: paysTelephone[_pays].complet(_tel.text)
                    ? () => setState(() => _etape = 1)
                    : null,
                child: const Text('Recevoir le code'),
              ),
            )
          : null,
    );
  }
}

/// E-AUTH-05 — Centres d'intérêt : pour un fil utile dès la première ouverture.
class EcranInterets extends ConsumerStatefulWidget {
  const EcranInterets({super.key});

  @override
  ConsumerState<EcranInterets> createState() => _EcranInteretsState();
}

class _EcranInteretsState extends ConsumerState<EcranInterets> {
  final _choix = <String>{'Téléphones', 'Mode', 'Logement'};

  /// Chaque centre d'intérêt a sa couleur.
  static const _options = [
    (Icons.smartphone_rounded, 'Téléphones', Color(0xFF0369A1)),
    (Icons.checkroom_rounded, 'Mode', Color(0xFFDB2777)),
    (Icons.home_work_rounded, 'Logement', Color(0xFF15803D)),
    (Icons.handyman_rounded, 'Artisans', Color(0xFFC2410C)),
    (Icons.restaurant_rounded, 'Cuisine', Color(0xFFB45309)),
    (Icons.spa_rounded, 'Beauté', Color(0xFFBE185D)),
    (Icons.school_rounded, 'Études', Color(0xFF6D28D9)),
    (Icons.work_rounded, 'Emploi', Color(0xFF0F766E)),
    (Icons.directions_car_rounded, 'Auto-moto', Color(0xFF334155)),
    (Icons.music_note_rounded, 'Musique', Color(0xFF7C3AED)),
    (Icons.sports_soccer_rounded, 'Football', Color(0xFF16A34A)),
    (Icons.child_friendly_rounded, 'Enfants', Color(0xFFEA580C)),
  ];

  void _terminer() {
    ref.read(liveProvider.notifier).choisirInterets(_choix);
    context.go('/accueil');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(onPressed: _terminer, child: const Text('Passer')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const EnTeteDemarrage(
            etape: 4,
            icone: Icons.interests_rounded,
            couleurs: [Color(0xFFF472B6), Color(0xFFDB2777)],
            titre: 'Qu’est-ce qui vous intéresse ?',
            texte:
                'Choisissez-en au moins 3 : votre fil sera utile dès '
                'maintenant. Vous pourrez changer plus tard.',
          ),
          GrilleAdaptative(
            largeurMax: 120,
            espacement: 10,
            hauteur: 96,
            enfants: [
              for (final (i, (icone, nom, couleur)) in _options.indexed)
                Apparition(
                  rang: i,
                  child: _TuileInteret(
                    icone: icone,
                    nom: nom,
                    couleur: couleur,
                    choisi: _choix.contains(nom),
                    onTap: () => setState(
                      () => _choix.contains(nom)
                          ? _choix.remove(nom)
                          : _choix.add(nom),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: _choix.length >= 3 ? _terminer : null,
          child: Text('Continuer · ${_choix.length} choisis'),
        ),
      ),
    );
  }
}

/// Tuile d'un centre d'intérêt : teinte claire, pleine couleur une fois
/// choisie, avec une coche qui apparaît.
class _TuileInteret extends StatelessWidget {
  const _TuileInteret({
    required this.icone,
    required this.nom,
    required this.couleur,
    required this.choisi,
    required this.onTap,
  });
  final IconData icone;
  final String nom;
  final Color couleur;
  final bool choisi;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final duree = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 220);
    return Semantics(
      button: true,
      selected: choisi,
      label: nom,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: choisi ? 1 : 0.96,
          duration: duree,
          child: AnimatedContainer(
            duration: duree,
            decoration: BoxDecoration(
              color: choisi ? couleur : couleur.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              boxShadow: choisi
                  ? [
                      BoxShadow(
                        color: couleur.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icone, color: choisi ? Colors.white : couleur),
                      const SizedBox(height: 6),
                      Text(
                        nom,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: choisi ? Colors.white : LiveColors.nuit,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: AnimatedOpacity(
                    opacity: choisi ? 1 : 0,
                    duration: duree,
                    child: const Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
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
