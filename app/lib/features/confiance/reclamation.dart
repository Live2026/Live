part of 'confiance_screens.dart';

/// E-CONF-04 — Suivi de la réclamation : frise, échanges, décision de Live.
class EcranReclamation extends ConsumerWidget {
  const EcranReclamation({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r =
        ref
            .watch(liveProvider)
            .reclamations
            .where((r) => r.id == id)
            .firstOrNull ??
        Reclamation(
          id: id,
          objet: 'iPhone 11 64 Go · Grâce Mode',
          motif: 'Produit différent de l’annonce',
          montant: 85000,
        );
    final decidee = r.etape >= 3;
    return Scaffold(
      appBar: AppBar(title: Text(context.t.confianceReclamationN(r.id))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Bloc(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.objet,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  context.t.confianceMotif(r.motif),
                  style: const TextStyle(color: LiveColors.gris),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      decidee
                          ? Icons.check_circle_rounded
                          : Icons.lock_outline_rounded,
                      size: 18,
                      color: decidee ? LiveColors.succes : LiveColors.bleu,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        decidee
                            ? context.t.confianceRemboursesMomo(fcfa(r.montant))
                            : context.t.confianceBloquesLive(fcfa(r.montant)),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Frise(
            etapes: [
              EtapeFrise(
                context.t.confianceReclamationOuverte,
                context.t.confianceAujourdHui1102,
                true,
              ),
              EtapeFrise(
                context.t.confianceReponseDuVendeur,
                r.etape >= 2
                    ? context.t.confianceJeProposeDeReprendre
                    : context.t.confianceIlAJusquA,
                r.etape >= 2,
              ),
              EtapeFrise(
                context.t.confianceDecisionDeLive,
                decidee
                    ? context.t.confianceRemboursementTotalAccorde
                    : context.t.confianceUnMediateurExamineLe,
                decidee,
              ),
            ],
          ),
          EnTeteSection(context.t.confianceEchanges),
          _Bulle(
            context.t.confianceVous,
            context.t.confianceLeTelephoneRecuN,
            true,
          ),
          if (r.etape >= 2)
            _Bulle(
              'Grâce Mode',
              context.t.confianceDesoleeErreurDeColis,
              false,
            ),
          if (decidee)
            _Bulle(
              context.t.confianceMediateurLive,
              context.t.confianceDecisionRemboursementTotalLe,
              false,
              live: true,
            ),
          const SizedBox(height: 16),
          if (!decidee)
            BoutonSimulation(
              texte: r.etape == 1
                  ? context.t.confianceSimulerLeVendeurRepond
                  : context.t.confianceSimulerLiveDecide,
              onTap: () =>
                  ref.read(liveProvider.notifier).avancerReclamation(r.id),
            ),
          if (decidee)
            FilledButton(
              onPressed: () => context.go('/moi'),
              child: Text(context.t.confianceTerminer),
            ),
        ],
      ),
    );
  }
}

class _Bulle extends StatelessWidget {
  const _Bulle(this.auteur, this.texte, this.moi, {this.live = false});
  final String auteur;
  final String texte;
  final bool moi;
  final bool live;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: moi ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: live
              ? LiveColors.voile
              : moi
              ? LiveColors.teinteVerte
              : LiveColors.champ,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              auteur,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
                color: live ? LiveColors.bleu : LiveColors.gris,
              ),
            ),
            Text(texte),
          ],
        ),
      ),
    );
  }
}
