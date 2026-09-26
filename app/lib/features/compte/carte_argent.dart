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
      label: context.t.compteArgentDisponible(fcfa(etat.disponible)),
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
                      Text(
                        context.t.compteMonArgentLive,
                        style: TextStyle(color: LiveColors.brumeClaire),
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
                      Text(
                        context.t.compteEnAttente96000,
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
                child: Text(context.t.compteRetirer),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
