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
      appBar: AppBar(title: Text(context.t.commandeNumero(v.id))),
      body: Etroit(
        largeur: 720,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              context.t.titreMontant(v.produit.titre, fcfa(v.total)),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(context.t.acheteurX(v.acheteur ?? '')),
            const SizedBox(height: 24),
            if (termine) ...[
              const CocheAnimee(taille: 72),
              Text(
                context.t.remiseConfirmeeGains(fcfa(net)),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/gains'),
                child: Text(context.t.voirMesGains),
              ),
            ] else ...[
              Text(
                context.t.auMomentDeLaRemise,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () async {
                  if (await simulerScan(context, quoi: context.t.deLAcheteur)) {
                    ref.read(liveProvider.notifier).remettreVente(v.id);
                  }
                },
                icon: const Icon(Icons.qr_code_scanner),
                label: Text(context.t.scannerLeQrDeL),
              ),
              TextButton(
                onPressed: () => _codeSecours(context, ref, v.id),
                child: Text(context.t.saisirLeCodeLvA),
              ),
              if (v.mode == ModePaiement.remise) ...[
                const Divider(height: 32),
                Text(context.t.lAcheteurPaieALa, textAlign: TextAlign.center),
                TextButton.icon(
                  onPressed: () => context.push('/vente/${v.id}/qr'),
                  icon: const Icon(Icons.qr_code_2_rounded),
                  label: Text(context.t.afficherMonQrDePaiement),
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
                context.t.vousRecevrez(fcfa(net), fcfa(v.total)),
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
        title: Text(context.t.codeDeSecours),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.t.demandezALAcheteurLe),
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
            child: Text(context.t.annuler),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(100, 44)),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(liveProvider.notifier).remettreVente(id);
            },
            child: Text(context.t.valider),
          ),
        ],
      ),
    );
  }
}
