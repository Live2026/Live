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

  /// Relit le numéro avec l'utilisateur, puis passe au code SMS.
  Future<void> _envoyer() async {
    final pays = paysTelephone[_pays];
    if (!pays.complet(_tel.text)) return;
    if (await confirmerNumero(
          context,
          '${pays.indicatif} ${_tel.text}',
          alerte: alerteNumero(context, pays, _tel.text),
        ) &&
        mounted) {
      setState(() => _etape = 1);
    }
  }

  Future<void> _oublie() async {
    if (await confirmer(
      context,
      titre: context.t.demarrageCodeSecretOublie,
      texte: context.t.demarrageCodeSecretOublieTexte,
      action: context.t.demarrageRecevoirCode,
    )) {
      if (mounted) informer(context, context.t.demarrageCodeEnvoyeSms);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (titre, texte) = switch (_etape) {
      0 => (context.t.demarrageBonRetour, context.t.demarrageBonRetourTexte),
      1 => (
        context.t.demarrageCodeRecuSms,
        context.t.demarrageEnvoyeAu('${paysTelephone[_pays].indicatif} ${_tel.text}'),
      ),
      _ => (context.t.demarrageVotreCodeSecret, context.t.demarrageProtegerAppareil),
    };
    return Scaffold(
      appBar: const BarreDemarrage(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: EnTeteDemarrage(
              key: ValueKey(_etape),
              titre: titre,
              texte: texte,
            ),
          ),
          if (_etape == 0) ...[
            ChampTelephone(
              controleur: _tel,
              pays: _pays,
              onPays: (i) => setState(() => _pays = i),
              onChanged: () => setState(() {}),
              onValider: _envoyer,
            ),
            // Sur ordinateur, comme WhatsApp Web : le téléphone déjà
            // connecté suffit, sans SMS.
            if (context.taille == Taille.etendue) ...[
              const SizedBox(height: 16),
              Center(
                child: TextButton.icon(
                  onPressed: () => context.go('/connexion/qr'),
                  icon: const Icon(Icons.qr_code_2_rounded),
                  label: Text(context.t.demarrageConnexionQr),
                ),
              ),
            ],
          ] else if (_etape == 1)
            ChampCode(
              lireSms: true,
              onComplet: (_) => setState(() => _etape = 2),
            )
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
                child: Text(context.t.demarrageCodeSecretOublieQ),
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: _etape == 0
          ? BarreAction(
              child: FilledButton(
                onPressed: paysTelephone[_pays].complet(_tel.text)
                    ? _envoyer
                    : null,
                child: Text(context.t.demarrageSuivant),
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
      appBar: BarreDemarrage(
        actions: [
          TextButton(onPressed: _terminer, child: Text(context.t.demarragePasser)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          EnTeteDemarrage(
            etape: 4,
            titre: context.t.demarrageInteretsTitre,
            texte: context.t.demarrageInteretsTexte,
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
          child: Text(context.t.demarrageContinuerChoisis(_choix.length)),
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
                        // Clé sans accent ni tiret pour la traduction.
                        context.t.demarrageInteret(
                          nom
                              .replaceAll('é', 'e')
                              .replaceAll('É', 'E')
                              .replaceAll('-', ''),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: choisi ? Colors.white : LiveColors.encre,
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
