part of 'piliers_screens.dart';

/// E-TON-02 — Une tontine : cagnotte du tour, bénéficiaire, ordre des tours,
/// qui a cotisé, cotiser, historique.
class EcranTontine extends ConsumerWidget {
  const EcranTontine({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = tontineParId(id);
    final payee = ref.watch(
      liveProvider.select((e) => e.cotisations.contains(t.id)),
    );
    final marge = context.grandEcran ? 24.0 : 16.0;
    final membres = [
      for (final (i, (nom, a)) in t.membres.indexed)
        (nom, a || (i == t.moi && payee)),
    ];
    final ont = membres.where((m) => m.$2).length;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.nom),
        actions: [
          IconButton(
            tooltip: 'Discussion du groupe',
            onPressed: () => context.push('/groupe/g1'),
            icon: const Icon(Icons.forum_outlined),
          ),
          IconButton(
            tooltip: 'Inviter',
            onPressed: () => partager(
              context,
              'Rejoins la tontine « ${t.nom} » sur Live : live.africa/t/${t.id}',
            ),
            icon: const Icon(Icons.person_add_alt_1_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 32),
        children: [
          _Banniere(
            icone: Icons.savings_rounded,
            titre: 'Cagnotte : ${fcfa(t.cagnotte)}',
            texte:
                'Tour ${t.tour + 1} sur ${t.membres.length} · pour '
                '${t.tour == t.moi ? 'vous' : t.beneficiaire} · versée '
                '${t.prochaine.toLowerCase()} à 18 h.',
            couleurs: [t.couleur, LiveColors.nuit],
            enfant: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: ont / membres.length),
                  duration: const Duration(milliseconds: 800),
                  curve: courbeDouce,
                  builder: (_, v, _) => LinearProgressIndicator(
                    value: v,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                    color: LiveColors.ambre,
                    backgroundColor: Colors.white24,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$ont / ${membres.length} cotisations reçues',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (payee)
            const Bloc(
              fond: LiveColors.teinteVerte,
              child: Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: LiveColors.succes),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text('Votre cotisation de ce tour est payée.'),
                  ),
                ],
              ),
            )
          else
            FilledButton.icon(
              onPressed: () => _payer(
                context,
                ref,
                TypePaiement.cotisation,
                t.montant,
                'Cotisation · ${t.nom}',
                t.id,
                beneficiaire: 'Tontine ${t.nom}',
              ),
              icon: const Icon(Icons.payments_rounded),
              label: Text('Cotiser ${fcfa(t.montant)}'),
            ),
          const EnTeteSection('Ordre des tours'),
          Bloc(
            padding: 0,
            child: Column(
              children: [
                for (final (i, (nom, a)) in membres.indexed)
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: i < t.tour
                          ? LiveColors.teinteVerte
                          : i == t.tour
                          ? t.couleur
                          : LiveColors.champ,
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: i == t.tour ? Colors.white : LiveColors.nuit,
                        ),
                      ),
                    ),
                    title: Text(
                      i == t.moi ? '$nom (vous)' : nom,
                      style: TextStyle(
                        fontWeight: i == t.tour ? FontWeight.w800 : null,
                      ),
                    ),
                    subtitle: Text(
                      i < t.tour
                          ? 'A reçu sa cagnotte'
                          : i == t.tour
                          ? 'Reçoit la cagnotte ce tour-ci'
                          : 'Tour ${i + 1}',
                    ),
                    trailing: Icon(
                      a ? Icons.check_circle_rounded : Icons.schedule_rounded,
                      color: a ? LiveColors.succes : LiveColors.cuivre,
                      semanticLabel: a ? 'A cotisé' : 'Pas encore cotisé',
                    ),
                  ),
              ],
            ),
          ),
          const EnTeteSection('Historique'),
          for (final (quand, texte) in [
            (
              '20 sept.',
              'Cagnotte de ${fcfa(t.cagnotte)} versée à ${t.membres[t.tour > 0 ? t.tour - 1 : 0].$1}',
            ),
            ('13 sept.', 'Tous les membres ont cotisé'),
            ('6 sept.', 'Rappel envoyé à 2 membres en retard'),
          ])
            LigneMenu(
              icone: Icons.history_rounded,
              titre: texte,
              detail: quand,
            ),
          const SizedBox(height: 8),
          const Text(
            'Live garde les cotisations sur un compte séparé et verse la '
            'cagnotte automatiquement. Frais : 1 % de la cagnotte versée.',
            style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}
