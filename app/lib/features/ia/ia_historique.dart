part of 'ia_screens.dart';

/// E-IA-01 (appui sur le solde) — Historique des Crédits Live :
/// solde, répartition des dépenses par service et mouvements.
class EcranHistoriqueCredits extends ConsumerWidget {
  const EcranHistoriqueCredits({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final etat = ref.watch(liveProvider);
    final mouvements = etat.mouvementsCredits;
    final parService = <String, int>{};
    for (final m in mouvements.where((m) => m.service != null)) {
      parService[m.service!] = (parService[m.service!] ?? 0) - m.n;
    }
    final depense = parService.values.fold(0, (a, b) => a + b);
    final tri = parService.entries.toList()..sort((a, b) => b.value - a.value);
    return Scaffold(
      appBar: AppBar(title: const Text('Mes crédits')),
      body: DeuxColonnes(
        principale: [
          Bloc(
            fond: LiveColors.fondProtection,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Solde disponible'),
                      Credits(etat.credits, taille: 30),
                      Text(
                        '$depense crédits utilisés',
                        style: const TextStyle(color: LiveColors.gris),
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
                  onPressed: () => context.push('/ia/credits'),
                  child: const Text('Recharger'),
                ),
              ],
            ),
          ),
          const EnTeteSection('Où vont mes crédits'),
          if (tri.isEmpty)
            const Text(
              'Aucune dépense pour le moment. Chaque service affiche son prix '
              'avant d’être utilisé.',
              style: TextStyle(color: LiveColors.gris),
            )
          else
            for (final e in tri) _BarreService(e.key, e.value, depense),
          const EnTeteSection('Mouvements'),
          for (final m in mouvements)
            LigneMenu(
              icone: m.n < 0
                  ? Icons.auto_awesome_outlined
                  : Icons.add_circle_outline,
              couleur: m.n < 0 ? LiveColors.bleu : LiveColors.succes,
              titre: m.libelle,
              detail: m.quand,
              trailing: Text(
                '${m.n > 0 ? '+' : '−'}${m.n.abs()}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: m.n < 0 ? LiveColors.nuit : LiveColors.succes,
                ),
              ),
            ),
        ],
        secondaire: const [
          Bloc(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Comment sont comptés les crédits',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  '• Prix fixe par service, affiché et confirmé avant.\n'
                  '• Une révision gratuite par document.\n'
                  '• Recrédit automatique si la génération échoue.\n'
                  '• Les crédits qui expirent le plus tôt partent en premier.',
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Bloc(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lock_outline, color: LiveColors.bleu),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Vos documents et photos sont privés, supprimables à tout '
                    'moment et jamais utilisés pour entraîner une IA.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Part d'un service dans les dépenses du mois.
class _BarreService extends StatelessWidget {
  const _BarreService(this.service, this.n, this.total);
  final String service;
  final int n;
  final int total;

  @override
  Widget build(BuildContext context) {
    final part = total == 0 ? 0.0 : n / total;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(service)),
              Text('$n crédits · ${(part * 100).round()} %'),
            ],
          ),
          const SizedBox(height: 4),
          TweenAnimationBuilder<double>(
            tween: Tween(end: part),
            duration: const Duration(milliseconds: 600),
            curve: courbeDouce,
            builder: (_, v, _) => LinearProgressIndicator(
              value: v,
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
              backgroundColor: LiveColors.brume,
              color: LiveColors.bleu,
            ),
          ),
        ],
      ),
    );
  }
}
