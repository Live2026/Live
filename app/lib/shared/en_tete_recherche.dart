import 'package:flutter/material.dart';

import '../core/theme.dart';

/// En-tête avec une loupe : la page reste propre, et le champ de recherche
/// se déploie dans l'en-tête quand on touche la loupe (sur téléphone comme
/// sur ordinateur). La croix le referme et efface la saisie.
class EnTeteRecherche extends StatefulWidget implements PreferredSizeWidget {
  const EnTeteRecherche({
    super.key,
    required this.titre,
    this.indice = 'Rechercher',
    this.onChanged,
    this.onSubmitted,
    this.actions = const [],
    this.titleSpacing,
    this.bottom,
  });

  final Widget titre;
  final String indice;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// Actions de l'en-tête, masquées pendant la saisie pour laisser la place.
  final List<Widget> actions;
  final double? titleSpacing;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  State<EnTeteRecherche> createState() => _EnTeteRechercheState();
}

class _EnTeteRechercheState extends State<EnTeteRecherche> {
  final _saisie = TextEditingController();
  final _focus = FocusNode();
  var _ouvert = false;

  @override
  void dispose() {
    _saisie.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _basculer() {
    setState(() => _ouvert = !_ouvert);
    if (_ouvert) {
      _focus.requestFocus();
    } else {
      _saisie.clear();
      widget.onChanged?.call('');
      _focus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final duree = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 260);
    return AppBar(
      titleSpacing: widget.titleSpacing,
      bottom: widget.bottom,
      title: AnimatedSwitcher(
        duration: duree,
        switchInCurve: Curves.easeOutCubic,
        transitionBuilder: (enfant, animation) => FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axis: Axis.horizontal,
            alignment: Alignment.centerRight,
            child: enfant,
          ),
        ),
        child: _ouvert
            ? TextField(
                key: const ValueKey('champ'),
                controller: _saisie,
                focusNode: _focus,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
                decoration: InputDecoration(
                  hintText: widget.indice,
                  isDense: true,
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: LiveColors.gris,
                  ),
                ),
              )
            : Align(
                key: const ValueKey('titre'),
                alignment: Alignment.centerLeft,
                child: widget.titre,
              ),
      ),
      actions: [
        IconButton(
          tooltip: _ouvert ? 'Fermer la recherche' : 'Rechercher',
          onPressed: _basculer,
          icon: AnimatedSwitcher(
            duration: duree,
            transitionBuilder: (enfant, animation) => RotationTransition(
              turns: Tween(begin: 0.75, end: 1.0).animate(animation),
              child: FadeTransition(opacity: animation, child: enfant),
            ),
            child: Icon(
              _ouvert ? Icons.close_rounded : Icons.search_rounded,
              key: ValueKey(_ouvert),
            ),
          ),
        ),
        if (!_ouvert) ...widget.actions,
      ],
    );
  }
}
