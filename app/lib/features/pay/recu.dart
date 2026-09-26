part of 'pay_screens.dart';

/// E-PAY-06 — Reçu d'un paiement, d'une vente ou d'un retrait.
class EcranRecu extends ConsumerWidget {
  const EcranRecu({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final etat = ref.watch(liveProvider);
    final achat = etat.achats.where((c) => c.id == id).firstOrNull;
    final libelle = achat?.produit.titre ?? context.t.payPaiementLive;
    final montant = achat?.total ?? 30000;
    final reference = 'LV-P-2026-${id.hashCode.abs() % 100000}';
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.payRecu),
        actions: [
          IconButton(
            tooltip: context.t.payPartagerLeRecu,
            onPressed: () => partager(context, context.t.payRecuRef(reference)),
            icon: const Icon(Icons.ios_share_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Bloc(
            padding: 20,
            child: Column(
              children: [
                const LogoLive(taille: 30),
                const SizedBox(height: 4),
                Text(
                  context.t.payRecuDePaiement,
                  style: TextStyle(color: LiveColors.gris),
                ),
                const SizedBox(height: 16),
                Text(
                  fcfa(montant),
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Etiquette(
                  context.t.payPayeArgentProtege,
                  icone: Icons.verified_user,
                  fond: LiveColors.teinteVerte,
                  couleur: LiveColors.succes,
                ),
                const Divider(height: 32),
                _Ligne(context.t.payObjet, libelle),
                _Ligne(context.t.payReference2, reference),
                _Ligne(context.t.payDate, context.t.payN25Sept202610),
                _Ligne(
                  context.t.payMoyen,
                  context.t.payOperateurTel(
                    etat.operateur == 'MTN' ? 'MTN MoMo' : 'Airtel Money',
                    etat.telephone,
                  ),
                ),
                _Ligne(
                  context.t.payOperateur,
                  context.t.payRefOperateurMp2609251021,
                ),
                _Ligne(context.t.payPayePar, etat.prenom),
                const Divider(height: 32),
                LigneMontant(context.t.payMontant, montant),
                LigneMontant(context.t.payFraisPourLAcheteur, 0),
                LigneMontant(context.t.payTotal, montant, gras: true),
                const SizedBox(height: 12),
                Text(
                  context.t.payLiveCongoSasRccm,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: LiveColors.gris, fontSize: 11.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.t.payRecuEnregistreEnPdf)),
            ),
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: Text(context.t.payTelechargerEnPdf),
          ),
        ],
      ),
    );
  }
}

class _Ligne extends StatelessWidget {
  const _Ligne(this.libelle, this.valeur);
  final String libelle;
  final String valeur;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              libelle,
              style: const TextStyle(color: LiveColors.gris),
            ),
          ),
          Expanded(child: Text(valeur, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}
