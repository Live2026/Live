import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/adaptatif.dart';
import '../../core/theme.dart';
import '../../data/mock.dart';
import '../../data/store.dart';
import '../../shared/animations.dart';
import '../../shared/widgets.dart';

part 'bienvenue.dart';
part 'code_sms.dart';
part 'connexion_interets.dart';
part 'connexion_qr.dart';
part 'langue.dart';

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

  @override
  Widget build(BuildContext context) {
    final pays = paysTelephone[_pays];
    final valide = pays.complet(_numero.text) && _cgu && _confidentialite;
    final operateur = pays.operateur(_numero.text) ?? pays.operateurs.first;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          const EnTeteDemarrage(
            etape: 0,
            titre: 'Saisissez votre numéro',
            texte:
                'Live va vérifier votre numéro par SMS. Il sert aussi à vos '
                'paiements Mobile Money.',
          ),
          const SizedBox(height: 8),
          ChampTelephone(
            controleur: _numero,
            pays: _pays,
            onPays: (i) => setState(() => _pays = i),
            onChanged: () => setState(() {}),
          ),
          const SizedBox(height: 14),
          CheckboxListTile(
            value: _cgu,
            onChanged: (v) => setState(() => _cgu = v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: const Text("J'accepte les Conditions d'utilisation"),
            secondary: TextButton(
              style: TextButton.styleFrom(minimumSize: const Size(0, 44)),
              onPressed: () => context.push('/legal/cgu'),
              child: const Text('Lire'),
            ),
          ),
          CheckboxListTile(
            value: _confidentialite,
            onChanged: (v) => setState(() => _confidentialite = v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: const Text("J'accepte la Politique de confidentialité"),
            secondary: TextButton(
              style: TextButton.styleFrom(minimumSize: const Size(0, 44)),
              onPressed: () => context.push('/legal/confidentialite'),
              child: const Text('Lire'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: valide
              ? () async {
                  final numero = '${pays.indicatif} ${_numero.text}';
                  if (await confirmerNumero(context, numero) &&
                      context.mounted) {
                    context.push('/code', extra: (numero, operateur));
                  }
                }
              : null,
          child: const Text('Suivant'),
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
  var _photo = false;

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
            titre: 'Infos du profil',
            texte:
                'Indiquez votre nom et, si vous voulez, une photo. Votre '
                'prénom s’affiche sur vos annonces et vos messages.',
          ),
          Center(
            child: _PhotoProfil(
              nom: nomComplet,
              photo: _photo,
              onPhoto: (v) => setState(() => _photo = v),
            ),
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

/// Photo de profil, comme WhatsApp : un grand cercle au centre, un badge
/// appareil photo ; un appui propose de prendre ou de choisir une photo.
class _PhotoProfil extends StatelessWidget {
  const _PhotoProfil({
    required this.nom,
    required this.photo,
    required this.onPhoto,
  });
  final String nom;
  final bool photo;
  final ValueChanged<bool> onPhoto;

  Future<void> _choisir(BuildContext context) async {
    final choix = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Photo de profil',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            for (final (icone, titre) in [
              (Icons.photo_camera_outlined, 'Prendre une photo'),
              (Icons.photo_library_outlined, 'Choisir dans la galerie'),
              if (photo) (Icons.delete_outline_rounded, 'Retirer la photo'),
            ])
              ListTile(
                leading: Icon(icone, color: LiveColors.bleu),
                title: Text(titre),
                onTap: () => Navigator.pop(ctx, titre),
              ),
          ],
        ),
      ),
    );
    if (choix != null) onPhoto(choix != 'Retirer la photo');
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      container: true,
      label: photo
          ? 'Changer la photo de profil'
          : 'Ajouter une photo de profil',
      excludeSemantics: true,
      onTap: () => _choisir(context),
      child: GestureDetector(
        onTap: () => _choisir(context),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: photo
                  ? Avatar(
                      key: ValueKey('photo$nom'),
                      nom: nom.isEmpty ? 'Live' : nom,
                      couleur: LiveColors.orange,
                      taille: 112,
                    )
                  : Container(
                      key: const ValueKey('vide'),
                      width: 112,
                      height: 112,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE6EBF2),
                      ),
                      child: const Icon(
                        Icons.add_a_photo_outlined,
                        size: 40,
                        color: LiveColors.gris,
                      ),
                    ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: LiveColors.bleu,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(
                  Icons.photo_camera_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
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
