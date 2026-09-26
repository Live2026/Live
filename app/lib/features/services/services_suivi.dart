part of 'services_screens.dart';

/// E-SRV-05 — Détail du devis et acceptation.
class EcranDetailDevis extends ConsumerWidget {
  const EcranDetailDevis({super.key, required this.prestataireId});
  final String prestataireId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = devisRecus.firstWhere(
      (d) => d.prestataire.id == prestataireId,
      orElse: () => devisRecus[1],
    );
    final finSeule = d.acompte == 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.t.servicesDevisDe(
            d.prestataire.nom,
            note(d.prestataire.note),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            context.t.servicesReparationFuiteEvierCuisine,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(context.t.servicesQuandDuree(d.quand)),
          const Divider(height: 24),
          LigneMontant(context.t.servicesMainDUvre2, d.mainOeuvre),
          LigneMontant(context.t.servicesMateriel, d.materiel),
          LigneMontant(context.t.servicesTotal2, d.total, gras: true),
          const Divider(height: 24),
          if (finSeule)
            Text(context.t.servicesRienAPayerMaintenant)
          else ...[
            LigneMontant(context.t.servicesMaintenantAcompte, d.acompte),
            LigneMontant(
              context.t.servicesApresLesTravaux,
              d.total - d.acompte,
            ),
          ],
          const SizedBox(height: 8),
          Text(context.t.servicesGarantieAnnulation),
          BoutonEcouter(context.t.servicesLAcompteEstGarde),
          BandeauProtection(context.t.servicesMaterielPayeAuDemarrage),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: () {
            final store = ref.read(liveProvider.notifier);
            store.preparerPaiement(
              PaiementEnCours(
                type: TypePaiement.acompte,
                montant: d.acompte,
                libelle: context.t.servicesAcompteDevis,
                beneficiaire: d.prestataire.nom,
                cibleId: d.prestataire.id,
              ),
            );
            if (finSeule) {
              final id = store.paiementReussi();
              context.go('/prestation/$id');
            } else {
              context.push('/payer');
            }
          },
          child: Text(
            finSeule
                ? context.t.servicesAccepterLeDevis
                : context.t.servicesAccepterPayer(fcfa(d.acompte)),
          ),
        ),
      ),
    );
  }
}

/// E-SRV-07 — Suivi de la prestation (client).
class EcranPrestation extends ConsumerWidget {
  const EcranPrestation({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref
        .watch(liveProvider)
        .prestations
        .firstWhere(
          (p) => p.id == id,
          // Ouverture directe (démonstration) : prestation d'exemple.
          orElse: () => Prestation(
            id: id,
            devis: devisRecus[1],
            statut: StatutPrestation.acompte,
          ),
        );
    final d = p.devis;
    final store = ref.read(liveProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.servicesPrestationDe(d.prestataire.nom)),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/accueil'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            context.t.servicesReparationQuand(d.quand),
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _Etape(
            d.acompte == 0
                ? context.t.servicesDevisAcceptePayerA
                : context.t.servicesAcomptePayeBloques(fcfa(d.acompte)),
            true,
          ),
          _Etape(
            context.t.servicesTravauxDemarres,
            p.statut != StatutPrestation.acompte,
          ),
          _Etape(
            context.t.servicesTravauxTermines,
            p.statut == StatutPrestation.terminee,
          ),
          const SizedBox(height: 16),
          switch (p.statut) {
            StatutPrestation.acompte => Column(
              children: [
                CarteQr(
                  titre: context.t.servicesDemarrerLesTravaux,
                  donnee: 'live://demarrage/${p.id}',
                  codeSecours: 'LV-D6042',
                  consigne: d.materiel > 0
                      ? context.t.servicesMontrerMateriel(
                          d.prestataire.nom,
                          fcfa(d.materiel),
                        )
                      : context.t.servicesMontrerQuand(d.prestataire.nom),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () =>
                      partager(context, 'Suivi de mon intervention Live'),
                  icon: const Icon(Icons.share_location),
                  label: Text(context.t.servicesPartagerAvecUnProche),
                ),
                const SizedBox(height: 12),
                BoutonSimulation(
                  texte: context.t.servicesScanneQr(d.prestataire.nom),
                  onTap: () => store.avancerPrestation(p.id),
                ),
              ],
            ),
            StatutPrestation.demarree => Column(
              children: [
                Text(
                  context.t.servicesTravauxEnCours,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),
                BoutonSimulation(
                  texte: context.t.servicesDeclareFin(d.prestataire.nom),
                  onTap: () => store.avancerPrestation(p.id),
                ),
              ],
            ),
            StatutPrestation.terminee => Column(
              children: [
                const CocheAnimee(taille: 64),
                Text(
                  context.t.servicesResteAPayer(fcfa(d.total - d.acompte)),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(context.t.servicesGarantie72HPour),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => _fin(context),
                  child: Text(context.t.servicesTravauxConformes),
                ),
                TextButton(
                  onPressed: () => context.push('/probleme/prestation/${p.id}'),
                  child: Text(context.t.servicesSignalerUnProbleme),
                ),
              ],
            ),
          },
        ],
      ),
    );
  }

  void _fin(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.t.servicesMerci),
        content: Text(context.t.servicesDansLApplicationReelle),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.t.ok),
          ),
        ],
      ),
    );
  }
}

class _Etape extends StatelessWidget {
  const _Etape(this.texte, this.fait);
  final String texte;
  final bool fait;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            fait ? Icons.check_circle : Icons.radio_button_unchecked,
            color: fait ? LiveColors.bleu : LiveColors.gris,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              texte,
              style: TextStyle(
                fontSize: 16,
                color: fait ? LiveColors.encre : LiveColors.gris,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
