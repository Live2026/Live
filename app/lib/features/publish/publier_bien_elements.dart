part of 'publish_screen.dart';

/// Tuile sélectionnable carrée (types de bien, ajout de média).
class _Tuile extends StatelessWidget {
  const _Tuile({
    required this.icone,
    required this.texte,
    required this.actif,
    required this.onTap,
  });
  final IconData icone;
  final String texte;
  final bool actif;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: actif,
      label: texte,
      excludeSemantics: true,
      child: Pressable(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: actif ? LiveColors.voile : LiveColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: actif ? LiveColors.bleu : LiveColors.filet,
              width: actif ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icone, color: LiveColors.bleu),
              const SizedBox(height: 4),
              Text(
                texte,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ligne avec boutons − et + (compteurs et montants).
class _Pas extends StatelessWidget {
  const _Pas(this.libelle, this.valeur, this.moins, this.plus);
  final String libelle;
  final String valeur;
  final VoidCallback moins;
  final VoidCallback plus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(libelle)),
          IconButton.outlined(
            tooltip: context.t.publishMoins,
            onPressed: moins,
            icon: const Icon(Icons.remove_rounded, size: 18),
          ),
          SizedBox(
            width: 104,
            child: Text(
              valeur,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          IconButton.outlined(
            tooltip: context.t.publishPlus,
            onPressed: plus,
            icon: const Icon(Icons.add_rounded, size: 18),
          ),
        ],
      ),
    );
  }
}
