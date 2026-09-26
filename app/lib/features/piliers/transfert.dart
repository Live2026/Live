part of 'piliers_screens.dart';

/// E-DIA-02 — Live Transfert : envoyer de l'argent de l'étranger, dans sa
/// devise (euro, dollar, livre…), à un proche qui le reçoit en francs CFA
/// sur MTN MoMo, Airtel Money ou son solde Live ; ou, côté pays, recevoir.
/// Opéré par un établissement agréé (docs/07, §12) : Live n'émet pas de
/// monnaie. L'arrivée des fonds passe par l'API d'un partenaire de transfert
/// international, à choisir (docs/21, §4).
class EcranTransfert extends ConsumerStatefulWidget {
  const EcranTransfert({super.key, this.recevoir = false});
  final bool recevoir;

  @override
  ConsumerState<EcranTransfert> createState() => _EcranTransfertState();
}

class _EcranTransfertState extends ConsumerState<EcranTransfert> {
  late var _recevoir = widget.recevoir;
  double? _montant;
  var _proche = 0;
  var _source = 0;
  var _retrait = 0;

  static const _taux = 0.02;

  @override
  void didUpdateWidget(EcranTransfert ancien) {
    super.didUpdateWidget(ancien);
    if (ancien.recevoir != widget.recevoir) _recevoir = widget.recevoir;
  }

  late final _sources = [
    (
      context.t.piliersCarteBancaire,
      'Visa, Mastercard',
      Icons.credit_card_rounded,
    ),
    (
      context.t.piliersVirementBancaire,
      'SEPA, ACH, Interac…',
      Icons.account_balance_rounded,
    ),
    (
      context.t.piliersMobileMoneyAL,
      'Orange Money, Wave, M-Pesa…',
      Icons.phone_android_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: const Text('Live Transfert')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 24),
        children: [
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(
                value: false,
                label: Text(context.t.piliersEnvoyer),
                icon: Icon(Icons.north_east_rounded),
              ),
              ButtonSegment(
                value: true,
                label: Text(context.t.piliersRecevoir),
                icon: Icon(Icons.south_west_rounded),
              ),
            ],
            selected: {_recevoir},
            onSelectionChanged: (v) => setState(() => _recevoir = v.first),
          ),
          const SizedBox(height: 14),
          if (_recevoir) const _Recevoir() else ..._envoyer(context),
        ],
      ),
      bottomNavigationBar: _recevoir ? null : _barreEnvoi(context),
    );
  }

  Devise get _devise => deviseParCode(ref.watch(liveProvider).devise);

  double _montantDe(Devise d) => _montant ?? d.pas * 10.0;

  List<Widget> _envoyer(BuildContext context) {
    final d = _devise;
    final montant = _montantDe(d);
    final frais = montant * _taux;
    return [
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(colors: [d.couleur, LiveColors.nuit]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.t.piliersVousEnvoyez,
              style: TextStyle(color: Colors.white70),
            ),
            Row(
              children: [
                Expanded(
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      d.ecrire(montant),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _BoutonDevise(devise: d, onTap: () => _choisirDevise(context)),
              ],
            ),
            Slider(
              value: montant,
              min: d.minimum.toDouble(),
              max: d.maximum.toDouble(),
              divisions: 99,
              activeColor: LiveColors.orange,
              label: d.ecrire(montant),
              onChanged: (v) => setState(() => _montant = v),
            ),
            const Divider(color: Colors.white24),
            Text(
              context.t.piliersVotreProcheRecoit,
              style: TextStyle(color: Colors.white70),
            ),
            ChiffreAnime(
              valeur: d.versFcfa(montant),
              format: fcfa,
              style: const TextStyle(
                color: LiveColors.ambre,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.t.piliersTauxFrais(
                d.fixe
                    ? context.t.piliersTauxFixe
                    : context.t.piliersTauxDuJour,
                d.libelleTaux,
                d.ecrire(frais, decimales: true),
              ),
              style: const TextStyle(color: Colors.white70, fontSize: 12.5),
            ),
          ],
        ),
      ),
      EnTeteSection(context.t.piliersAQui),
      for (final (i, (n, l, t, _)) in proches.indexed)
        Choix(
          titre: n,
          sousTitre: '$l · $t',
          selectionne: _proche == i,
          onTap: () => setState(() => _proche = i),
          icone: Icons.person_rounded,
        ),
      EnTeteSection(context.t.piliersPayerAvec),
      for (final (i, (titre, detail, icone)) in _sources.indexed)
        Choix(
          titre: titre,
          sousTitre: detail,
          selectionne: _source == i,
          onTap: () => setState(() => _source = i),
          icone: icone,
        ),
      EnTeteSection(context.t.piliersCommentLeRecupereT),
      for (final (i, (titre, detail)) in [
        ('MTN MoMo', context.t.piliersVerseDirectementSansFrais),
        ('Airtel Money', context.t.piliersVerseDirectementSansFrais),
        (context.t.piliersSoldeLive, context.t.piliersPourPayerDansLive),
      ].indexed)
        Choix(
          titre: titre,
          sousTitre: detail,
          selectionne: _retrait == i,
          onTap: () => setState(() => _retrait = i),
          icone: Icons.account_balance_wallet_rounded,
        ),
      const SizedBox(height: 12),
      const _NoteAgrement(),
    ];
  }

  Widget _barreEnvoi(BuildContext context) {
    final d = _devise;
    final montant = _montantDe(d);
    final (nom, lieu, _, _) = proches[_proche];
    final recu = d.versFcfa(montant);
    return BarreAction(
      child: FilledButton(
        onPressed: () => _payer(
          context,
          ref,
          TypePaiement.transfert,
          d.versFcfa(montant * (1 + _taux)),
          context.t.piliersTransfertA(nom, d.ecrire(montant), fcfa(recu)),
          'tr-$_proche',
          beneficiaire: '$nom · $lieu',
        ),
        child: Text(
          context.t.piliersEnvoyerA(d.ecrire(montant), nom.split(' ').last),
        ),
      ),
    );
  }

  void _choisirDevise(BuildContext context) {
    final actuelle = ref.read(liveProvider).devise;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: LiveColors.surface,
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(ctx).height * 0.8,
          ),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Text(
                  context.t.piliersDansQuelleDeviseEnvoyez,
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                ),
              ),
              for (final d in devises)
                ListTile(
                  leading: _PastilleDevise(devise: d),
                  title: Text(
                    d.nom,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text('${d.zone}\n${d.libelleTaux}'),
                  isThreeLine: true,
                  selected: d.code == actuelle,
                  trailing: d.code == actuelle
                      ? const Icon(Icons.check_circle_rounded)
                      : null,
                  onTap: () {
                    ref.read(liveProvider.notifier).choisirDevise(d.code);
                    setState(() => _montant = null);
                    Navigator.pop(ctx);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Code de la devise, dans un rond de sa couleur.
class _PastilleDevise extends StatelessWidget {
  const _PastilleDevise({required this.devise});
  final Devise devise;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: devise.couleur,
      child: Text(
        devise.code,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11.5,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

/// Bouton « EUR ▾ » qui ouvre le choix de la devise.
class _BoutonDevise extends StatelessWidget {
  const _BoutonDevise({required this.devise, required this.onTap});
  final Devise devise;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      label: context.t.piliersDeviseChanger(devise.nom),
      onTap: onTap,
      excludeSemantics: true,
      child: Material(
        color: LiveColors.surface,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 6, 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  devise.code,
                  style: TextStyle(
                    color: devise.couleur,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Icon(Icons.expand_more_rounded, color: devise.couleur),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Cadre légal : partenaire agréé, identité, plafonds.
class _NoteAgrement extends StatelessWidget {
  const _NoteAgrement();

  @override
  Widget build(BuildContext context) {
    return Bloc(
      fond: LiveColors.voile,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.account_balance_rounded, color: LiveColors.bleu),
          SizedBox(width: 10),
          Expanded(child: Text(context.t.piliersServiceOpereParUn)),
        ],
      ),
    );
  }
}
