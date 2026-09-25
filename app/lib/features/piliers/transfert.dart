part of 'piliers_screens.dart';

/// E-DIA-02 — Live Transfert : envoyer de l'argent de l'étranger à un
/// proche, crédité sur son solde Live et retiré en MTN MoMo ou Airtel Money.
/// Opéré par un établissement agréé (docs/07, §12) : Live n'émet pas de
/// monnaie.
class EcranTransfert extends ConsumerStatefulWidget {
  const EcranTransfert({super.key});

  @override
  ConsumerState<EcranTransfert> createState() => _EcranTransfertState();
}

class _EcranTransfertState extends ConsumerState<EcranTransfert> {
  var _euros = 100.0;
  var _proche = 0;
  var _retrait = 0;

  static const _taux = 0.02;

  @override
  Widget build(BuildContext context) {
    final (nom, lieu, tel, _) = proches[_proche];
    final frais = _euros * _taux;
    final recu = (_euros * tauxEuro).round();
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: const Text('Live Transfert')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [LiveColors.bleu, LiveColors.nuit],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Vous envoyez',
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  '${_euros.round()} €',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Slider(
                  value: _euros,
                  min: 10,
                  max: 1000,
                  divisions: 99,
                  activeColor: LiveColors.orange,
                  onChanged: (v) => setState(() => _euros = v),
                ),
                const Divider(color: Colors.white24),
                const Text(
                  'Votre proche reçoit',
                  style: TextStyle(color: Colors.white70),
                ),
                ChiffreAnime(
                  valeur: recu,
                  format: fcfa,
                  style: const TextStyle(
                    color: LiveColors.ambre,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Frais : ${frais.toStringAsFixed(2)} € (2 %) · taux fixe '
                  '1 € = 655,957 FCFA',
                  style: const TextStyle(color: Colors.white70, fontSize: 12.5),
                ),
              ],
            ),
          ),
          const EnTeteSection('À qui ?'),
          for (final (i, (n, l, t, _)) in proches.indexed)
            Choix(
              titre: n,
              sousTitre: '$l · $t',
              selectionne: _proche == i,
              onTap: () => setState(() => _proche = i),
              icone: Icons.person_rounded,
            ),
          const EnTeteSection('Comment le récupère-t-il ?'),
          for (final (i, (titre, detail)) in const [
            ('MTN MoMo', 'Versé directement, sans frais de retrait'),
            ('Airtel Money', 'Versé directement, sans frais de retrait'),
            ('Solde Live', 'Pour payer dans Live, retirable à tout moment'),
          ].indexed)
            Choix(
              titre: titre,
              sousTitre: detail,
              selectionne: _retrait == i,
              onTap: () => setState(() => _retrait = i),
              icone: Icons.account_balance_wallet_rounded,
            ),
          const SizedBox(height: 12),
          const Bloc(
            fond: Color(0xFFE6EBF2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.account_balance_rounded, color: LiveColors.bleu),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Service opéré par un établissement de paiement agréé. '
                    'Identité vérifiée de l’envoyeur et du bénéficiaire ; '
                    'plafonds selon la réglementation CEMAC et du pays '
                    'd’envoi.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: () => _payer(
            context,
            ref,
            TypePaiement.transfert,
            (_euros * tauxEuro * (1 + _taux)).round(),
            'Transfert à $nom · ${fcfa(recu)}',
            'tr-$_proche',
            beneficiaire: '$nom · $lieu',
          ),
          child: Text('Envoyer ${_euros.round()} € à ${nom.split(' ').last}'),
        ),
      ),
    );
  }
}
