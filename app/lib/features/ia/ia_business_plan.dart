part of 'ia_screens.dart';

/// E-IA-05 — Génération en cours : étapes cochées au fil de l'avancement.
class EtapesGeneration extends StatelessWidget {
  const EtapesGeneration({super.key, required this.progression});
  final double progression;

  static List<String> _etapes(Textes t) => [
    t.iaLectureDeVosInformations,
    t.iaRedactionDuContenu,
    t.iaCalculsEtMiseEn,
    t.iaRelectureFinale,
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 96,
                height: 96,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progression,
                      strokeWidth: 6,
                      backgroundColor: LiveColors.voile,
                      constraints: const BoxConstraints.expand(),
                    ),
                    const Icon(
                      Icons.auto_awesome,
                      color: LiveColors.orange,
                      size: 40,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${(progression * 100).round()} %',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              for (final (i, e) in _etapes(context.t).indexed)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child:
                            progression >
                                (i + 1) / _etapes(context.t).length - 0.01
                            ? const Icon(
                                Icons.check_circle_rounded,
                                key: ValueKey(1),
                                color: LiveColors.succes,
                              )
                            : progression > i / _etapes(context.t).length
                            ? const SizedBox(
                                key: ValueKey(2),
                                width: 24,
                                height: 24,
                                child: Padding(
                                  padding: EdgeInsets.all(3),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.radio_button_unchecked,
                                key: ValueKey(3),
                                color: LiveColors.brumeClaire,
                              ),
                      ),
                      const SizedBox(width: 12),
                      Text(e),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                context.t.iaVousPouvezQuitterL,
                textAlign: TextAlign.center,
                style: TextStyle(color: LiveColors.gris),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// E-IA-09 — Business plan : assistant en 6 étapes avec prévisionnel.
class EcranBusinessPlan extends ConsumerStatefulWidget {
  const EcranBusinessPlan({super.key});

  @override
  ConsumerState<EcranBusinessPlan> createState() => _EcranBusinessPlanState();
}

class _EcranBusinessPlanState extends ConsumerState<EcranBusinessPlan> {
  var _etape = 0;
  var _progression = 0.0;
  var _enCours = false;
  final _c = {
    'activite': TextEditingController(text: 'Boulangerie de quartier'),
    'quartier': TextEditingController(text: 'Moungali, Brazzaville'),
    'clients': TextEditingController(
      text: 'Familles et petits commerces du quartier',
    ),
    'concurrents': TextEditingController(
      text: 'Deux boulangeries à 1 km, pain souvent en rupture le soir',
    ),
  };
  var _prix = 2500;
  var _ventes = 300;
  var _apport = 1500000;
  var _pret = 3000000;

  late final _titres = [
    context.t.iaLeProjet,
    context.t.iaLesClients,
    context.t.iaLaConcurrence,
    context.t.iaLesVentes,
    context.t.iaLeFinancement,
    context.t.iaRecapitulatif,
  ];

  int get _caMensuel => _prix * _ventes;

  Future<void> _generer() async {
    final s = serviceParId(context.t, 'bp_complet');
    if (!await confirmerPrix(context, ref, s.titre, s.prix)) return;
    setState(() => _enCours = true);
    for (var i = 1; i <= 12; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      setState(() => _progression = i / 12);
    }
    final a = _c['activite']!.text;
    final id = ref.read(liveProvider.notifier).ajouterDocument(
      'bp_complet',
      'Business plan · $a',
      [
        (
          'Résumé',
          '$a à ${_c['quartier']!.text}. Besoin total ${fcfa(_apport + _pret)}, dont ${fcfa(_apport)} d’apport.',
        ),
        ('Marché et clients', _c['clients']!.text),
        (
          'Concurrence et avantage',
          '${_c['concurrents']!.text}. Avantage : pain chaud matin et soir, livraison via Live.',
        ),
        (
          'Prévisionnel',
          'Chiffre d’affaires : ${fcfa(_caMensuel * 12)} en année 1, ${fcfa((_caMensuel * 12 * 1.15).round())} en année 2, ${fcfa((_caMensuel * 12 * 1.3).round())} en année 3.',
        ),
        (
          'Financement',
          'Apport ${fcfa(_apport)} et prêt ${fcfa(_pret)} remboursé sur 36 mois.',
        ),
        (
          'Avertissement',
          'Chiffres indicatifs à vérifier avec un comptable avant tout dépôt en banque.',
        ),
      ],
    );
    if (mounted) context.pushReplacement('/ia/document/$id');
  }

  @override
  Widget build(BuildContext context) {
    if (_enCours) {
      return Scaffold(
        appBar: AppBar(title: Text(context.t.iaBusinessPlanComplet)),
        body: EtapesGeneration(progression: _progression),
      );
    }
    final credits = ref.watch(liveProvider.select((e) => e.credits));
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.iaBusinessPlanEtape(_etape + 1)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Credits(credits),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          LinearProgressIndicator(
            value: (_etape + 1) / 6,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 16),
          Text(
            _titres[_etape],
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          ...switch (_etape) {
            0 => [
              TextField(
                controller: _c['activite'],
                decoration: InputDecoration(
                  labelText: context.t.iaVotreActivite,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _c['quartier'],
                decoration: InputDecoration(
                  labelText: context.t.iaVilleEtQuartier,
                ),
              ),
            ],
            1 => [
              TextField(
                controller: _c['clients'],
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: context.t.iaQuiSontVosClients,
                ),
              ),
            ],
            2 => [
              TextField(
                controller: _c['concurrents'],
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: context.t.iaQuiSontVosConcurrents,
                ),
              ),
            ],
            3 => [
              _Curseur(
                context.t.iaPrixMoyenDUne2,
                _prix,
                500,
                20000,
                500,
                (v) => setState(() => _prix = v),
              ),
              _Curseur(
                context.t.iaVentesParMois,
                _ventes,
                50,
                2000,
                50,
                (v) => setState(() => _ventes = v),
                monnaie: false,
              ),
              Bloc(
                fond: LiveColors.champ,
                child: LigneMontant(
                  context.t.iaChiffreDAffairesMensuel,
                  _caMensuel,
                  gras: true,
                ),
              ),
            ],
            4 => [
              _Curseur(
                context.t.iaVotreApport,
                _apport,
                0,
                10000000,
                250000,
                (v) => setState(() => _apport = v),
              ),
              _Curseur(
                context.t.iaPretRecherche,
                _pret,
                0,
                20000000,
                250000,
                (v) => setState(() => _pret = v),
              ),
            ],
            _ => [
              _Previsionnel(caAnnuel: _caMensuel * 12),
              const SizedBox(height: 12),
              LigneMontant(
                context.t.iaBesoinTotal,
                _apport + _pret,
                gras: true,
              ),
            ],
          },
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: Row(
          children: [
            if (_etape > 0) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _etape--),
                  child: Text(context.t.retour),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: _etape < 5
                    ? () => setState(() => _etape++)
                    : _generer,
                child: Text(
                  _etape < 5
                      ? context.t.continuer
                      : context.t.iaGenererCredits(150),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Curseur extends StatelessWidget {
  const _Curseur(
    this.libelle,
    this.valeur,
    this.min,
    this.max,
    this.pas,
    this.onChange, {
    this.monnaie = true,
  });
  final String libelle;
  final int valeur;
  final int min;
  final int max;
  final int pas;
  final ValueChanged<int> onChange;
  final bool monnaie;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(libelle)),
            Text(
              monnaie ? fcfa(valeur) : '$valeur',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        Slider(
          value: valeur.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: (max - min) ~/ pas,
          onChanged: (v) => onChange(v.round()),
        ),
      ],
    );
  }
}

/// Prévisionnel sur 3 ans en barres (croissance prudente de 15 % par an).
class _Previsionnel extends StatelessWidget {
  const _Previsionnel({required this.caAnnuel});
  final int caAnnuel;

  @override
  Widget build(BuildContext context) {
    final annees = [
      caAnnuel,
      (caAnnuel * 1.15).round(),
      (caAnnuel * 1.3).round(),
    ];
    final max = annees.last;
    return Bloc(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.t.iaChiffreDAffairesPrevisionnel,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final (i, v) in annees.indexed)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            fcfaCourt(v),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          TweenAnimationBuilder<double>(
                            tween: Tween(end: v / max),
                            duration: Duration(milliseconds: 600 + i * 200),
                            curve: courbeDouce,
                            builder: (_, f, _) => Container(
                              height: 100 * f,
                              decoration: BoxDecoration(
                                color: i == 2
                                    ? LiveColors.orange
                                    : LiveColors.bleu,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.t.iaAnneeN(i + 1),
                            style: const TextStyle(
                              fontSize: 12,
                              color: LiveColors.gris,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.t.iaChiffresIndicatifsAFaire,
            style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}
