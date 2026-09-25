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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(switch (_etape) {
            0 => 'Bon retour sur Live',
            1 => 'Code reçu par SMS',
            _ => 'Votre code secret',
          }, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(switch (_etape) {
            0 => 'Entrez le numéro de votre compte.',
            1 => 'Envoyé au ${_tel.text}. Prototype : 6 chiffres au choix.',
            _ => 'Pour protéger votre compte sur ce nouvel appareil.',
          }, style: const TextStyle(color: LiveColors.gris)),
          const SizedBox(height: 24),
          if (_etape == 0)
            TextField(
              controller: _tel,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                prefixText: '+242 ',
                labelText: 'Numéro de téléphone',
              ),
            )
          else if (_etape == 1)
            TextField(
              autofocus: true,
              maxLength: 6,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 26, letterSpacing: 10),
              decoration: const InputDecoration(counterText: ''),
              onChanged: (v) {
                if (v.length == 6) setState(() => _etape = 2);
              },
            )
          else
            ClavierPin(
              onComplet: (_) {
                ref
                    .read(liveProvider.notifier)
                    .connecter(
                      prenom: 'Grâce',
                      telephone: _tel.text,
                      operateur: 'MTN',
                    );
                context.go('/accueil');
              },
            ),
          if (_etape == 2) ...[
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text('Code secret oublié ?'),
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: _etape == 0
          ? BarreAction(
              child: FilledButton(
                onPressed: () => setState(() => _etape = 1),
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

  static const _options = [
    (Icons.smartphone_rounded, 'Téléphones'),
    (Icons.checkroom_rounded, 'Mode'),
    (Icons.home_work_rounded, 'Logement'),
    (Icons.handyman_rounded, 'Artisans'),
    (Icons.restaurant_rounded, 'Cuisine'),
    (Icons.spa_rounded, 'Beauté'),
    (Icons.school_rounded, 'Études'),
    (Icons.work_rounded, 'Emploi'),
    (Icons.directions_car_rounded, 'Auto-moto'),
    (Icons.music_note_rounded, 'Musique'),
    (Icons.sports_soccer_rounded, 'Football'),
    (Icons.child_friendly_rounded, 'Enfants'),
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
          const Text(
            'Qu’est-ce qui vous intéresse ?',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text(
            'Choisissez-en au moins 3 : votre fil sera utile dès maintenant.',
            style: TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 20),
          GrilleAdaptative(
            largeurMax: 120,
            espacement: 10,
            hauteur: 92,
            enfants: [
              for (final (icone, nom) in _options)
                Semantics(
                  button: true,
                  selected: _choix.contains(nom),
                  label: nom,
                  excludeSemantics: true,
                  child: GestureDetector(
                    onTap: () => setState(
                      () => _choix.contains(nom)
                          ? _choix.remove(nom)
                          : _choix.add(nom),
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: _choix.contains(nom)
                            ? LiveColors.bleu
                            : const Color(0xFFF3F5F8),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icone,
                            color: _choix.contains(nom)
                                ? Colors.white
                                : LiveColors.bleu,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            nom,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _choix.contains(nom)
                                  ? Colors.white
                                  : LiveColors.nuit,
                            ),
                          ),
                        ],
                      ),
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
