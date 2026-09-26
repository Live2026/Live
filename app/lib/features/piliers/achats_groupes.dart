part of 'piliers_screens.dart';

/// E-TON-03 — Achats groupés : à plusieurs, le prix de gros. L'argent est
/// bloqué par Live ; si l'objectif n'est pas atteint, chacun est remboursé.
class EcranAchatsGroupes extends ConsumerWidget {
  const EcranAchatsGroupes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rejoints = ref.watch(liveProvider.select((e) => e.groupes));
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: const Text('Achats groupés')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 32),
        children: [
          const _Banniere(
            icone: Icons.groups_2_rounded,
            titre: 'Ensemble, au prix de gros',
            texte:
                'Rejoignez un achat avec votre quartier. Quand l’objectif est '
                'atteint, le grossiste livre au point relais ; sinon vous êtes '
                'remboursé automatiquement.',
            couleurs: [Color(0xFFB45309), Color(0xFFDB2777)],
          ),
          const SizedBox(height: 16),
          GrilleAdaptative(
            largeurMax: 420,
            espacement: 12,
            enfants: [
              for (final (i, a) in achatsGroupes.indexed)
                Apparition(
                  rang: i,
                  child: _CarteGroupe(
                    achat: a,
                    rejoint: rejoints.contains(a.id),
                    onRejoindre: () => _payer(
                      context,
                      ref,
                      TypePaiement.achatGroupe,
                      a.prixGroupe,
                      'Achat groupé · ${a.titre}',
                      a.id,
                      beneficiaire: a.vendeur,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CarteGroupe extends StatelessWidget {
  const _CarteGroupe({
    required this.achat,
    required this.rejoint,
    required this.onRejoindre,
  });
  final AchatGroupe achat;
  final bool rejoint;
  final VoidCallback onRejoindre;

  @override
  Widget build(BuildContext context) {
    final a = achat;
    final inscrits = a.inscrits + (rejoint ? 1 : 0);
    final economie = ((1 - a.prixGroupe / a.prix) * 100).round();
    return Bloc(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: a.couleur.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(a.icone, color: a.couleur, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.titre,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      a.vendeur,
                      style: const TextStyle(color: LiveColors.gris),
                    ),
                  ],
                ),
              ),
              Etiquette(
                '−$economie %',
                fond: LiveColors.teinteVerte,
                couleur: LiveColors.succes,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: fcfa(a.prixGroupe),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: '  '),
                TextSpan(
                  text: fcfa(a.prix),
                  style: const TextStyle(
                    color: LiveColors.gris,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: inscrits / a.objectif,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
            color: a.couleur,
            backgroundColor: LiveColors.voile,
          ),
          const SizedBox(height: 6),
          Text(
            '$inscrits / ${a.objectif} participants · ${a.fin}',
            style: const TextStyle(color: LiveColors.gris, fontSize: 12.5),
          ),
          const SizedBox(height: 10),
          if (rejoint)
            const Etiquette(
              'Vous participez · remboursé si l’objectif échoue',
              icone: Icons.check_circle_rounded,
              fond: LiveColors.teinteVerte,
              couleur: LiveColors.succes,
            )
          else
            FilledButton(
              onPressed: onRejoindre,
              child: Text('Rejoindre · ${fcfa(a.prixGroupe)}'),
            ),
        ],
      ),
    );
  }
}
