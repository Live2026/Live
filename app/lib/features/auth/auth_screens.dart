import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptatif.dart';
import '../../core/theme.dart';
import '../../data/store.dart';
import '../../shared/animations.dart';
import '../../shared/widgets.dart';

part 'bienvenue.dart';
part 'code_sms.dart';
part 'connexion_interets.dart';

/// Pays de la zone CEMAC : indicatif, exemple de numéro, opérateurs.
const _paysCemac = [
  ('Congo', '+242', '06 123 45 67', 'MTN, Airtel'),
  ('Gabon', '+241', '077 12 34 56', 'Airtel, Moov'),
  ('Cameroun', '+237', '6 71 23 45 67', 'MTN, Orange'),
  ('Tchad', '+235', '66 12 34 56', 'Airtel, Moov'),
  ('Centrafrique', '+236', '72 12 34 56', 'Orange, Telecel'),
  ('Guinée équatoriale', '+240', '222 123 456', 'Muni, GETESA'),
];

/// E-AUTH-02 — Numéro de téléphone : pays, numéro, opérateur détecté,
/// consentements explicites.
class EcranTelephone extends StatefulWidget {
  const EcranTelephone({super.key});

  @override
  State<EcranTelephone> createState() => _EcranTelephoneState();
}

class _EcranTelephoneState extends State<EcranTelephone> {
  final _numero = TextEditingController();
  var _cgu = false;
  var _confidentialite = false;
  var _pays = 0;

  String get _operateur {
    if (_pays != 0) return '';
    final n = _numero.text.replaceAll(' ', '');
    if (n.startsWith('06')) return 'MTN';
    if (n.startsWith('05') || n.startsWith('04')) return 'Airtel';
    return '';
  }

  Future<void> _choisirPays() async {
    final choix = await choisir<int>(
      context,
      titre: 'Votre pays',
      actuel: _pays,
      options: [
        for (final (i, (nom, indicatif, _, operateurs)) in _paysCemac.indexed)
          (i, '$nom  $indicatif', operateurs),
      ],
    );
    if (choix != null) setState(() => _pays = choix);
  }

  @override
  Widget build(BuildContext context) {
    final (nom, indicatif, exemple, _) = _paysCemac[_pays];
    final valide =
        _numero.text.replaceAll(' ', '').length >= 8 &&
        _cgu &&
        _confidentialite;
    final operateur = _operateur;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Apparition(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1E0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.phone_iphone_rounded,
                  color: LiveColors.orangeVif,
                  size: 32,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Votre numéro de téléphone',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          const Text(
            'Il sert à vous connecter et à recevoir vos paiements '
            'Mobile Money. Il n’est jamais affiché sur votre profil.',
            style: TextStyle(color: LiveColors.gris, height: 1.4),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Material(
                color: const Color(0xFFF3F5F8),
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: _choisirPays,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 15,
                    ),
                    child: Row(
                      children: [
                        Text(
                          indicatif,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Icon(Icons.expand_more_rounded, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _numero,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontSize: 17, letterSpacing: 1),
                  decoration: InputDecoration(
                    hintText: exemple,
                    helperText: nom,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: operateur.isEmpty
                ? const SizedBox(height: 8)
                : Padding(
                    key: ValueKey(operateur),
                    padding: const EdgeInsets.only(top: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Etiquette(
                        '$operateur Mobile Money détecté',
                        icone: Icons.check_circle_rounded,
                        fond: operateur == 'MTN'
                            ? const Color(0xFFFFF4C2)
                            : const Color(0xFFFDE2E2),
                        couleur: operateur == 'MTN'
                            ? const Color(0xFF7A5A00)
                            : const Color(0xFFB91C1C),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 14),
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
                    '$indicatif ${_numero.text}',
                    operateur.isEmpty ? 'MTN' : operateur,
                  ),
                )
              : null,
          child: const Text('Recevoir le code'),
        ),
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
              context.go('/interets');
            },
          ),
        ],
      ),
    );
  }
}
