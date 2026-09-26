part of 'immo_screens.dart';

List<(String, String)> _jours(Textes t) => [
  (t.immoLun, '29'),
  (t.immoMar, '30'),
  (t.immoMer, '1'),
  (t.immoJeu, '2'),
  (t.immoVen, '3'),
];
const _heures = ['09:00', '10:30', '14:00', '15:30', '17:00'];

/// E-IMMO-04 — Choisir un créneau et payer la visite.
class EcranReserverVisite extends ConsumerStatefulWidget {
  const EcranReserverVisite({super.key, required this.id});
  final String id;

  @override
  ConsumerState<EcranReserverVisite> createState() =>
      _EcranReserverVisiteState();
}

class _EcranReserverVisiteState extends ConsumerState<EcranReserverVisite> {
  var _jour = 1;
  String? _heure;

  @override
  Widget build(BuildContext context) {
    final b = bienParId(widget.id);
    final (nomJour, numero) = _jours(context.t)[_jour];
    return Scaffold(
      appBar: AppBar(title: Text(context.t.immoDemanderUneVisite)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              SizedBox(
                width: 72,
                height: 56,
                child: Vignette(
                  couleur: b.couleur,
                  icone: b.type.icone,
                  rayon: 8,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t.immoTitreQuartier(b.titre, b.quartier),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      b.annonceur.nom,
                      style: const TextStyle(color: LiveColors.gris),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Sans se déplacer : l'agent fait visiter en appel vidéo.
          LigneMenu(
            icone: Icons.videocam_outlined,
            titre: context.t.appelVisiteVideo,
            detail: context.t.appelVisiteVideoTexte,
            onTap: () =>
                context.push(routeAppel(avec: b.annonceur.nom, video: true)),
          ),
          const SizedBox(height: 20),
          Text(
            context.t.immoChoisissezUnJour,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _jours(context.t).length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final (j, n) = _jours(context.t)[i];
                final actif = i == _jour;
                return Semantics(
                  button: true,
                  selected: actif,
                  label: '$j $n',
                  excludeSemantics: true,
                  child: Pressable(
                    onTap: () => setState(() => _jour = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 60,
                      decoration: BoxDecoration(
                        color: actif ? LiveColors.bleu : LiveColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: actif ? LiveColors.bleu : LiveColors.filet,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            j,
                            style: TextStyle(
                              color: actif ? Colors.white70 : LiveColors.gris,
                            ),
                          ),
                          Text(
                            n,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: actif ? Colors.white : LiveColors.encre,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          Text(
            context.t.immoChoisissezUneHeure,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final h in _heures)
                ChoiceChip(
                  label: Text(h),
                  selected: _heure == h,
                  onSelected: (_) => setState(() => _heure = h),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Bloc(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LigneMontant(
                  context.t.immoFraisDeVisite,
                  b.fraisVisite,
                  gras: true,
                ),
                const SizedBox(height: 8),
                _Regle(Icons.undo_rounded, context.t.immoLAnnonceurNeVient),
                _Regle(Icons.event_busy_outlined, context.t.immoVousNeVenezPas),
                BoutonEcouter(context.t.immoVousPayezLesFrais),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: _heure == null
              ? null
              : () {
                  ref
                      .read(liveProvider.notifier)
                      .preparerPaiement(
                        PaiementEnCours(
                          type: TypePaiement.visite,
                          montant: b.fraisVisite,
                          libelle: context.t.immoVisiteDe(b.titre),
                          beneficiaire: b.annonceur.nom,
                          cibleId: b.id,
                          creneau: '$nomJour $numero · $_heure',
                        ),
                      );
                  context.push('/payer');
                },
          child: Text(
            _heure == null
                ? context.t.immoChoisissezUnCreneau
                : context.t.immoPayerMontant(fcfa(b.fraisVisite)),
          ),
        ),
      ),
    );
  }
}

class _Regle extends StatelessWidget {
  const _Regle(this.icone, this.texte);
  final IconData icone;
  final String texte;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, size: 18, color: LiveColors.bleu),
          const SizedBox(width: 8),
          Expanded(child: Text(texte, style: const TextStyle(fontSize: 13.5))),
        ],
      ),
    );
  }
}

/// E-IMMO-05 — Ma visite (chercheur).
class EcranVisite extends ConsumerWidget {
  const EcranVisite({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visites = ref.watch(liveProvider).visites;
    final v =
        visites.where((v) => v.id == id).firstOrNull ??
        Visite(
          id: id,
          bien: biens.first,
          creneau: context.t.immoCreneauDemo,
          statut: StatutVisite.payee,
        );
    final confirmee = v.statut != StatutVisite.payee;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.immoVisiteCreneau(v.creneau)),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/accueil'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            context.t.immoTitreQuartier(v.bien.titre, v.bien.quartier),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(switch (v.statut) {
            StatutVisite.payee => context.t.immoStatutReserveeEtPayee,
            StatutVisite.confirmee => context.t.immoVisiteEffectuee,
            StatutVisite.reservee => context.t.immoLogementReserve,
          }, style: const TextStyle(color: LiveColors.bleu)),
          const SizedBox(height: 12),
          Bloc(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.t.immoAdresseExacte,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  context.t.immoAdresseExacteValeur(
                    v.bien.quartier,
                    v.bien.repere,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.t.immoVotreContact,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Christian · ${v.bien.annonceur.nom} · 06 555 44 33'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (confirmee) ...[
            const CocheAnimee(taille: 64),
            Text(
              v.statut == StatutVisite.reservee
                  ? context.t.immoLogementReserveLAcompte
                  : context.t.immoVisiteConfirmeeSiLe,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (v.statut == StatutVisite.confirmee)
              FilledButton(
                onPressed: () => context.push('/visite/${v.id}/offre'),
                child: Text(context.t.immoVoirLOffreDe),
              ),
            TextButton(
              onPressed: () => context.push('/avis/visite/${v.id}'),
              child: Text(context.t.immoLaisserUnAvis),
            ),
          ] else ...[
            CarteQr(
              titre: context.t.immoConfirmerLaVisite,
              donnee: 'live://visite/${v.id}',
              codeSecours: 'LV-V3915',
              consigne: context.t.immoMontrezLeAL,
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.push('/probleme/visite/${v.id}'),
              child: Text(context.t.immoLeBienNeCorrespond),
            ),
            TextButton(
              onPressed: () => _annulerOuAbsence(context, v),
              child: Text(context.t.immoAnnulerOuSignalerUne),
            ),
            const SizedBox(height: 12),
            BoutonSimulation(
              texte: context.t.immoSimulerLAgentScanne,
              onTap: () =>
                  ref.read(liveProvider.notifier).confirmerVisite(v.id),
            ),
          ],
        ],
      ),
    );
  }
}

/// E-IMMO-06 — Offre de réservation envoyée par l'agence après la visite.
class EcranOffreReservation extends ConsumerWidget {
  const EcranOffreReservation({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref
        .watch(liveProvider)
        .visites
        .where((v) => v.id == id)
        .firstOrNull;
    final b = v?.bien ?? biens.first;
    final acompte = b.loyer;
    return Scaffold(
      appBar: AppBar(title: Text(context.t.immoOffreDeReservation)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Bloc(
            child: Row(
              children: [
                Avatar(
                  nom: b.annonceur.nom,
                  couleur: b.annonceur.couleur,
                  verifie: true,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.t.immoVousProposeReserver(
                      b.annonceur.nom,
                      b.titre.toLowerCase(),
                      b.quartier,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          LigneMontant(
            context.t.immoAcompteDeReservation1,
            acompte,
            gras: true,
          ),
          LigneMontant(context.t.immoResteAPayerA, b.coutEntree - acompte),
          LigneMontant(context.t.immoCoutDEntreeTotal, b.coutEntree),
          const SizedBox(height: 12),
          _Regle(Icons.lock_outline_rounded, context.t.immoLAcompteEstBloque),
          _Regle(Icons.undo_rounded, context.t.immoLeProprietaireSeDesiste),
          _Regle(Icons.timer_outlined, context.t.immoVousAnnulezSous24),
          _Regle(Icons.event_outlined, context.t.immoOffreValableJusquA),
          const SizedBox(height: 12),
          BandeauProtection(context.t.immoVosClesOuVotre),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.pop(),
                child: Text(context.t.immoRefuser),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: () {
                  ref
                      .read(liveProvider.notifier)
                      .preparerPaiement(
                        PaiementEnCours(
                          type: TypePaiement.reservation,
                          montant: acompte,
                          libelle: context.t.immoReservationDe(b.titre),
                          beneficiaire: b.annonceur.nom,
                          cibleId: id,
                        ),
                      );
                  context.push('/payer');
                },
                child: Text(context.t.immoReserverMontant(fcfa(acompte))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Annulation ou absence de l'annonceur (F-IMMO-10) : les règles de
/// remboursement sont dites avant de choisir.
Future<void> _annulerOuAbsence(BuildContext context, Visite v) async {
  final choix = await choisir<int>(
    context,
    titre: context.t.immoAnnulerOuSignalerUne,
    options: [
      (
        0,
        context.t.immoAnnulerLaVisite,
        context.t.immoAnnulerTexte(fcfa(v.bien.fraisVisite)),
      ),
      (
        1,
        context.t.immoLAnnonceurNEst,
        context.t.immoRemboursementIntegralEtSa,
      ),
    ],
  );
  if (!context.mounted || choix == null) return;
  informer(
    context,
    choix == 0
        ? context.t.immoVisiteAnnulee(fcfa(v.bien.fraisVisite))
        : context.t.immoAbsenceSignaleeRemboursementIntegral,
  );
}
