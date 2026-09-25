part of 'explore_screen.dart';

/// Tuile d'un espace : même taille pour les quatre.
class _Espace extends StatelessWidget {
  const _Espace({
    required this.icone,
    required this.titre,
    required this.sous,
    required this.couleur,
    required this.onTap,
  });
  final IconData icone;
  final String titre;
  final String sous;
  final Color couleur;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$titre, $sous',
      excludeSemantics: true,
      child: Pressable(
        onTap: onTap,
        child: Bloc(
          padding: 12,
          child: LayoutBuilder(
            builder: (context, c) {
              final pastille = Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: couleur.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icone, color: couleur),
              );
              final textes = [
                Text(
                  titre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                Text(
                  sous,
                  maxLines: c.maxWidth < 170 ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: LiveColors.gris,
                  ),
                ),
              ];
              // Tuile étroite (petit téléphone) : icône au-dessus du texte.
              if (c.maxWidth < 170) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [pastille, const Spacer(), ...textes],
                );
              }
              return Row(
                children: [
                  pastille,
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: textes,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
