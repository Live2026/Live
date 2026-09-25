part of 'pay_screens.dart';

/// E-PAY-06 — Reçu d'un paiement, d'une vente ou d'un retrait.
class EcranRecu extends ConsumerWidget {
  const EcranRecu({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final etat = ref.watch(liveProvider);
    final achat = etat.achats.where((c) => c.id == id).firstOrNull;
    final libelle = achat?.produit.titre ?? 'Paiement Live';
    final montant = achat?.total ?? 30000;
    final reference = 'LV-P-2026-${id.hashCode.abs() % 100000}';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reçu'),
        actions: [
          IconButton(
            tooltip: 'Partager le reçu',
            onPressed: () => partager(context, 'Reçu $reference'),
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
                const Text(
                  'Reçu de paiement',
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
                const Etiquette(
                  'Payé · argent protégé',
                  icone: Icons.verified_user,
                  fond: Color(0xFFE7F4EC),
                  couleur: LiveColors.succes,
                ),
                const Divider(height: 32),
                _Ligne('Objet', libelle),
                _Ligne('Référence', reference),
                const _Ligne('Date', '25 sept. 2026 · 10:21'),
                _Ligne(
                  'Moyen',
                  '${etat.operateur == 'MTN' ? 'MTN MoMo' : 'Airtel Money'} · ${etat.telephone}',
                ),
                const _Ligne('Opérateur', 'Réf. opérateur MP260925.1021.C4412'),
                _Ligne('Payé par', etat.prenom),
                const Divider(height: 32),
                LigneMontant('Montant', montant),
                const LigneMontant('Frais pour l’acheteur', 0),
                LigneMontant('Total', montant, gras: true),
                const SizedBox(height: 12),
                const Text(
                  'Live Congo SAS · RCCM CG-BZV-01-2026-B12-00000 · '
                  'fonds détenus sur compte de séquestre bancaire.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: LiveColors.gris, fontSize: 11.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Reçu enregistré en PDF (simulation).'),
              ),
            ),
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: const Text('Télécharger en PDF'),
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
