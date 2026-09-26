part of 'expansion_screens.dart';

/// E-CRE-03 — Fonds Créateurs (phase 3, document 02 §5) : une part des
/// revenus publicitaires redistribuée selon la qualité et l'engagement réel.
/// Leçon de la v1 : il n'ouvre que lorsqu'il est financé par la publicité.
class EcranFondsCreateurs extends StatelessWidget {
  const EcranFondsCreateurs({super.key});

  @override
  Widget build(BuildContext context) {
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: Text(context.t.expansionFondsCreateurs)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF7C3AED), LiveColors.nuit],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.t.expansionFondsDuMois,
                  style: TextStyle(color: Colors.white70),
                ),
                ChiffreAnime(
                  valeur: 2500000,
                  format: fcfa,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  context.t.expansionN30DesRevenusPublicitaires,
                  style: TextStyle(color: LiveColors.ambreClair),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _Chiffre(
                        '412',
                        context.t.expansionCreateursEligibles,
                      ),
                    ),
                    Expanded(
                      child: _Chiffre(
                        '6 070',
                        context.t.expansionFcfaEnMoyenne,
                      ),
                    ),
                    Expanded(
                      child: _Chiffre(context.t.expansionN5Oct, 'versement'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          EnTeteSection(context.t.expansionCommentLaPartEst),
          for (final (icone, titre, texte) in [
            (
              Icons.favorite_rounded,
              context.t.expansionEngagementReel,
              context.t.expansionTempsDeVisionnagePartages,
            ),
            (
              Icons.auto_awesome_rounded,
              context.t.expansionQualiteEtOriginalite,
              context.t.expansionContenusOriginauxUtilesEn,
            ),
            (
              Icons.verified_user_rounded,
              context.t.expansionRespectDesRegles,
              context.t.expansionAucunAvertissementDeModeration,
            ),
            (
              Icons.block_rounded,
              context.t.expansionPasDeFraude,
              context.t.expansionVuesAcheteesOuComptes,
            ),
          ])
            LigneMenu(icone: icone, titre: titre, detail: texte),
          EnTeteSection(context.t.expansionConditionsPourYParticiper),
          for (final (ok, texte) in [
            (true, context.t.expansionIdentiteVerifiee),
            (false, context.t.expansionN500AbonnesVousEn),
            (false, context.t.expansionN10000MinutesDe),
            (true, context.t.expansionAuMoins4Videos),
          ])
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(
                    ok
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked,
                    color: ok ? LiveColors.succes : LiveColors.gris,
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(texte)),
                ],
              ),
            ),
          const SizedBox(height: 12),
          Bloc(
            fond: LiveColors.fondAlerte,
            child: Text(context.t.expansionLeconDeLaV1),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => context.push('/studio'),
            icon: const Icon(Icons.insights_rounded),
            label: Text(context.t.expansionVoirMesStatistiquesDe),
          ),
        ],
      ),
    );
  }
}

class _Chiffre extends StatelessWidget {
  const _Chiffre(this.valeur, this.libelle);
  final String valeur;
  final String libelle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          valeur,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          libelle,
          style: const TextStyle(color: Colors.white70, fontSize: 11.5),
        ),
      ],
    );
  }
}
