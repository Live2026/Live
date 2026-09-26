import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_auth/smart_auth.dart';

import '../core/theme.dart';
import '../l10n/textes.dart';

/// Saisie d'un code à usage unique : une case par chiffre, la case active
/// s'allume, chaque chiffre apparaît avec un léger rebond. Le code complet
/// est rendu à [onComplet]. [etat] colore les cases (succès en vert,
/// erreur en rouge avec un tremblement).
class ChampCode extends StatefulWidget {
  const ChampCode({
    super.key,
    this.longueur = 6,
    required this.onComplet,
    this.etat = EtatCode.saisie,
    this.masque = false,
    this.lireSms = false,
  });
  final int longueur;
  final ValueChanged<String> onComplet;
  final EtatCode etat;

  /// Vrai pour un code secret : des points au lieu des chiffres.
  final bool masque;

  /// Code reçu par SMS : sur Android, Live propose de le lire (API « SMS
  /// User Consent » de Google, l'utilisateur accepte en un appui). Sur
  /// iPhone et dans le navigateur, le clavier le propose seul
  /// (`AutofillHints.oneTimeCode`).
  final bool lireSms;

  @override
  State<ChampCode> createState() => _ChampCodeState();
}

enum EtatCode { saisie, succes, erreur }

class _ChampCodeState extends State<ChampCode>
    with SingleTickerProviderStateMixin {
  final _saisie = TextEditingController();
  final _focus = FocusNode();
  late final _tremblement = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  @override
  void initState() {
    super.initState();
    if (widget.lireSms &&
        !kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android) {
      _ecouterSms();
    }
  }

  Future<void> _ecouterSms() async {
    final res = await SmartAuth.instance.getSmsWithUserConsentApi();
    final code = res.data?.code;
    if (!mounted || code == null || code.length != widget.longueur) return;
    setState(() => _saisie.text = code);
    widget.onComplet(code);
  }

  @override
  void didUpdateWidget(ChampCode ancien) {
    super.didUpdateWidget(ancien);
    if (widget.etat == EtatCode.erreur && ancien.etat != EtatCode.erreur) {
      _tremblement.forward(from: 0);
      _saisie.clear();
    }
  }

  @override
  void dispose() {
    if (widget.lireSms &&
        !kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android) {
      SmartAuth.instance.removeUserConsentApiListener();
    }
    _saisie.dispose();
    _focus.dispose();
    _tremblement.dispose();
    super.dispose();
  }

  Color get _accent => switch (widget.etat) {
    EtatCode.succes => LiveColors.succes,
    EtatCode.erreur => LiveColors.erreur,
    EtatCode.saisie => LiveColors.orange,
  };

  @override
  Widget build(BuildContext context) {
    final reduit = MediaQuery.disableAnimationsOf(context);
    final code = _saisie.text;
    return GestureDetector(
      onTap: () => _focus.requestFocus(),
      child: AnimatedBuilder(
        animation: _tremblement,
        builder: (context, enfant) => Transform.translate(
          offset: Offset(
            math.sin(_tremblement.value * math.pi * 6) *
                10 *
                (1 - _tremblement.value),
            0,
          ),
          child: enfant,
        ),
        child: Stack(
          children: [
            // Champ réel, invisible : clavier, collage et remplissage
            // automatique du code reçu par SMS.
            Positioned.fill(
              child: Opacity(
                opacity: 0,
                alwaysIncludeSemantics: true,
                child: TextField(
                  controller: _saisie,
                  focusNode: _focus,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(widget.longueur),
                  ],
                  showCursor: false,
                  decoration: InputDecoration(
                    labelText: context.t.codeAChiffres(widget.longueur),
                  ),
                  enableInteractiveSelection: false,
                  onChanged: (v) {
                    setState(() {});
                    if (v.length == widget.longueur) widget.onComplet(v);
                  },
                ),
              ),
            ),
            IgnorePointer(
              child: LayoutBuilder(
                builder: (context, c) {
                  const ecart = 8.0;
                  final taille = math.min(
                    56.0,
                    (c.maxWidth - ecart * (widget.longueur - 1)) /
                        widget.longueur,
                  );
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < widget.longueur; i++) ...[
                        if (i > 0) const SizedBox(width: ecart),
                        _Case(
                          taille: taille,
                          chiffre: i < code.length ? code[i] : null,
                          active:
                              _focus.hasFocus &&
                              i == code.length &&
                              widget.etat == EtatCode.saisie,
                          accent: _accent,
                          etat: widget.etat,
                          masque: widget.masque,
                          reduit: reduit,
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Case extends StatelessWidget {
  const _Case({
    required this.taille,
    required this.chiffre,
    required this.active,
    required this.accent,
    required this.etat,
    required this.masque,
    required this.reduit,
  });
  final double taille;
  final String? chiffre;
  final bool active;
  final Color accent;
  final EtatCode etat;
  final bool masque;
  final bool reduit;

  @override
  Widget build(BuildContext context) {
    final rempli = chiffre != null;
    final colore = etat != EtatCode.saisie;
    return AnimatedContainer(
      duration: reduit ? Duration.zero : const Duration(milliseconds: 200),
      width: taille,
      height: taille * 1.18,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colore
            ? accent.withValues(alpha: 0.1)
            : rempli
            ? LiveColors.teinteAmbre
            : LiveColors.champ,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: active || colore
              ? accent
              : rempli
              ? const Color(0xFFFBCC6A)
              : LiveColors.brume,
          width: active || colore ? 2 : 1.2,
        ),
        boxShadow: active
            ? [BoxShadow(color: accent.withValues(alpha: 0.25), blurRadius: 10)]
            : null,
      ),
      child: AnimatedScale(
        scale: rempli ? 1 : 0.4,
        duration: reduit ? Duration.zero : const Duration(milliseconds: 220),
        curve: Curves.easeOutBack,
        child: Text(
          rempli ? (masque ? '•' : chiffre!) : '',
          style: TextStyle(
            fontSize: taille * 0.5,
            fontWeight: FontWeight.w800,
            color: colore ? accent : LiveColors.encre,
          ),
        ),
      ),
    );
  }
}
