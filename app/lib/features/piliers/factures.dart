part of 'piliers_screens.dart';

/// E-QUO-01 — Factures et crédit : électricité, eau, télévision, recharge
/// téléphonique. Payés dans Live en Mobile Money ; le reçu du fournisseur
/// reste dans l'historique. La raison d'ouvrir Live chaque jour.
class EcranFactures extends ConsumerStatefulWidget {
  const EcranFactures({super.key});

  @override
  ConsumerState<EcranFactures> createState() => _EcranFacturesState();
}

class _EcranFacturesState extends ConsumerState<EcranFactures> {
  var _operateur = 'MTN';
  var _recharge = 1000;
  final _numero = TextEditingController(text: '06 123 45 67');

  @override
  Widget build(BuildContext context) {
    final payees = ref.watch(liveProvider.select((e) => e.facturesPayees));
    final marge = context.grandEcran ? 24.0 : 16.0;
    final aPayer = factures.where((f) => !payees.contains(f.id)).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Factures et crédit')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 32),
        children: [
          _Banniere(
            icone: Icons.receipt_long_rounded,
            titre: aPayer.isEmpty
                ? 'Tout est payé'
                : '${aPayer.length} facture${aPayer.length > 1 ? 's' : ''} à payer',
            texte: aPayer.isEmpty
                ? 'Nous vous prévenons dès qu’une nouvelle facture arrive.'
                : 'Total : ${fcfa(aPayer.fold(0, (s, f) => s + f.montant))} · '
                      'sans frais, reçu du fournisseur immédiat.',
            couleurs: const [Color(0xFFCA8A04), Color(0xFFB45309)],
          ),
          const EnTeteSection('Mes factures'),
          GrilleAdaptative(
            largeurMax: 420,
            espacement: 10,
            enfants: [
              for (final (i, f) in factures.indexed)
                Apparition(
                  rang: i,
                  child: Bloc(
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: f.couleur.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(f.icone, color: f.couleur),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${f.fournisseur} · ${f.objet}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                '${f.reference} · ${f.echeance}',
                                style: const TextStyle(
                                  color: LiveColors.gris,
                                  fontSize: 12.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                fcfa(f.montant),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (payees.contains(f.id))
                          const Etiquette(
                            'Payée',
                            icone: Icons.check_rounded,
                            fond: Color(0xFFE7F4EC),
                            couleur: LiveColors.succes,
                          )
                        else
                          FilledButton(
                            style: FilledButton.styleFrom(
                              minimumSize: const Size(0, 40),
                            ),
                            onPressed: () => _payer(
                              context,
                              ref,
                              TypePaiement.facture,
                              f.montant,
                              '${f.fournisseur} · ${f.objet}',
                              f.id,
                              beneficiaire: f.fournisseur,
                            ),
                            child: const Text('Payer'),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => informer(
              context,
              'Ajout d’un compteur ou d’un abonné : numéro de référence du fournisseur.',
            ),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Ajouter un compteur ou un abonnement'),
          ),
          const EnTeteSection('Crédit et forfaits'),
          Bloc(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'MTN', label: Text('MTN')),
                    ButtonSegment(value: 'Airtel', label: Text('Airtel')),
                  ],
                  selected: {_operateur},
                  onSelectionChanged: (v) =>
                      setState(() => _operateur = v.first),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _numero,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Numéro à recharger',
                    prefixText: '+242 ',
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final m in const [500, 1000, 2000, 5000, 10000])
                      ChoiceChip(
                        label: Text(fcfa(m)),
                        selected: _recharge == m,
                        onSelected: (_) => setState(() => _recharge = m),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => _payer(
                    context,
                    ref,
                    TypePaiement.recharge,
                    _recharge,
                    'Crédit $_operateur · ${_numero.text}',
                    'recharge',
                    beneficiaire: _operateur,
                  ),
                  icon: const Icon(Icons.phone_android_rounded),
                  label: Text('Recharger ${fcfa(_recharge)}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
