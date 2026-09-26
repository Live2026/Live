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

  late final _offres = [
    (
      'Pro Vendeur',
      Icons.storefront_rounded,
      5000,
      [
        context.t.croissanceAnnoncesIllimitees,
        context.t.croissanceStatistiquesDetaillees,
        context.t.croissanceN2BoostsInclusPar,
        context.t.croissanceCommissionReduiteA5,
        context.t.croissanceBadgePro,
      ],
    ),
    (
      'Pro Agence',
      Icons.apartment_rounded,
      15000,
      [
        context.t.croissanceJusquA10Agents,
        context.t.croissanceGestionDesVisitesEt,
        context.t.croissanceAnnoncesIllimitees,
        context.t.croissancePageAgenceVerifiee,
      ],
    ),
    (
      'Pro Prestataire',
      Icons.handyman_rounded,
      4000,
      [
        context.t.croissanceAgendaDeReservation,
        context.t.croissanceDevisIllimites,
        context.t.croissanceMiseEnAvantPar,
        context.t.croissanceBadgePro,
      ],
    ),
    (
      context.t.croissanceEntreprise,
      Icons.business_rounded,
      0,
      [
        context.t.croissancePlusieursGestionnaires,
        context.t.croissanceAccesALApi,
        context.t.croissanceFacturationMensuelle,
        context.t.croissanceAccompagnementDedie,
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: Text(context.t.croissanceOffresLivePro)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 32),
        children: [
          Text(
            context.t.croissanceChoisissezSelonVotreActivite,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _annuel,
            onChanged: (v) => setState(() => _annuel = v),
            title: Text(context.t.croissancePaiementAnnuel),
            subtitle: Text(context.t.croissanceN2MoisOfferts),
          ),
          const SizedBox(height: 8),
          GrilleAdaptative(
            largeurMax: 360,
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
                              ? context.t.croissanceSurDevis
                              : context.t.croissancePrixPeriode(
                                  fcfa(_annuel ? prix * 10 : prix),
                                  _annuel
                                      ? context.t.croissanceAn
                                      : context.t.croissanceMois,
                                ),
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
                                  child: Text(
                                    context.t.croissanceNousContacter,
                                  ),
                                )
                              : FilledButton(
                                  onPressed: () => _payer(
                                    context,
                                    ref,
                                    TypePaiement.abonnement,
                                    _annuel ? prix * 10 : prix,
                                    _annuel
                                        ? context.t.croissanceUnAn(nom)
                                        : context.t.croissanceUnMois(nom),
                                    'pro',
                                  ),
                                  child: Text(context.t.croissanceChoisir(nom)),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            context.t.croissancePaiementParMobileMoney,
            style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}
