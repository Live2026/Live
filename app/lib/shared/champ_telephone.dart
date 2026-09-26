import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme.dart';
import '../data/donnees_pays.dart';
import 'drapeau.dart';

/// Champ du numéro de téléphone, façon WhatsApp : drapeau et indicatif à
/// gauche (liste des pays qui s'ouvre sous le champ, pas en bas de l'écran),
/// numéro mis en forme pendant la saisie, opérateur reconnu dessous.
class ChampTelephone extends StatefulWidget {
  const ChampTelephone({
    super.key,
    required this.controleur,
    required this.pays,
    required this.onPays,
    this.onChanged,
    this.autofocus = false,
  });

  final TextEditingController controleur;

  /// Rang dans `paysTelephone`.
  final int pays;
  final ValueChanged<int> onPays;
  final VoidCallback? onChanged;
  final bool autofocus;

  @override
  State<ChampTelephone> createState() => _ChampTelephoneState();
}

class _ChampTelephoneState extends State<ChampTelephone> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pays = paysTelephone[widget.pays];
    final numero = widget.controleur.text;
    final operateur = pays.operateur(numero);
    final complet = pays.complet(numero);
    final actif = _focus.hasFocus;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: actif ? LiveColors.bleu : const Color(0xFFD7DCE4),
              width: actif ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              MenuAnchor(
                alignmentOffset: const Offset(0, 6),
                style: MenuStyle(
                  backgroundColor: const WidgetStatePropertyAll(Colors.white),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maximumSize: const WidgetStatePropertyAll(Size(360, 420)),
                ),
                menuChildren: [
                  for (final (i, p) in paysTelephone.indexed)
                    MenuItemButton(
                      onPressed: () {
                        widget.onPays(i);
                        widget.controleur.clear();
                        widget.onChanged?.call();
                      },
                      leadingIcon: Drapeau(p.code, largeur: 26),
                      trailingIcon: i == widget.pays
                          ? const Icon(
                              Icons.check_rounded,
                              color: LiveColors.bleu,
                            )
                          : null,
                      child: SizedBox(
                        width: 240,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    p.nom,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    p.operateurs.join(', '),
                                    style: const TextStyle(
                                      color: LiveColors.gris,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              p.indicatif,
                              style: const TextStyle(
                                color: LiveColors.gris,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
                builder: (context, menu, _) => Semantics(
                  button: true,
                  container: true,
                  label: 'Pays : ${pays.nom} ${pays.indicatif}. Changer',
                  excludeSemantics: true,
                  onTap: () => menu.isOpen ? menu.close() : menu.open(),
                  child: InkWell(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(8),
                    ),
                    onTap: () => menu.isOpen ? menu.close() : menu.open(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 14, 6, 14),
                      child: Row(
                        children: [
                          Drapeau(pays.code),
                          const SizedBox(width: 8),
                          Text(
                            pays.indicatif,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down_rounded),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(width: 1, height: 28, color: const Color(0xFFD7DCE4)),
              Expanded(
                child: Semantics(
                  label: 'Numéro de téléphone',
                  child: TextField(
                    controller: widget.controleur,
                    focusNode: _focus,
                    autofocus: widget.autofocus,
                    keyboardType: TextInputType.phone,
                    autofillHints: const [
                      AutofillHints.telephoneNumberNational,
                    ],
                    inputFormatters: [_FormatNumero(pays.groupes)],
                    style: const TextStyle(
                      fontSize: 17,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: pays.format,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      suffixIcon: complet
                          ? const Icon(
                              Icons.check_circle_rounded,
                              color: LiveColors.succes,
                              semanticLabel: 'Numéro complet',
                            )
                          : null,
                    ),
                    onChanged: (_) {
                      setState(() {});
                      widget.onChanged?.call();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: Text(
            operateur != null
                ? '$operateur Mobile Money reconnu · ${pays.nom}'
                : '${pays.nom} · ${pays.chiffres} chiffres, comme ${pays.format}',
            key: ValueKey(operateur ?? pays.code),
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: operateur != null ? FontWeight.w700 : null,
              color: operateur != null ? LiveColors.succes : LiveColors.gris,
            ),
          ),
        ),
      ],
    );
  }
}

/// Garde les chiffres et les groupe comme le format du pays.
class _FormatNumero extends TextInputFormatter {
  _FormatNumero(this.groupes);
  final List<int> groupes;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue ancien,
    TextEditingValue nouveau,
  ) {
    final max = groupes.fold(0, (s, n) => s + n);
    var chiffres = nouveau.text.replaceAll(RegExp(r'\D'), '');
    if (chiffres.length > max) chiffres = chiffres.substring(0, max);
    final b = StringBuffer();
    var i = 0;
    for (final g in groupes) {
      if (i >= chiffres.length) break;
      if (b.isNotEmpty) b.write(' ');
      final fin = (i + g).clamp(0, chiffres.length);
      b.write(chiffres.substring(i, fin));
      i = fin;
    }
    final texte = b.toString();
    return TextEditingValue(
      text: texte,
      selection: TextSelection.collapsed(offset: texte.length),
    );
  }
}
