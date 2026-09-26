part of 'market_screens.dart';

/// Coach vendeur de Live IA : trois conseils tirés des vues, des contacts et
/// des ventes de la boutique, chacun avec l'action qui l'applique.
class _CoachIa extends StatelessWidget {
  const _CoachIa();

  static List<(IconData, String, String, String, String)> _conseils(Textes t) =>
      [
        (
          Icons.trending_down_rounded,
          t.marketSamsungA105Sous,
          t.marketA28500Fcfa,
          t.marketAjusterLePrix,
          '/vendre',
        ),
        (
          Icons.wb_sunny_rounded,
          t.marketRobeWaxPhotoTrop,
          t.marketLesAnnoncesALa,
          t.marketRefaireLaPhoto,
          '/publier/media',
        ),
        (
          Icons.schedule_rounded,
          t.marketPubliezVers19H,
          t.marketCEstLHeure,
          t.marketProgrammerUneVideo,
          '/publier/media',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 4),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFFBCC6A)),
          color: LiveColors.teinteCreme,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome_rounded, color: LiveColors.orangeVif),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.t.marketConseilsDeLiveIa,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
                Etiquette(context.t.marketGratuit),
              ],
            ),
            const SizedBox(height: 6),
            for (final (icone, titre, texte, action, route) in _conseils(
              context.t,
            ))
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icone, color: LiveColors.cuivre),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titre,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            texte,
                            style: const TextStyle(
                              color: LiveColors.gris,
                              fontSize: 13,
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 32),
                            ),
                            onPressed: () => context.push(route),
                            child: Text(action),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
