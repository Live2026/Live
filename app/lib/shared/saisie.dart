import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Option sélectionnable (remplace les boutons radio).
class Choix extends StatelessWidget {
  const Choix({
    super.key,
    required this.titre,
    this.sousTitre,
    required this.selectionne,
    required this.onTap,
    this.icone,
    this.trailing,
  });
  final String titre;
  final String? sousTitre;
  final bool selectionne;
  final VoidCallback onTap;
  final IconData? icone;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selectionne ? LiveColors.fondProtection : LiveColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: selectionne ? LiveColors.bleu : Colors.grey.shade300,
            width: selectionne ? 2 : 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(
                  selectionne
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: selectionne ? LiveColors.bleu : LiveColors.gris,
                ),
                const SizedBox(width: 10),
                if (icone != null) ...[Icon(icone), const SizedBox(width: 10)],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titre,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      if (sousTitre != null)
                        Text(
                          sousTitre!,
                          style: const TextStyle(color: LiveColors.gris),
                        ),
                    ],
                  ),
                ),
                if (trailing != null) Text(trailing!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Clavier de code secret : affiche des points, jamais les chiffres.
class ClavierPin extends StatefulWidget {
  const ClavierPin({super.key, required this.onComplet, this.longueur = 4});
  final ValueChanged<String> onComplet;
  final int longueur;

  @override
  State<ClavierPin> createState() => _ClavierPinState();
}

const _effacer = 'effacer';

class _ClavierPinState extends State<ClavierPin> {
  var _saisie = '';

  void _touche(String t) {
    setState(() {
      if (t == _effacer) {
        if (_saisie.isNotEmpty) {
          _saisie = _saisie.substring(0, _saisie.length - 1);
        }
      } else if (_saisie.length < widget.longueur) {
        _saisie += t;
      }
    });
    if (_saisie.length == widget.longueur) {
      final code = _saisie;
      Future<void>.delayed(const Duration(milliseconds: 150), () {
        if (mounted) setState(() => _saisie = '');
        widget.onComplet(code);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < widget.longueur; i++)
              Container(
                margin: const EdgeInsets.all(8),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i < _saisie.length
                      ? LiveColors.bleu
                      : Colors.grey.shade300,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        for (final ligne in const [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
          ['', '0', _effacer],
        ])
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final t in ligne)
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: SizedBox(
                    width: 72,
                    height: 56,
                    child: t.isEmpty
                        ? null
                        : OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(72, 56),
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () => _touche(t),
                            child: t == _effacer
                                ? const Icon(
                                    Icons.backspace_outlined,
                                    semanticLabel: 'Effacer',
                                  )
                                : Text(t, style: const TextStyle(fontSize: 22)),
                          ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
