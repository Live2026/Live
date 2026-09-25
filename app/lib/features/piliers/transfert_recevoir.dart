part of 'piliers_screens.dart';

/// E-DIA-03 — Recevoir de l'étranger : le proche envoie dans sa devise, on
/// reçoit en francs CFA sur son solde Live, puis on retire en Mobile Money
/// sans frais.
class _Recevoir extends ConsumerWidget {
  const _Recevoir();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final etat = ref.watch(liveProvider);
    final retires = etat.transfertsRetires;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Banniere(
          icone: Icons.public_rounded,
          titre: 'Recevez du monde entier',
          texte:
              'Vos proches envoient en euros, dollars, livres ou yuans ; vous '
              'recevez en francs CFA, sans frais de retrait.',
          couleurs: const [Color(0xFF15803D), LiveColors.nuit],
          enfant: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Votre numéro de réception',
                style: TextStyle(color: Colors.white70),
              ),
              Text(
                '${etat.telephone} · ${etat.prenom}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: LiveColors.orange,
                  foregroundColor: LiveColors.nuit,
                  minimumSize: const Size(0, 44),
                ),
                onPressed: () => partager(
                  context,
                  'Envoie-moi de l’argent avec Live Transfert, dans ta '
                  'devise : live.africa/recevoir/${etat.telephone.replaceAll(' ', '')}',
                ),
                icon: const Icon(Icons.share_rounded),
                label: const Text('Partager mon lien de réception'),
              ),
            ],
          ),
        ),
        const EnTeteSection('Devises acceptées'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final d in devises)
              Etiquette(
                '${d.code} · ${d.nom}',
                fond: d.couleur.withValues(alpha: 0.1),
                couleur: d.couleur,
              ),
          ],
        ),
        const EnTeteSection('Transferts reçus'),
        for (final t in transfertsRecus)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _CarteRecu(recu: t, retire: retires.contains(t.id)),
          ),
        const SizedBox(height: 4),
        const _NoteAgrement(),
      ],
    );
  }
}

class _CarteRecu extends ConsumerWidget {
  const _CarteRecu({required this.recu, required this.retire});
  final TransfertRecu recu;
  final bool retire;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = deviseParCode(recu.devise);
    final op = ref.watch(liveProvider.select((e) => e.operateur));
    final compte = op == 'MTN' ? 'MTN MoMo' : '$op Money';
    return Bloc(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _PastilleDevise(devise: d),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${recu.de} · ${recu.lieu}',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      '${d.ecrire(recu.montant)} envoyés · ${recu.quand}',
                      style: const TextStyle(color: LiveColors.gris),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            fcfa(recu.fcfa),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: LiveColors.succes,
            ),
          ),
          const SizedBox(height: 8),
          if (retire)
            Etiquette(
              'Versé sur votre compte $compte',
              icone: Icons.check_circle_rounded,
              fond: const Color(0xFFE7F4EC),
              couleur: LiveColors.succes,
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Etiquette(
                  'Sur votre solde Live',
                  icone: Icons.account_balance_wallet_rounded,
                  fond: Color(0xFFFFF4E0),
                  couleur: LiveColors.cuivre,
                ),
                FilledButton.icon(
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
                  onPressed: () {
                    ref.read(liveProvider.notifier).retirerTransfert(recu.id);
                    informer(
                      context,
                      '${fcfa(recu.fcfa)} versés sur votre compte '
                      '$compte, sans frais.',
                    );
                  },
                  icon: const Icon(Icons.south_rounded),
                  label: Text('Retirer en $compte'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
