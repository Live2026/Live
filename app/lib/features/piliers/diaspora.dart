part of 'piliers_screens.dart';

/// Ce que la diaspora paie pour un proche, et le bénéficiaire payé.
List<(IconData, String, String, int)> _besoins(Textes t) => [
  (Icons.home_rounded, t.piliersLoyer, t.piliersPayeALAgence, 90000),
  (
    Icons.shopping_basket_rounded,
    t.piliersCourses,
    t.piliersLivreesOuRetireesAu,
    25000,
  ),
  (Icons.school_rounded, t.piliersScolarite, t.piliersVerseeALEcole, 60000),
  (
    Icons.local_hospital_rounded,
    t.piliersSante,
    t.piliersPharmacieOuCliniquePartenaire,
    15000,
  ),
  (
    Icons.bolt_rounded,
    t.piliersFactures,
    t.piliersElectriciteEauTelevision,
    18450,
  ),
  (
    Icons.handyman_rounded,
    t.piliersUnPro,
    t.piliersPlombierElectricienMacon,
    25000,
  ),
];

/// E-DIA-01 — Diaspora : payer, depuis l'étranger, ce dont un proche a
/// besoin au pays, avec preuve de remise ; ou lui envoyer de l'argent
/// (Live Transfert). Paiement par carte dans la devise choisie (donnees_devises).
class EcranDiaspora extends ConsumerStatefulWidget {
  const EcranDiaspora({super.key});

  @override
  ConsumerState<EcranDiaspora> createState() => _EcranDiasporaState();
}

class _EcranDiasporaState extends ConsumerState<EcranDiaspora> {
  var _proche = 0;

  void _payerBesoin(String besoin, int montant) {
    final (nom, _, _, _) = proches[_proche];
    final d = deviseParCode(ref.read(liveProvider).devise);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: LiveColors.surface,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.t.piliersBesoinPour(besoin, nom),
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              LigneMontant(context.t.piliersMontantAuPays, montant),
              LigneMontant(
                context.t.piliersSoitParCarte,
                0,
                brut: d.ecrire(d.depuisFcfa(montant), decimales: true),
              ),
              LigneMontant(context.t.piliersFraisLive, 0, brut: '1,5 %'),
              const SizedBox(height: 8),
              Text(
                context.t.piliersVotreProcheEstPrevenu,
                style: TextStyle(color: LiveColors.gris),
              ),
              const SizedBox(height: 14),
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _payer(
                    context,
                    ref,
                    TypePaiement.pourUnProche,
                    (montant * 1.015).round(),
                    context.t.piliersBesoinPour(besoin, nom),
                    besoin,
                    beneficiaire: nom,
                  );
                },
                child: Text(context.t.piliersPayerParCarte),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final envois = ref.watch(liveProvider.select((e) => e.envois));
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: Text(context.t.piliersDiaspora)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 32),
        children: [
          _Banniere(
            icone: Icons.flight_land_rounded,
            titre: context.t.piliersDIciPrenezSoin,
            texte: context.t.piliersPayezLeLoyerLes,
            couleurs: const [Color(0xFF0369A1), LiveColors.nuit],
            enfant: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: LiveColors.orange,
                foregroundColor: LiveColors.encre,
                minimumSize: const Size(0, 44),
              ),
              onPressed: () => context.push('/transfert'),
              icon: const Icon(Icons.send_rounded),
              label: Text(context.t.piliersEnvoyerDeLArgent),
            ),
          ),
          EnTeteSection(context.t.piliersPourQui),
          SizedBox(
            height: 104,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final (i, (nom, lieu, _, couleur)) in proches.indexed)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => _proche = i),
                      child: Semantics(
                        selected: _proche == i,
                        button: true,
                        child: SizedBox(
                          width: 92,
                          child: Column(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _proche == i
                                        ? LiveColors.orangeVif
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                                child: Avatar(
                                  nom: nom,
                                  couleur: couleur,
                                  taille: 52,
                                ),
                              ),
                              Text(
                                nom,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                lieu.split(',').first,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: LiveColors.gris,
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  width: 92,
                  child: Column(
                    children: [
                      IconButton.filledTonal(
                        tooltip: context.t.piliersAjouterUnProche,
                        iconSize: 30,
                        onPressed: () => informer(
                          context,
                          context.t.piliersAjoutParNumeroDe,
                        ),
                        icon: const Icon(Icons.person_add_alt_1_rounded),
                      ),
                      Text(context.t.piliersAjouter),
                    ],
                  ),
                ),
              ],
            ),
          ),
          EnTeteSection(context.t.piliersQueVoulezVousPayer),
          GrilleAdaptative(
            largeurMax: 260,
            espacement: 10,
            hauteur: 112,
            enfants: [
              for (final (i, (icone, titre, texte, montant)) in _besoins(
                context.t,
              ).indexed)
                Apparition(
                  rang: i,
                  child: Pressable(
                    onTap: () => _payerBesoin(titre, montant),
                    child: Bloc(
                      padding: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(icone, color: const Color(0xFF0369A1)),
                          const Spacer(),
                          Text(
                            titre,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          Text(
                            texte,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: LiveColors.gris,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          EnTeteSection(context.t.piliersMesEnvois),
          if (envois.isEmpty)
            Text(
              context.t.piliersVosPaiementsEtTransferts,
              style: TextStyle(color: LiveColors.gris),
            )
          else
            for (final e in envois)
              LigneMenu(
                icone: Icons.verified_rounded,
                titre: e,
                detail: context.t.piliersPayeVotreProcheA,
                couleur: LiveColors.succes,
              ),
        ],
      ),
    );
  }
}
