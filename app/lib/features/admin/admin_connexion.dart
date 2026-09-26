part of 'admin_screens.dart';

/// E-ADM-00 — Connexion d'un agent (F-ADM-01) : e-mail professionnel et mot
/// de passe, puis code de l'application d'authentification (2FA).
class EcranConnexionAdmin extends StatefulWidget {
  const EcranConnexionAdmin({super.key});

  @override
  State<EcranConnexionAdmin> createState() => _EcranConnexionAdminState();
}

class _EcranConnexionAdminState extends State<EcranConnexionAdmin> {
  var _etape = 0;
  var _confiance = false;
  var _etat = EtatCode.saisie;

  Future<void> _code(String _) async {
    setState(() => _etat = EtatCode.succes);
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (mounted) context.go('/admin');
  }

  @override
  Widget build(BuildContext context) {
    final carte = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Bloc(
        padding: 28,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: LogoLive(taille: 40)),
            const SizedBox(height: 6),
            const Text(
              'Back-office · accès réservé aux agents',
              textAlign: TextAlign.center,
              style: TextStyle(color: LiveColors.gris),
            ),
            const SizedBox(height: 24),
            if (_etape == 0) ...[
              const TextField(
                decoration: InputDecoration(
                  labelText: 'E-mail professionnel',
                  hintText: 'prenom@live.africa',
                ),
              ),
              const SizedBox(height: 12),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Mot de passe'),
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: () => setState(() => _etape = 1),
                child: const Text('Continuer'),
              ),
            ] else ...[
              const Row(
                children: [
                  Icon(Icons.phonelink_lock_rounded, color: LiveColors.bleu),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Code de votre application d’authentification',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ChampCode(onComplet: _code, etat: _etat),
              const SizedBox(height: 10),
              Material(
                type: MaterialType.transparency,
                child: CheckboxListTile(
                  value: _confiance,
                  onChanged: (v) => setState(() => _confiance = v ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Faire confiance à cet ordinateur 30 jours',
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _decider(
                  context,
                  'Code de secours : demandez-le à la direction générale.',
                ),
                child: const Text(
                  'Téléphone perdu ? Utiliser un code de secours',
                ),
              ),
            ],
            const SizedBox(height: 8),
            const Text(
              'Chaque connexion est inscrite au journal d’audit, avec '
              'l’appareil et le lieu.',
              textAlign: TextAlign.center,
              style: TextStyle(color: LiveColors.gris, fontSize: 12),
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      backgroundColor: LiveColors.champ,
      body: Row(
        children: [
          if (context.taille == Taille.etendue)
            const Expanded(
              flex: 5,
              child: FondDemarrage(
                child: Padding(
                  padding: EdgeInsets.all(56),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LogoLive(taille: 44, couleur: LiveColors.surface),
                      SizedBox(height: 24),
                      Text(
                        'Back-office',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Vérifications, modération, litiges, finance.\n'
                        'Double authentification obligatoire, permissions '
                        'par fonction, journal d’audit inaltérable.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            flex: 4,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: carte,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
