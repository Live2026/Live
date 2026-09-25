part of 'market_screens.dart';

/// E-MKT-03 — Faire une offre de prix (panneau du bas).
Future<void> ouvrirOffre(BuildContext context, Produit p) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _FeuilleOffre(produit: p),
  );
}

class _FeuilleOffre extends StatefulWidget {
  const _FeuilleOffre({required this.produit});
  final Produit produit;

  @override
  State<_FeuilleOffre> createState() => _FeuilleOffreState();
}

class _FeuilleOffreState extends State<_FeuilleOffre> {
  late var _montant = (widget.produit.prix * 0.9).round() ~/ 1000 * 1000;

  @override
  Widget build(BuildContext context) {
    final p = widget.produit;
    final remise = ((1 - _montant / p.prix) * 100).round();
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Faire une offre',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          Text(
            '${p.titre} · prix demandé ${fcfa(p.prix)}',
            style: const TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 20),
          Center(
            child: ChiffreAnime(
              valeur: _montant,
              format: fcfa,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
            ),
          ),
          Center(
            child: Text(
              remise > 0 ? '$remise % sous le prix demandé' : 'Prix demandé',
              style: TextStyle(
                color: remise > 20 ? LiveColors.erreur : LiveColors.gris,
              ),
            ),
          ),
          Slider(
            value: _montant.toDouble(),
            min: (p.prix * 0.6).roundToDouble(),
            max: p.prix.toDouble(),
            divisions: 40,
            onChanged: (v) => setState(() => _montant = v.round() ~/ 500 * 500),
          ),
          Wrap(
            spacing: 8,
            children: [
              for (final r in const [5, 10, 15])
                ActionChip(
                  label: Text('−$r %'),
                  onPressed: () => setState(
                    () => _montant =
                        (p.prix * (100 - r) / 100).round() ~/ 500 * 500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Si le vendeur accepte, vous recevez un lien de paiement sécurisé '
            'dans la conversation. Offre valable 24 h.',
            style: TextStyle(color: LiveColors.gris, fontSize: 13),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Offre de ${fcfa(_montant)} envoyée à ${p.vendeur.nom}.',
                    ),
                  ),
                );
                context.push('/conversation');
              },
              child: Text('Envoyer mon offre · ${fcfa(_montant)}'),
            ),
          ),
        ],
      ),
    );
  }
}

/// E-MKT-09 — QR de paiement du vendeur (« payer à la remise ») : l'acheteur
/// le scanne avec son téléphone et valide avec son code MoMo ou Airtel.
class EcranQrPaiement extends ConsumerStatefulWidget {
  const EcranQrPaiement({super.key, required this.id});
  final String id;

  @override
  ConsumerState<EcranQrPaiement> createState() => _EcranQrPaiementState();
}

class _EcranQrPaiementState extends ConsumerState<EcranQrPaiement> {
  var _paye = false;

  @override
  Widget build(BuildContext context) {
    final ventes = ref.watch(liveProvider).ventes;
    final v = ventes.firstWhere(
      (x) => x.id == widget.id,
      orElse: () => ventes.first,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Encaisser à la remise')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            fcfa(v.total),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
          ),
          Text(
            '${v.produit.titre} · ${v.acheteur ?? 'Acheteur'}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _paye
                ? const Column(
                    key: ValueKey('paye'),
                    children: [
                      CocheAnimee(taille: 96),
                      Text(
                        'Paiement reçu',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Versé sur votre solde après 24 h sans réclamation.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : CarteQr(
                    key: const ValueKey('qr'),
                    titre: 'Scanner pour payer',
                    donnee: 'live://payer/${v.id}',
                    codeSecours: 'LV-P7731',
                    consigne: "L'acheteur scanne ce QR avec Live, puis valide avec son code MoMo ou Airtel.",
                  ),
          ),
          const SizedBox(height: 16),
          if (!_paye)
            BoutonSimulation(
              texte: "Simuler : l'acheteur paie",
              onTap: () => setState(() => _paye = true),
            )
          else
            FilledButton(
              onPressed: () => context.go('/mes-ventes'),
              child: const Text('Retour à mes ventes'),
            ),
        ],
      ),
    );
  }
}
