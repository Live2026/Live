part of 'immo_screens.dart';

const _jours = [
  ('Lun', '29'),
  ('Mar', '30'),
  ('Mer', '1'),
  ('Jeu', '2'),
  ('Ven', '3'),
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
    final (nomJour, numero) = _jours[_jour];
    return Scaffold(
      appBar: AppBar(title: const Text('Demander une visite')),
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
                      '${b.titre} · ${b.quartier}',
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
          const Text(
            'Choisissez un jour',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _jours.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final (j, n) = _jours[i];
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
          const Text(
            'Choisissez une heure',
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
                LigneMontant('Frais de visite', b.fraisVisite, gras: true),
                const SizedBox(height: 8),
                const _Regle(
                  Icons.undo_rounded,
                  "L'annonceur ne vient pas ou le bien n'est plus libre : vous êtes remboursé.",
                ),
                const _Regle(
                  Icons.event_busy_outlined,
                  "Vous ne venez pas : les frais sont versés à l'annonceur.",
                ),
                const BoutonEcouter(
                  "Vous payez les frais de visite maintenant, mais Live les garde. L'annonceur ne les reçoit qu'après la visite, quand il scanne votre QR. S'il ne vient pas, ou si le logement n'est plus libre, vous êtes remboursé. Si c'est vous qui ne venez pas, les frais lui sont versés.",
                ),
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
                          libelle: 'Visite ${b.titre}',
                          beneficiaire: b.annonceur.nom,
                          cibleId: b.id,
                          creneau: '$nomJour $numero · $_heure',
                        ),
                      );
                  context.push('/payer');
                },
          child: Text(
            _heure == null
                ? 'Choisissez un créneau'
                : 'Payer ${fcfa(b.fraisVisite)}',
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
          creneau: 'Mar 30 · 10:30',
          statut: StatutVisite.payee,
        );
    final confirmee = v.statut != StatutVisite.payee;
    return Scaffold(
      appBar: AppBar(
        title: Text('Visite · ${v.creneau}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/accueil'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '${v.bien.titre} · ${v.bien.quartier}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(switch (v.statut) {
            StatutVisite.payee => 'Statut : réservée et payée',
            StatutVisite.confirmee => 'Visite effectuée',
            StatutVisite.reservee => 'Logement réservé',
          }, style: const TextStyle(color: LiveColors.bleu)),
          const SizedBox(height: 12),
          Bloc(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Adresse exacte',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '12, rue Mbochis, ${v.bien.quartier}\nRepère : ${v.bien.repere}',
                ),
                const SizedBox(height: 8),
                const Text(
                  'Votre contact',
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
                  ? 'Logement réservé. L’acompte est bloqué par Live jusqu’à la signature du bail.'
                  : "Visite confirmée. Si le logement vous plaît, l'agence peut vous envoyer une offre de réservation.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (v.statut == StatutVisite.confirmee)
              FilledButton(
                onPressed: () => context.push('/visite/${v.id}/offre'),
                child: const Text("Voir l'offre de réservation"),
              ),
            TextButton(
              onPressed: () => context.push('/avis/visite/${v.id}'),
              child: const Text('Laisser un avis'),
            ),
          ] else ...[
            CarteQr(
              titre: 'Confirmer la visite',
              donnee: 'live://visite/${v.id}',
              codeSecours: 'LV-V3915',
              consigne: "Montrez-le à l'agent sur place.",
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.push('/probleme/visite/${v.id}'),
              child: const Text('Le bien ne correspond pas'),
            ),
            TextButton(
              onPressed: () => _annulerOuAbsence(context, v),
              child: const Text('Annuler ou signaler une absence'),
            ),
            const SizedBox(height: 12),
            BoutonSimulation(
              texte: "Simuler : l'agent scanne votre QR",
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
      appBar: AppBar(title: const Text('Offre de réservation')),
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
                    '${b.annonceur.nom} vous propose de réserver ${b.titre.toLowerCase()} à ${b.quartier}.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          LigneMontant('Acompte de réservation (1 mois)', acompte, gras: true),
          LigneMontant('Reste à payer à la signature', b.coutEntree - acompte),
          LigneMontant('Coût d’entrée total', b.coutEntree),
          const SizedBox(height: 12),
          const _Regle(
            Icons.lock_outline_rounded,
            'L’acompte est bloqué par Live jusqu’à la signature du bail et la remise des clés.',
          ),
          const _Regle(
            Icons.undo_rounded,
            'Le propriétaire se désiste : remboursement intégral sous 48 h.',
          ),
          const _Regle(
            Icons.timer_outlined,
            'Vous annulez sous 24 h : remboursé. Au-delà, 50 % sont retenus.',
          ),
          const _Regle(
            Icons.event_outlined,
            'Offre valable jusqu’à demain 18:00.',
          ),
          const SizedBox(height: 12),
          const BandeauProtection('Vos clés ou votre argent.'),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.pop(),
                child: const Text('Refuser'),
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
                          libelle: 'Réservation ${b.titre}',
                          beneficiaire: b.annonceur.nom,
                          cibleId: id,
                        ),
                      );
                  context.push('/payer');
                },
                child: Text('Réserver · ${fcfa(acompte)}'),
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
    titre: 'Annuler ou signaler une absence',
    options: [
      (
        0,
        'Annuler la visite',
        'Plus de 24 h avant : ${fcfa(v.bien.fraisVisite)} remboursés. Moins de 24 h : frais versés à l’annonceur.',
      ),
      (
        1,
        'L’annonceur n’est pas venu',
        'Remboursement intégral, et sa réputation baisse.',
      ),
    ],
  );
  if (!context.mounted || choix == null) return;
  informer(
    context,
    choix == 0
        ? 'Visite annulée : ${fcfa(v.bien.fraisVisite)} remboursés sur votre Mobile Money.'
        : 'Absence signalée : remboursement intégral sous 24 h.',
  );
}
