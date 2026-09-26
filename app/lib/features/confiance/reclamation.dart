part of 'confiance_screens.dart';

/// E-CONF-04 — Suivi de la réclamation : frise, échanges, décision de Live.
class EcranReclamation extends ConsumerWidget {
  const EcranReclamation({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r =
        ref
            .watch(liveProvider)
            .reclamations
            .where((r) => r.id == id)
            .firstOrNull ??
        Reclamation(
          id: id,
          objet: 'iPhone 11 64 Go · Grâce Mode',
          motif: 'Produit différent de l’annonce',
          montant: 85000,
        );
    final decidee = r.etape >= 3;
    return Scaffold(
      appBar: AppBar(title: Text('Réclamation ${r.id}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Bloc(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.objet,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  'Motif : ${r.motif}',
                  style: const TextStyle(color: LiveColors.gris),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      decidee
                          ? Icons.check_circle_rounded
                          : Icons.lock_outline_rounded,
                      size: 18,
                      color: decidee ? LiveColors.succes : LiveColors.bleu,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        decidee
                            ? '${fcfa(r.montant)} remboursés sur votre MoMo'
                            : '${fcfa(r.montant)} bloqués par Live',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Frise(
            etapes: [
              const EtapeFrise(
                'Réclamation ouverte',
                'Aujourd’hui 11:02 · preuves reçues',
                true,
              ),
              EtapeFrise(
                'Réponse du vendeur',
                r.etape >= 2
                    ? '« Je propose de reprendre le téléphone. »'
                    : 'Il a jusqu’à demain 11:02',
                r.etape >= 2,
              ),
              EtapeFrise(
                'Décision de Live',
                decidee
                    ? 'Remboursement total accordé'
                    : 'Un médiateur examine le dossier',
                decidee,
              ),
            ],
          ),
          const EnTeteSection('Échanges'),
          const _Bulle(
            'Vous',
            'Le téléphone reçu n’est pas un iPhone 11 mais un iPhone 8.',
            true,
          ),
          if (r.etape >= 2)
            const _Bulle(
              'Grâce Mode',
              'Désolée, erreur de colis. Je reprends le téléphone et je rembourse.',
              false,
            ),
          if (decidee)
            const _Bulle(
              'Médiateur Live',
              'Décision : remboursement total. Le vendeur récupère le téléphone lors d’un rendez-vous.',
              false,
              live: true,
            ),
          const SizedBox(height: 16),
          if (!decidee)
            BoutonSimulation(
              texte: r.etape == 1
                  ? 'Simuler : le vendeur répond'
                  : 'Simuler : Live décide',
              onTap: () =>
                  ref.read(liveProvider.notifier).avancerReclamation(r.id),
            ),
          if (decidee)
            FilledButton(
              onPressed: () => context.go('/moi'),
              child: const Text('Terminer'),
            ),
        ],
      ),
    );
  }
}

class _Bulle extends StatelessWidget {
  const _Bulle(this.auteur, this.texte, this.moi, {this.live = false});
  final String auteur;
  final String texte;
  final bool moi;
  final bool live;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: moi ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: live
              ? LiveColors.voile
              : moi
              ? LiveColors.teinteVerte
              : LiveColors.champ,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              auteur,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
                color: live ? LiveColors.bleu : LiveColors.gris,
              ),
            ),
            Text(texte),
          ],
        ),
      ),
    );
  }
}
