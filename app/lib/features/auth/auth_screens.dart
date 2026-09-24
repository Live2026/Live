import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';
import '../../data/store.dart';
import '../../shared/widgets.dart';

/// E-AUTH-01 — Bienvenue.
class EcranBienvenue extends ConsumerWidget {
  const EcranBienvenue({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Text(
                'LIVE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 10,
                  color: LiveColors.bleu,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Achetez, vendez, louez, réservez.\nPayez avec MTN MoMo, Airtel Money ou Visa.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, height: 1.4),
              ),
              const SizedBox(height: 24),
              const Vignette(
                couleur: LiveColors.bleu,
                icone: Icons.storefront,
                hauteur: 160,
                video: true,
              ),
              const SizedBox(height: 24),
              for (final t in const [
                'Vendeurs vérifiés',
                "Argent protégé jusqu'à réception",
                'Près de chez vous',
              ])
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: LiveColors.bleu),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(t, style: const TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              FilledButton(
                onPressed: () => context.push('/telephone'),
                child: const Text('Commencer'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  ref
                      .read(liveProvider.notifier)
                      .connecter(
                        prenom: 'Grâce',
                        telephone: '06 123 45 67',
                        operateur: 'MTN',
                      );
                  context.go('/accueil');
                },
                child: const Text('Découvrir sans compte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// E-AUTH-02 — Numéro de téléphone, avec consentements explicites.
class EcranTelephone extends StatefulWidget {
  const EcranTelephone({super.key});

  @override
  State<EcranTelephone> createState() => _EcranTelephoneState();
}

class _EcranTelephoneState extends State<EcranTelephone> {
  final _numero = TextEditingController();
  var _cgu = false;
  var _confidentialite = false;

  String get _operateur {
    final n = _numero.text.replaceAll(' ', '');
    if (n.startsWith('06')) return 'MTN';
    if (n.startsWith('05') || n.startsWith('04')) return 'Airtel';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final valide =
        _numero.text.replaceAll(' ', '').length >= 9 &&
        _cgu &&
        _confidentialite;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Votre numéro de téléphone',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pour vous connecter et recevoir vos paiements Mobile Money.',
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('+242', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _numero,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(hintText: '06 123 45 67'),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          if (_operateur.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Opérateur détecté : $_operateur',
                style: const TextStyle(color: LiveColors.bleu),
              ),
            ),
          const SizedBox(height: 20),
          CheckboxListTile(
            value: _cgu,
            onChanged: (v) => setState(() => _cgu = v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: const Text("J'accepte les Conditions d'utilisation"),
          ),
          CheckboxListTile(
            value: _confidentialite,
            onChanged: (v) => setState(() => _confidentialite = v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: const Text("J'accepte la Politique de confidentialité"),
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: valide
              ? () => context.push(
                  '/code',
                  extra: (
                    _numero.text,
                    _operateur.isEmpty ? 'MTN' : _operateur,
                  ),
                )
              : null,
          child: const Text('Recevoir le code par SMS'),
        ),
      ),
    );
  }
}

/// E-AUTH-03 — Code reçu par SMS (le prototype accepte n'importe quel code).
class EcranCode extends StatelessWidget {
  const EcranCode({
    super.key,
    required this.telephone,
    required this.operateur,
  });
  final String telephone;
  final String operateur;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Entrez le code reçu au\n$telephone',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Prototype : tapez 6 chiffres au choix.',
            style: TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 24),
          TextField(
            autofocus: true,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28, letterSpacing: 12),
            onChanged: (v) {
              if (v.length == 6) {
                context.push('/profil', extra: (telephone, operateur));
              }
            },
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Renvoyer le code dans 0:45'),
          ),
        ],
      ),
    );
  }
}

/// E-AUTH-04 — Profil minimal (prénom, nom, ville, âge).
class EcranProfil extends StatefulWidget {
  const EcranProfil({
    super.key,
    required this.telephone,
    required this.operateur,
  });
  final String telephone;
  final String operateur;

  @override
  State<EcranProfil> createState() => _EcranProfilState();
}

class _EcranProfilState extends State<EcranProfil> {
  final _prenom = TextEditingController();
  final _nom = TextEditingController();
  var _ville = 'Brazzaville';
  var _majeur = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Padding(padding: EdgeInsets.all(16), child: Text('1/2')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Faisons connaissance',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _prenom,
            decoration: const InputDecoration(labelText: 'Prénom'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nom,
            decoration: const InputDecoration(labelText: 'Nom'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _ville,
            decoration: const InputDecoration(labelText: 'Ville'),
            items: const [
              DropdownMenuItem(
                value: 'Brazzaville',
                child: Text('Brazzaville'),
              ),
              DropdownMenuItem(
                value: 'Pointe-Noire',
                child: Text('Pointe-Noire'),
              ),
            ],
            onChanged: (v) => setState(() => _ville = v ?? _ville),
          ),
          CheckboxListTile(
            value: _majeur,
            onChanged: (v) => setState(() => _majeur = v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: const Text("J'ai 18 ans ou plus"),
            subtitle: _majeur
                ? null
                : const Text(
                    'Compte en consultation seulement (achat et vente à partir de 18 ans).',
                  ),
          ),
          const Text(
            'Photo et quartier : plus tard, dans votre profil.',
            style: TextStyle(color: LiveColors.gris),
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: _prenom.text.trim().isEmpty
              ? null
              : () => context.push(
                  '/pin',
                  extra: (
                    _prenom.text.trim(),
                    widget.telephone,
                    widget.operateur,
                  ),
                ),
          child: const Text('Continuer'),
        ),
      ),
    );
  }
}

/// E-AUTH-06 — Code secret de l'application.
class EcranPin extends ConsumerWidget {
  const EcranPin({
    super.key,
    required this.prenom,
    required this.telephone,
    required this.operateur,
  });
  final String prenom;
  final String telephone;
  final String operateur;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Créez votre code secret',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Il protège votre compte. Ne le donnez jamais, même à un agent Live.',
          ),
          const SizedBox(height: 24),
          ClavierPin(
            onComplet: (_) {
              ref
                  .read(liveProvider.notifier)
                  .connecter(
                    prenom: prenom,
                    telephone: telephone,
                    operateur: operateur,
                  );
              context.go('/accueil');
            },
          ),
        ],
      ),
    );
  }
}
