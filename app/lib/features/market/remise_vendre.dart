part of 'market_screens.dart';

/// E-MKT-08 — Remettre la commande (vendeur).
class EcranRemise extends ConsumerWidget {
  const EcranRemise({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ventes = ref.watch(liveProvider).ventes;
    final v = ventes.firstWhere((v) => v.id == id, orElse: () => ventes.first);
    final net = v.total - commission(v.total, 0.06, minimum: 100);
    final termine = v.statut == StatutCommande.terminee;
    return Scaffold(
      appBar: AppBar(title: Text('Commande ${v.id}')),
      body: Etroit(
        largeur: 720,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              '${v.produit.titre} · ${fcfa(v.total)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Acheteur : ${v.acheteur}'),
            const SizedBox(height: 24),
            if (termine) ...[
              const CocheAnimee(taille: 72),
              Text(
                'Remise confirmée.\n${fcfa(net)} ajoutés à vos gains.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/gains'),
                child: const Text('Voir mes gains'),
              ),
            ] else ...[
              const Text(
                "Au moment de la remise, scannez le QR que l'acheteur vous montre.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () async {
                  if (await simulerScan(context, quoi: "de l'acheteur")) {
                    ref.read(liveProvider.notifier).remettreVente(v.id);
                  }
                },
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text("Scanner le QR de l'acheteur"),
              ),
              TextButton(
                onPressed: () => _codeSecours(context, ref, v.id),
                child: const Text('Saisir le code LV- à la place'),
              ),
              if (v.mode == ModePaiement.remise) ...[
                const Divider(height: 32),
                const Text(
                  "L'acheteur paie à la remise : montrez-lui votre QR de paiement.",
                  textAlign: TextAlign.center,
                ),
                TextButton.icon(
                  onPressed: () => context.push('/vente/${v.id}/qr'),
                  icon: const Icon(Icons.qr_code_2_rounded),
                  label: const Text('Afficher mon QR de paiement'),
                ),
              ],
            ],
          ],
        ),
      ),
      bottomNavigationBar: termine
          ? null
          : BarreAction(
              child: Text(
                'Vous recevrez ${fcfa(net)}\n(${fcfa(v.total)} - 6 % de commission Live)',
                textAlign: TextAlign.center,
              ),
            ),
    );
  }

  void _codeSecours(BuildContext context, WidgetRef ref, String id) {
    final ctrl = TextEditingController(text: 'LV-');
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Code de secours'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Demandez à l'acheteur le code affiché sous son QR (ex. LV-K4827).",
            ),
            const SizedBox(height: 8),
            TextField(
              controller: ctrl,
              textCapitalization: TextCapitalization.characters,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(100, 44)),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(liveProvider.notifier).remettreVente(id);
            },
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }
}
