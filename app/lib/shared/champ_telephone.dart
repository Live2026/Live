import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme.dart';
import '../data/donnees_pays.dart';
import 'drapeau.dart';

/// Saisie du numéro, comme WhatsApp : le pays sur sa ligne (drapeau, nom ;
/// la liste s'ouvre juste dessous), puis le numéro précédé de l'indicatif,
/// mis en forme pendant la frappe, avec l'opérateur reconnu dessous.
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

const _bord = Color(0xFFC5CCD6);

BoxDecoration _cadre({required bool actif}) => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(8),
  border: Border.all(
    color: actif ? LiveColors.bleu : _bord,
    width: actif ? 2 : 1,
  ),
);

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ChoixPays(
          pays: widget.pays,
          onPays: (i) {
            widget.onPays(i);
            widget.controleur.clear();
            widget.onChanged?.call();
          },
        ),
        const SizedBox(height: 12),
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: _cadre(actif: _focus.hasFocus),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 12),
                child: Text(
                  pays.indicatif,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(width: 1, height: 26, color: _bord),
              Expanded(
                // Nœud propre au champ : le lecteur d'écran ne le confond
                // pas avec la ligne du pays juste au-dessus.
                child: Semantics(
                  container: true,
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
                        vertical: 15,
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
                ? '$operateur Mobile Money reconnu'
                : '${pays.chiffres} chiffres, comme ${pays.format}',
            key: ValueKey(operateur ?? pays.code),
            textAlign: TextAlign.center,
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

/// Ligne du pays : drapeau, nom et flèche ; la liste des six pays s'ouvre
/// juste dessous, à la largeur du champ.
class _ChoixPays extends StatelessWidget {
  const _ChoixPays({required this.pays, required this.onPays});
  final int pays;
  final ValueChanged<int> onPays;

  @override
  Widget build(BuildContext context) {
    final actuel = paysTelephone[pays];
    return LayoutBuilder(
      builder: (context, c) => MenuAnchor(
        alignmentOffset: const Offset(0, 6),
        style: MenuStyle(
          backgroundColor: const WidgetStatePropertyAll(Colors.white),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          maximumSize: const WidgetStatePropertyAll(Size(480, 420)),
        ),
        menuChildren: [
          for (final (i, p) in paysTelephone.indexed)
            MenuItemButton(
              onPressed: () => onPays(i),
              leadingIcon: Drapeau(p.code, largeur: 26),
              trailingIcon: i == pays
                  ? const Icon(Icons.check_rounded, color: LiveColors.bleu)
                  : Text(
                      p.indicatif,
                      style: const TextStyle(color: LiveColors.gris),
                    ),
              child: SizedBox(
                width: (c.maxWidth - 110).clamp(160, 360),
                child: Text(
                  p.nom,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
        builder: (context, menu, _) => Semantics(
          button: true,
          container: true,
          label: 'Pays : ${actuel.nom} ${actuel.indicatif}. Changer',
          excludeSemantics: true,
          onTap: () => menu.isOpen ? menu.close() : menu.open(),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => menu.isOpen ? menu.close() : menu.open(),
            child: Ink(
              decoration: _cadre(actif: menu.isOpen),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Drapeau(actuel.code, largeur: 26),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      actuel.nom,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    menu.isOpen
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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

/// Avant d'envoyer le code, comme WhatsApp : on relit le numéro. Un SMS
/// envoyé à un numéro mal saisi est perdu (et payé).
Future<bool> confirmerNumero(BuildContext context, String numero) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Vous avez saisi le numéro :'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            numero,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          const Text('Est-il correct, ou voulez-vous le modifier ?'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Modifier'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('OK'),
        ),
      ],
    ),
  );
  return ok ?? false;
}
