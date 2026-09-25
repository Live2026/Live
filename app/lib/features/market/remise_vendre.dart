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
      body: ListView(
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

/// E-PUB-03 — Vendre un produit (formulaire unique).
class EcranVendre extends ConsumerStatefulWidget {
  const EcranVendre({super.key});

  @override
  ConsumerState<EcranVendre> createState() => _EcranVendreState();
}

class _EcranVendreState extends ConsumerState<EcranVendre> {
  final _titre = TextEditingController();
  final _prix = TextEditingController();
  final _description = TextEditingController();
  var _photos = 0;
  var _etat = 'Très bon état';

  @override
  Widget build(BuildContext context) {
    final prix = int.tryParse(_prix.text.replaceAll(' ', '')) ?? 0;
    final valide = _titre.text.trim().isNotEmpty && prix > 0 && _photos > 0;
    return Scaffold(
      appBar: AppBar(title: const Text('Vendre un produit')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              for (var i = 0; i < _photos; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Vignette(
                    couleur: Colors.primaries[i * 3 % 18],
                    icone: Icons.image,
                    hauteur: 64,
                    largeur: 64,
                    rayon: 8,
                  ),
                ),
              Semantics(
                button: true,
                label: 'Ajouter une photo',
                child: InkWell(
                  onTap: () => setState(() => _photos++),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      border: Border.all(color: LiveColors.bleu, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.add_a_photo,
                      color: LiveColors.bleu,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 6, bottom: 4),
            child: Text(
              'Prototype : chaque appui ajoute une photo fictive.',
              style: TextStyle(color: LiveColors.gris, fontSize: 12),
            ),
          ),
          // F-IA-08 — Rédiger mon annonce : gratuit, 3 fois par jour.
          if (_photos > 0)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => setState(() {
                  if (_titre.text.trim().isEmpty) {
                    _titre.text = 'Samsung Galaxy A10 32 Go';
                  }
                  _description.text =
                      'Téléphone en très bon état, écran sans rayure, batterie '
                      'qui tient la journée. Vendu avec chargeur. Remise en '
                      'main propre à Moungali ou livraison.';
                  _etat = 'Très bon état';
                }),
                icon: const Icon(Icons.auto_awesome, color: LiveColors.orange),
                label: const Text('Rédiger avec Live IA · gratuit'),
              ),
            ),
          const SizedBox(height: 8),
          TextField(
            controller: _titre,
            decoration: const InputDecoration(
              labelText: 'Titre',
              hintText: 'Ex. iPhone 11 64 Go',
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _prix,
            decoration: const InputDecoration(
              labelText: 'Prix',
              suffixText: 'FCFA',
            ),
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              for (final e in const [
                'Neuf',
                'Très bon état',
                'Bon état',
                'À réparer',
              ])
                ChoiceChip(
                  label: Text(e),
                  selected: _etat == e,
                  onSelected: (_) => setState(() => _etat = e),
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _description,
            decoration: const InputDecoration(
              labelText: 'Description (facultatif)',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          if (prix > 0)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: LiveColors.fondProtection,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Vous recevrez ${fcfa(prix)} par vente pendant votre offre de lancement (0 % de commission), '
                'puis ${fcfa(prix - commission(prix, 0.06, minimum: 100))} (6 % de commission Live).',
              ),
            ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: valide
              ? () {
                  ref
                      .read(liveProvider.notifier)
                      .publier(_titre.text.trim(), prix);
                  showDialog<void>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Annonce publiée'),
                      content: const Text(
                        'Votre annonce est en ligne.\n\nPour le test : une acheteuse (Merveille) vient de la commander et de payer.',
                      ),
                      actions: [
                        FilledButton(
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(160, 44),
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            context.go('/mes-ventes');
                          },
                          child: const Text('Voir mes ventes'),
                        ),
                      ],
                    ),
                  );
                }
              : null,
          child: const Text('Publier'),
        ),
      ),
    );
  }
}
