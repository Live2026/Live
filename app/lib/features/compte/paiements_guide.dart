part of 'compte_screens.dart';

/// Guide des paiements : ce qui se paie dans Live (protégé), ce qui se voit
/// puis se paie sur place, et ce qui se paie en direct contre reçu.
class EcranGuidePaiements extends StatelessWidget {
  const EcranGuidePaiements({super.key});

  static const _modes = [
    (
      Reglement.dansLive,
      'L’argent est bloqué par Live et versé seulement quand vous confirmez '
          '(QR, réception, fin du service). Remboursé sinon.',
      [
        'Achats payés d’avance (argent bloqué jusqu’au QR de remise)',
        'Frais de visite d’un logement',
        'Acompte de réservation d’un logement',
        'Services à prix fixe et acomptes de devis',
        'Crédits Live IA, boosts, Live Pro',
      ],
    ),
    (
      Reglement.surPlace,
      'Vous voyez l’objet avant d’acheter. La commande est réservée sans '
          'paiement ; au rendez-vous, vous validez la demande MoMo ou Airtel '
          'envoyée par Live. Pas d’avance, pas d’espèces.',
      [
        'Téléphones et ordinateurs d’occasion',
        'Motos, voitures, pièces',
        'Électroménager et meubles d’occasion',
      ],
    ),
    (
      Reglement.direct,
      'Ces sommes se règlent entre vous et le propriétaire, l’agence ou '
          'l’organisme, contre un reçu ou un contrat signé. Live affiche les '
          'montants à l’avance mais ne les encaisse pas.',
      [
        'Loyers, avance et caution',
        'Commission d’agence',
        'Prix d’achat d’une maison ou d’un terrain (chez le notaire)',
        'Frais officiels d’un concours (Live Emploi)',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: const Text('Ce qui se paie dans Live')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 8, marge, 32),
        children: [
          const Text(
            'Sur Live, chaque somme porte une étiquette : vous savez toujours '
            'où et comment elle se paie.',
            style: TextStyle(fontSize: 15.5),
          ),
          const SizedBox(height: 16),
          GrilleAdaptative(
            largeurMax: 420,
            espacement: 12,
            enfants: [
              for (final (mode, texte, exemples) in _modes)
                _CarteMode(mode: mode, texte: texte, exemples: exemples),
            ],
          ),
          const SizedBox(height: 16),
          Bloc(
            fond: LiveColors.fondAlerte,
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded, color: LiveColors.cuivre),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Si une somme est marquée « Payé dans Live » et qu’on vous '
                    'demande de l’envoyer directement sur un numéro MoMo, '
                    'c’est une arnaque : refusez et signalez-la.',
                  ),
                ),
              ],
            ),
          ),
          const BoutonEcouter(
            'Trois cas. Payé dans Live : Live garde votre argent jusqu’à ce que '
            'vous confirmiez. À la remise : vous voyez d’abord l’objet, puis vous '
            'validez le paiement MoMo sur votre téléphone. En direct : loyers, caution, '
            'prix d’une maison ou frais officiels, payés contre reçu au '
            'propriétaire ou à l’organisme.',
          ),
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
