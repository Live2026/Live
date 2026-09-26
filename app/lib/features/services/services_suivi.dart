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
          'Devis de ${d.prestataire.nom} · ${note(d.prestataire.note)}',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Réparation fuite évier cuisine',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text('${d.quand} · environ 1 h 30'),
          const Divider(height: 24),
          LigneMontant("Main-d'œuvre", d.mainOeuvre),
          LigneMontant('Matériel', d.materiel),
          LigneMontant('TOTAL', d.total, gras: true),
          const Divider(height: 24),
          if (finSeule)
            const Text(
              'Rien à payer maintenant : vous payez à la fin, par MoMo ou Airtel.',
            )
          else ...[
            LigneMontant('Maintenant (acompte)', d.acompte),
            LigneMontant('Après les travaux', d.total - d.acompte),
          ],
          const SizedBox(height: 8),
          const Text('Garantie 72 h · annulation gratuite jusqu\'à 2 h avant.'),
          const BoutonEcouter(
            "L'acompte est gardé par Live. Au démarrage des travaux, vous montrez votre QR au plombier : il reçoit alors la part matériel. Le reste lui est versé à la fin. Si le travail est mal fait, vous avez 72 heures pour le signaler.",
          ),
          const BandeauProtection(
            'Matériel payé au démarrage, le reste à la fin.',
          ),
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
                libelle: 'Acompte devis',
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
                ? 'Accepter le devis'
                : 'Accepter et payer ${fcfa(d.acompte)}',
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
        title: Text('Prestation · ${d.prestataire.nom}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/accueil'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Réparation fuite · ${d.quand}',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _Etape(
            d.acompte == 0
                ? 'Devis accepté (payer à la fin)'
                : 'Acompte payé (${fcfa(d.acompte)} bloqués)',
            true,
          ),
          _Etape('Travaux démarrés', p.statut != StatutPrestation.acompte),
          _Etape('Travaux terminés', p.statut == StatutPrestation.terminee),
          const SizedBox(height: 16),
          switch (p.statut) {
            StatutPrestation.acompte => Column(
              children: [
                CarteQr(
                  titre: 'Démarrer les travaux',
                  donnee: 'live://demarrage/${p.id}',
                  codeSecours: 'LV-D6042',
                  consigne: d.materiel > 0
                      ? 'À montrer quand ${d.prestataire.nom} commence : il reçoit ${fcfa(d.materiel)} (matériel).'
                      : 'À montrer quand ${d.prestataire.nom} commence.',
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () =>
                      partager(context, 'Suivi de mon intervention Live'),
                  icon: const Icon(Icons.share_location),
                  label: const Text('Partager avec un proche'),
                ),
                const SizedBox(height: 12),
                BoutonSimulation(
                  texte: '${d.prestataire.nom} scanne votre QR',
                  onTap: () => store.avancerPrestation(p.id),
                ),
              ],
            ),
            StatutPrestation.demarree => Column(
              children: [
                const Text('Travaux en cours…', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 12),
                BoutonSimulation(
                  texte: '${d.prestataire.nom} déclare la fin (avec photos)',
                  onTap: () => store.avancerPrestation(p.id),
                ),
              ],
            ),
            StatutPrestation.terminee => Column(
              children: [
                const CocheAnimee(taille: 64),
                Text(
                  'Travaux terminés. Reste à payer : ${fcfa(d.total - d.acompte)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Garantie : 72 h pour signaler un problème.'),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => _fin(context),
                  child: const Text('Travaux conformes'),
                ),
                TextButton(
                  onPressed: () => context.push('/probleme/prestation/${p.id}'),
                  child: const Text('Signaler un problème'),
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
        title: const Text('Merci !'),
        content: const Text(
          "Dans l'application réelle : le solde est payé par MoMo ou Airtel, le prestataire est payé, puis vous pouvez laisser un avis.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
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
