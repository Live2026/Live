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
      appBar: AppBar(title: const Text('Fonds Créateurs')),
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
                const Text(
                  'Fonds du mois',
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
                const Text(
                  '30 % des revenus publicitaires de septembre',
                  style: TextStyle(color: LiveColors.ambreClair),
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Expanded(child: _Chiffre('412', 'créateurs éligibles')),
                    Expanded(child: _Chiffre('6 070', 'FCFA en moyenne')),
                    Expanded(child: _Chiffre('5 oct.', 'versement')),
                  ],
                ),
              ],
            ),
          ),
          const EnTeteSection('Comment la part est calculée'),
          for (final (icone, titre, texte) in const [
            (
              Icons.favorite_rounded,
              'Engagement réel',
              'Temps de visionnage, partages, commentaires de comptes vérifiés.',
            ),
            (
              Icons.auto_awesome_rounded,
              'Qualité et originalité',
              'Contenus originaux, utiles, en français, lingala ou kituba.',
            ),
            (
              Icons.verified_user_rounded,
              'Respect des règles',
              'Aucun avertissement de modération sur la période.',
            ),
            (
              Icons.block_rounded,
              'Pas de fraude',
              'Vues achetées ou comptes multiples : exclusion du fonds.',
            ),
          ])
            LigneMenu(icone: icone, titre: titre, detail: texte),
          const EnTeteSection('Conditions pour y participer'),
          for (final (ok, texte) in const [
            (true, 'Identité vérifiée'),
            (false, '500 abonnés (vous en avez 128)'),
            (false, '10 000 minutes de visionnage sur 28 jours'),
            (true, 'Au moins 4 vidéos originales par mois'),
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
          const Bloc(
            fond: LiveColors.fondAlerte,
            child: Text(
              'Leçon de la v1 : payer les vues avant d’avoir des revenus '
              'publicitaires ruine la plateforme et attire la fraude. Le fonds '
              'n’existe que s’il est financé par la publicité.',
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => context.push('/studio'),
            icon: const Icon(Icons.insights_rounded),
            label: const Text('Voir mes statistiques de créateur'),
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
