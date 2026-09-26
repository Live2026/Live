part of 'compte_screens.dart';

/// Guide des paiements : ce qui se paie dans Live (protégé), ce qui se voit
/// puis se paie sur place, et ce qui se paie en direct contre reçu.
class EcranGuidePaiements extends StatelessWidget {
  const EcranGuidePaiements({super.key});

  static List<(Reglement, String, List<String>)> _modes(Textes t) => [
    (
      Reglement.dansLive,
      t.compteLArgentEstBloque,
      [
        t.compteAchatsPayesDAvance,
        t.compteFraisDeVisiteD,
        t.compteAcompteDeReservationD,
        t.compteServicesAPrixFixe,
        t.compteCreditsLiveIaBoosts,
      ],
    ),
    (
      Reglement.surPlace,
      t.compteVousVoyezLObjet,
      [
        t.compteTelephonesEtOrdinateursD,
        t.compteMotosVoituresPieces,
        t.compteElectromenagerEtMeublesD,
      ],
    ),
    (
      Reglement.direct,
      t.compteCesSommesSeReglent,
      [
        t.compteLoyersAvanceEtCaution,
        t.compteCommissionDAgence,
        t.comptePrixDAchatD,
        t.compteFraisOfficielsDUn,
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: Text(context.t.compteCeQuiSePaie)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 8, marge, 32),
        children: [
          Text(
            context.t.compteSurLiveChaqueSomme,
            style: TextStyle(fontSize: 15.5),
          ),
          const SizedBox(height: 16),
          GrilleAdaptative(
            largeurMax: 420,
            espacement: 12,
            enfants: [
              for (final (mode, texte, exemples) in _modes(context.t))
                _CarteMode(mode: mode, texte: texte, exemples: exemples),
            ],
          ),
          const SizedBox(height: 16),
          Bloc(
            fond: LiveColors.fondAlerte,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded, color: LiveColors.cuivre),
                SizedBox(width: 10),
                Expanded(child: Text(context.t.compteSiUneSommeEst)),
              ],
            ),
          ),
          BoutonEcouter(context.t.compteTroisCasPayeDans),
        ],
      ),
    );
  }
}

class _CarteMode extends StatelessWidget {
  const _CarteMode({
    required this.mode,
    required this.texte,
    required this.exemples,
  });
  final Reglement mode;
  final String texte;
  final List<String> exemples;

  @override
  Widget build(BuildContext context) {
    return Bloc(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: mode.couleur.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(mode.icone, color: mode.couleur),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  mode.libelle,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: mode.couleur,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(texte),
          const SizedBox(height: 8),
          for (final e in exemples)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_rounded, size: 18, color: mode.couleur),
                  const SizedBox(width: 6),
                  Expanded(child: Text(e)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
