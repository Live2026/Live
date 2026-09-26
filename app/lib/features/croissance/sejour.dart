part of 'croissance_screens.dart';

/// E-SEJ-02 — Réserver un séjour : dates en pastilles, nuits, voyageurs,
/// détail du prix, conditions d'annulation, paiement dans Live.
class EcranSejour extends ConsumerStatefulWidget {
  const EcranSejour({super.key, required this.id});
  final String id;

  @override
  ConsumerState<EcranSejour> createState() => _EcranSejourState();
}

class _EcranSejourState extends ConsumerState<EcranSejour> {
  late final _jours = [
    context.t.croissanceVen3,
    context.t.croissanceSam4,
    context.t.croissanceDim5,
    context.t.croissanceLun6,
    context.t.croissanceMar7,
    context.t.croissanceMer8,
    context.t.croissanceJeu9,
    context.t.croissanceVen10,
  ];
  var _arrivee = 0;
  var _nuits = 2;
  var _voyageurs = 1;

  @override
  Widget build(BuildContext context) {
    final s = sejourParId(widget.id);
    final frais = (s.nuit * _nuits * 0.05).round();
    final total = s.nuit * _nuits + frais;
    final depart = (_arrivee + _nuits).clamp(0, _jours.length - 1);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.titre, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: DeuxColonnes(
        principale: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Vignette(
              couleur: s.couleur,
              icone: Icons.king_bed_rounded,
              video: true,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            s.titre,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          Text(
            context.t.croissanceHoteNote(s.quartier, s.hote.nom, note(s.note)),
            style: const TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final e in s.equipements)
                Etiquette(
                  e,
                  icone: Icons.check_rounded,
                  fond: LiveColors.voile,
                  couleur: LiveColors.bleu,
                ),
            ],
          ),
          EnTeteSection(context.t.croissanceArrivee),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _jours.length - 1,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final dans = i > _arrivee && i < _arrivee + _nuits;
                return ChoiceChip(
                  label: Text(_jours[i]),
                  selected: i == _arrivee || dans,
                  onSelected: (_) => setState(() => _arrivee = i),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  context.t.croissanceNuits,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              IconButton.outlined(
                tooltip: context.t.croissanceUneNuitDeMoins,
                onPressed: _nuits > 1 ? () => setState(() => _nuits--) : null,
                icon: const Icon(Icons.remove),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '$_nuits',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton.outlined(
                tooltip: context.t.croissanceUneNuitDePlus,
                onPressed: _nuits < 7 ? () => setState(() => _nuits++) : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  context.t.croissanceVoyageurs,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              IconButton.outlined(
                tooltip: context.t.croissanceUnVoyageurDeMoins,
                onPressed: _voyageurs > 1
                    ? () => setState(() => _voyageurs--)
                    : null,
                icon: const Icon(Icons.remove),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '$_voyageurs',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton.outlined(
                tooltip: context.t.croissanceUnVoyageurDePlus,
                onPressed: _voyageurs < s.voyageurs
                    ? () => setState(() => _voyageurs++)
                    : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
        secondaire: [
          Bloc(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.t.croissanceDuAu(_jours[_arrivee], _jours[depart]),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                LigneMontant(
                  context.t.croissanceNuitsCalc(fcfa(s.nuit), _nuits),
                  s.nuit * _nuits,
                ),
                LigneMontant(context.t.croissanceFraisDeService5, frais),
                const Divider(),
                LigneMontant(context.t.croissanceTotal, total, gras: true),
              ],
            ),
          ),
          const SizedBox(height: 12),
          BandeauProtection(context.t.croissancePayeDansLiveL),
          const SizedBox(height: 8),
          Text(
            context.t.croissanceAnnulationGratuiteJusquA,
            style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: () => _payer(
            context,
            ref,
            TypePaiement.sejour,
            total,
            context.t.croissanceTitreNuits(s.titre, _nuits),
            s.id,
            beneficiaire: s.hote.nom,
          ),
          child: Text(context.t.croissanceReserverMontant(fcfa(total))),
        ),
      ),
    );
  }
}
