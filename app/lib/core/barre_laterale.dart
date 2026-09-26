part of 'navigation.dart';

/// Barre latérale repliée ou dépliée : choix gardé d'une page à l'autre.
final barreRepliee = ValueNotifier<bool>(false);

/// Barre latérale des grands écrans (remplace NavigationRail, dont les éléments
/// n'étaient pas exposés aux lecteurs d'écran sur le web). Dépliée : logo,
/// icônes et libellés ; repliée : symbole et icônes. Le bouton du bas la plie.
class _BarreLaterale extends StatelessWidget {
  const _BarreLaterale({
    required this.etendue,
    required this.selection,
    required this.onglets,
    required this.onTap,
  });

  /// Faux sur écran moyen : la barre reste repliée.
  final bool etendue;
  final int selection;
  final List<(IconData, IconData, String)> onglets;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: barreRepliee,
      builder: (context, replie, _) {
        final large = etendue && !replie;
        return AnimatedContainer(
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          width: large ? 232 : 84,
          child: Material(
            color: LiveColors.surface,
            child: SafeArea(
              right: false,
              child: ClipRect(
                // La disposition suit la largeur réelle, même pendant
                // l'animation : jamais de débordement.
                child: LayoutBuilder(
                  builder: (context, c) =>
                      _contenu(context, c.maxWidth > 170, replie),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _contenu(BuildContext context, bool large, bool replie) {
    final bleu = Theme.of(context).colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(large ? 22 : 0, 20, 0, 24),
          child: Align(
            alignment: large ? Alignment.centerLeft : Alignment.center,
            child: LogoLive(taille: large ? 34 : 38, nom: large),
          ),
        ),
        for (final (i, (icone, active, libelle)) in onglets.indexed)
          _Entree(
            icone: i == selection ? active : icone,
            libelle: libelle,
            active: i == selection,
            large: large,
            couleur: bleu,
            onTap: () => onTap(i),
          ),
        const Spacer(),
        if (etendue)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Tooltip(
              message: replie ? 'Déplier le menu' : 'Replier le menu',
              child: Material(
                color: LiveColors.champ,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => barreRepliee.value = !replie,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedRotation(
                          turns: replie ? 0.5 : 0,
                          duration: const Duration(milliseconds: 260),
                          child: const Icon(
                            Icons.keyboard_double_arrow_left_rounded,
                            color: LiveColors.gris,
                          ),
                        ),
                        if (large) ...[
                          const SizedBox(width: 8),
                          const Text(
                            'Replier',
                            style: TextStyle(color: LiveColors.gris),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Une entrée de la barre : icône et libellé à côté (dépliée) ou dessous.
class _Entree extends StatelessWidget {
  const _Entree({
    required this.icone,
    required this.libelle,
    required this.active,
    required this.large,
    required this.couleur,
    required this.onTap,
  });
  final IconData icone;
  final String libelle;
  final bool active;
  final bool large;
  final Color couleur;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final teinte = active ? couleur : LiveColors.gris;
    final style = TextStyle(
      fontSize: large ? 15 : 12,
      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
      color: active || large
          ? (active ? couleur : const Color(0xFF041936))
          : teinte,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Material(
        color: active ? LiveColors.voile : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: large ? 14 : 0,
              vertical: large ? 12 : 10,
            ),
            child: large
                ? Row(
                    children: [
                      Icon(icone, color: teinte),
                      const SizedBox(width: 14),
                      Text(libelle, style: style),
                    ],
                  )
                : Column(
                    children: [
                      Icon(icone, color: teinte),
                      const SizedBox(height: 4),
                      Text(libelle, style: style),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
