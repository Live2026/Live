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
          titre: context.t.piliersRecevezDuMondeEntier,
          texte: context.t.piliersVosProchesEnvoientEn,
          couleurs: const [Color(0xFF15803D), LiveColors.nuit],
          enfant: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.t.piliersVotreNumeroDeReception,
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
                  foregroundColor: LiveColors.encre,
                  minimumSize: const Size(0, 44),
                ),
                onPressed: () => partager(
                  context,
                  context.t.piliersLienReception(
                    'live.africa/recevoir/${etat.telephone.replaceAll(' ', '')}',
                  ),
                ),
                icon: const Icon(Icons.share_rounded),
                label: Text(context.t.piliersPartagerMonLienDe),
              ),
            ],
          ),
        ),
        EnTeteSection(context.t.piliersDevisesAcceptees),
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
        EnTeteSection(context.t.piliersTransfertsRecus),
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
                      context.t.piliersEnvoyesQuand(
                        d.ecrire(recu.montant),
                        recu.quand,
                      ),
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
              context.t.piliersVerseSurCompte(compte),
              icone: Icons.check_circle_rounded,
              fond: LiveColors.teinteVerte,
              couleur: LiveColors.succes,
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Etiquette(
                  context.t.piliersSurVotreSoldeLive,
                  icone: Icons.account_balance_wallet_rounded,
                  fond: LiveColors.teinteAmbre,
                  couleur: LiveColors.cuivre,
                ),
                FilledButton.icon(
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
                  onPressed: () {
                    ref.read(liveProvider.notifier).retirerTransfert(recu.id);
                    informer(
                      context,
                      context.t.piliersVersesSansFrais(fcfa(recu.fcfa), compte),
                    );
                  },
                  icon: const Icon(Icons.south_rounded),
                  label: Text(context.t.piliersRetirerEn(compte)),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
