part of 'croissance_screens.dart';

/// E-PRO-02 — Offres Live Pro complètes (phase 2, document 02 §4.3) :
/// Pro Vendeur, Pro Agence, Pro Prestataire, Entreprise. Les abonnements
/// ne créent pas de rôle : ils débloquent des capacités (document 03 §7).
class EcranOffresPro extends ConsumerStatefulWidget {
  const EcranOffresPro({super.key});

  @override
  ConsumerState<EcranOffresPro> createState() => _EcranOffresProState();
}

class _EcranOffresProState extends ConsumerState<EcranOffresPro> {
  var _annuel = false;

  static const _offres = [
    (
      'Pro Vendeur',
      Icons.storefront_rounded,
      5000,
      [
        'Annonces illimitées',
        'Statistiques détaillées',
        '2 boosts inclus par mois',
        'Commission réduite à 5 %',
        'Badge Pro',
      ],
    ),
    (
      'Pro Agence',
      Icons.apartment_rounded,
      15000,
      [
        'Jusqu’à 10 agents',
        'Gestion des visites et du calendrier',
        'Annonces illimitées',
        'Page agence vérifiée',
      ],
    ),
    (
      'Pro Prestataire',
      Icons.handyman_rounded,
      4000,
      [
        'Agenda de réservation',
        'Devis illimités',
        'Mise en avant par quartier',
        'Badge Pro',
      ],
    ),
    (
      'Entreprise',
      Icons.business_rounded,
      0,
      [
        'Plusieurs gestionnaires',
        'Accès à l’API partenaires',
        'Facturation mensuelle',
        'Accompagnement dédié',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: const Text('Offres Live Pro')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 32),
        children: [
          const Text(
            'Choisissez selon votre activité',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _annuel,
            onChanged: (v) => setState(() => _annuel = v),
            title: const Text('Paiement annuel'),
            subtitle: const Text('2 mois offerts'),
          ),
          const SizedBox(height: 8),
          GrilleAdaptative(
            largeurMax: 320,
            espacement: 12,
            enfants: [
              for (final (i, (nom, icone, prix, avantages)) in _offres.indexed)
                Apparition(
                  rang: i,
                  child: Bloc(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(icone, color: LiveColors.orangeVif, size: 28),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                nom,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          prix == 0
                              ? 'Sur devis'
                              : '${fcfa(_annuel ? prix * 10 : prix)} / ${_annuel ? 'an' : 'mois'}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (final a in avantages)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_rounded,
                                  size: 18,
                                  color: LiveColors.succes,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    a,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: prix == 0
                              ? OutlinedButton(
                                  onPressed: () =>
                                      context.push('/conversation'),
                                  child: const Text('Nous contacter'),
                                )
                              : FilledButton(
                                  onPressed: () => _payer(
                                    context,
                                    ref,
                                    TypePaiement.abonnement,
                                    _annuel ? prix * 10 : prix,
                                    '$nom · ${_annuel ? '1 an' : '1 mois'}',
                                    'pro',
                                  ),
                                  child: Text('Choisir $nom'),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Paiement par Mobile Money, sans engagement. L’espace agence reste '
            'gratuit pendant le MVP (D-26).',
            style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}
