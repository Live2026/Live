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
          const EnTeteDemarrage(
            etape: 0,
            icone: Icons.phone_iphone_rounded,
            couleurs: [LiveColors.ambre, LiveColors.orangeVif],
            titre: 'Votre numéro de téléphone',
            texte:
                'Il sert à vous connecter et à recevoir vos paiements '
                'Mobile Money. Il n’est jamais affiché sur votre profil.',
          ),
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

/// E-AUTH-04 — Profil minimal : prénom, nom, ville, âge. L'avatar se
/// dessine au fil de la saisie.
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

  static const _villes = [
    'Brazzaville',
    'Pointe-Noire',
    'Dolisie',
    'Libreville',
    'Douala',
    'Yaoundé',
    'Autre ville',
  ];

  @override
  Widget build(BuildContext context) {
    final nomComplet = '${_prenom.text.trim()} ${_nom.text.trim()}'.trim();
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          const EnTeteDemarrage(
            etape: 2,
            icone: Icons.badge_rounded,
            couleurs: [Color(0xFFA78BFA), Color(0xFF6D28D9)],
            titre: 'Faisons connaissance',
            texte:
                'Votre prénom s’affiche sur vos annonces et dans vos '
                'messages. Le reste peut attendre.',
          ),
          Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Avatar(
                  key: ValueKey(nomComplet.isEmpty ? '?' : nomComplet[0]),
                  nom: nomComplet.isEmpty ? '?' : nomComplet,
                  couleur: const Color(0xFF6D28D9),
                  taille: 64,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nomComplet.isEmpty ? 'Votre nom ici' : nomComplet,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '$_ville · photo plus tard',
                      style: const TextStyle(color: LiveColors.gris),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _prenom,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Prénom'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nom,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Nom'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 18),
          const Text('Ville', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final v in _villes)
                ChoiceChip(
                  label: Text(v),
                  selected: _ville == v,
                  onSelected: (_) => setState(() => _ville = v),
                ),
            ],
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            value: _majeur,
            onChanged: (v) => setState(() => _majeur = v),
            contentPadding: EdgeInsets.zero,
            title: const Text("J'ai 18 ans ou plus"),
            subtitle: Text(
              _majeur ? 'Acheter, vendre et payer dans Live.' : 'Compte en consultation seulement (achat et vente à partir de 18 ans).',
            ),
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

/// E-AUTH-06 — Code secret de l'application : saisi deux fois, avec
/// l'empreinte ou le visage en option.
class EcranPin extends ConsumerStatefulWidget {
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
  ConsumerState<EcranPin> createState() => _EcranPinState();
}

class _EcranPinState extends ConsumerState<EcranPin> {
  String? _premier;
  var _erreur = false;
  var _empreinte = true;

  void _saisi(String code) {
    if (_premier == null) {
      setState(() {
        _premier = code;
        _erreur = false;
      });
      return;
    }
    if (code != _premier) {
      setState(() {
        _premier = null;
        _erreur = true;
      });
      return;
    }
    ref
        .read(liveProvider.notifier)
        .connecter(
          prenom: widget.prenom,
          telephone: widget.telephone,
          operateur: widget.operateur,
        );
    context.go('/interets');
  }

  @override
  Widget build(BuildContext context) {
    final confirmation = _premier != null;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          EnTeteDemarrage(
            etape: 3,
            icone: confirmation
                ? Icons.verified_user_rounded
                : Icons.lock_rounded,
            couleurs: const [Color(0xFF34D399), Color(0xFF15803D)],
            titre: confirmation
                ? 'Confirmez votre code'
                : 'Bonjour ${widget.prenom}, créez votre code secret',
            texte: confirmation
                ? 'Tapez à nouveau les 4 chiffres.'
                : 'Il protège votre compte et vos paiements. Ne le donnez '
                      'jamais, même à un agent Live.',
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _erreur
                ? const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Bloc(
                      fond: Color(0xFFFDE2E2),
                      child: Text(
                        'Les deux codes sont différents. Recommencez.',
                        style: TextStyle(color: LiveColors.erreur),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          ClavierPin(key: ValueKey(confirmation), onComplet: _saisi),
          const SizedBox(height: 12),
          SwitchListTile(
            value: _empreinte,
            onChanged: (v) => setState(() => _empreinte = v),
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(
              Icons.fingerprint_rounded,
              color: LiveColors.succes,
              size: 30,
            ),
            title: const Text('Déverrouiller avec l’empreinte'),
            subtitle: const Text('Ou le visage, selon votre téléphone'),
          ),
        ],
      ),
    );
  }
}
