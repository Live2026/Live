part of 'market_screens.dart';

/// Écran « Félicitations » de « Vendre un produit ».
extension _FelicitationsVente on _EcranVendreState {
  /// Écran de réussite : annonce en ligne, partage, suite.
  Widget _felicitations(BuildContext context) {
    return Scaffold(
      backgroundColor: LiveColors.nuit,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const CocheAnimee(taille: 96),
              const SizedBox(height: 8),
              Text(
                context.t.marketFelicitations,
                style: TextStyle(
                  color: LiveColors.ambreClair,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                context.t.marketVotreAnnonceEstEn,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Vignette(
                      couleur: const Color(0xFF6D28D9),
                      icone: Icons.sell_rounded,
                      hauteur: 56,
                      largeur: 56,
                      rayon: 8,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _titre.text.trim(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            fcfa(_montant),
                            style: const TextStyle(
                              color: LiveColors.ambreClair,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                context.t.marketPartagezVotreAnnonce,
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final (icone, nom) in [
                    (Icons.chat_rounded, 'WhatsApp'),
                    (Icons.facebook_rounded, 'Facebook'),
                    (Icons.amp_stories_rounded, context.t.marketStatut),
                    (Icons.link_rounded, context.t.marketCopierLeLien),
                  ])
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: IconButton.filledTonal(
                        tooltip: nom,
                        onPressed: () => partager(context, _titre.text.trim()),
                        icon: Icon(icone),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                context.t.marketPourLeTestUne,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60, fontSize: 12.5),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: LiveColors.orangeVif,
                  ),
                  onPressed: () => context.go('/mes-ventes'),
                  child: Text(context.t.marketVoirMesVentes),
                ),
              ),
              TextButton(
                onPressed: () => context.pushReplacement('/vendre'),
                child: Text(
                  context.t.marketVendreUnAutreObjet,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ce que le vendeur reçoit : offre de lancement puis commission de 6 %.
class _Gain extends StatelessWidget {
  const _Gain({required this.prix});
  final int prix;

  @override
  Widget build(BuildContext context) {
    final net = prix - commission(prix, 0.06, minimum: 100);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [LiveColors.bleu, LiveColors.nuit],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.t.marketVousRecevez,
                  style: TextStyle(color: Colors.white70),
                ),
                ChiffreAnime(
                  valeur: prix,
                  format: fcfa,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  context.t.marketCentPourcentOffre(fcfa(net)),
                  style: const TextStyle(color: Colors.white70, fontSize: 12.5),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.savings_rounded,
            color: LiveColors.ambreClair,
            size: 36,
          ),
        ],
      ),
    );
  }
}
