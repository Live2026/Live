part of 'compte_screens.dart';

/// Carte « Mon argent Live » de l'écran Moi : solde disponible, argent en
/// attente et accès direct au retrait. Ouvre l'écran complet (E-PAY-06).
class _CarteArgent extends StatelessWidget {
  const _CarteArgent({required this.etat});
  final LiveState etat;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      label: 'Mon argent Live : ${fcfa(etat.disponible)} disponibles',
      onTap: () => context.push('/portefeuille'),
      child: Pressable(
        onTap: () => context.push('/portefeuille'),
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 16, 12, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [Color(0xFF1D4ED8), LiveColors.nuit],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: ExcludeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mon argent Live',
                        style: TextStyle(color: LiveColors.brume),
                      ),
                      ChiffreAnime(
                        valeur: etat.disponible,
                        format: fcfa,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Text(
                        'En attente : 96 000 FCFA · reçus et historique',
                        style: TextStyle(
                          color: Color(0xFFB8C0CC),
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: LiveColors.orange,
                  foregroundColor: LiveColors.encre,
                  minimumSize: const Size(0, 44),
                ),
                onPressed: () => context.push('/retirer'),
                child: const Text('Retirer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
