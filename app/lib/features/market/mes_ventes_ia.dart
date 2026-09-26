part of 'market_screens.dart';

/// Coach vendeur de Live IA : trois conseils tirés des vues, des contacts et
/// des ventes de la boutique, chacun avec l'action qui l'applique.
class _CoachIa extends StatelessWidget {
  const _CoachIa();

  static const _conseils = [
    (
      Icons.trending_down_rounded,
      'Samsung A10 : 5 % sous le marché',
      'À 28 500 FCFA, il se vendrait deux fois plus vite (38 ventes comparables).',
      'Ajuster le prix',
      '/vendre',
    ),
    (
      Icons.wb_sunny_rounded,
      'Robe wax : photo trop sombre',
      'Les annonces à la lumière du jour reçoivent 3 fois plus de contacts.',
      'Refaire la photo',
      '/publier/media',
    ),
    (
      Icons.schedule_rounded,
      'Publiez vers 19 h',
      'C’est l’heure où vos acheteurs regardent le plus, surtout le samedi.',
      'Programmer une vidéo',
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
            const Row(
              children: [
                Icon(Icons.auto_awesome_rounded, color: LiveColors.orangeVif),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Conseils de Live IA',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
                Etiquette('Gratuit'),
              ],
            ),
            const SizedBox(height: 6),
            for (final (icone, titre, texte, action, route) in _conseils)
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
