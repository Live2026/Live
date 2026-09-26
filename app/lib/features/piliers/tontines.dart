part of 'piliers_screens.dart';

/// E-TON-01 — Mes tontines : likelemba numérique. Cotisations en Mobile
/// Money, gardées par Live, cagnotte versée automatiquement le jour du tour.
class EcranTontines extends ConsumerWidget {
  const EcranTontines({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payees = ref.watch(liveProvider.select((e) => e.cotisations));
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: const Text('Tontines')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 32),
        children: [
          _Banniere(
            icone: Icons.diversity_3_rounded,
            titre: 'La tontine, sans cahier ni retard',
            texte:
                'Chacun cotise en Mobile Money, Live garde l’argent et verse la '
                'cagnotte au bénéficiaire le jour du tour. Tout est inscrit, '
                'personne ne peut partir avec la caisse.',
            couleurs: const [Color(0xFFDB2777), Color(0xFF7C3AED)],
            enfant: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: LiveColors.surface,
                foregroundColor: const Color(0xFF7C3AED),
                minimumSize: const Size(0, 44),
              ),
              onPressed: () => _creer(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Créer une tontine'),
            ),
          ),
          const EnTeteSection('Mes tontines'),
          GrilleAdaptative(
            largeurMax: 460,
            espacement: 12,
            enfants: [
              for (final (i, t) in tontines.indexed)
                Apparition(
                  rang: i,
                  child: _CarteTontine(
                    tontine: t,
                    payee: payees.contains(t.id),
                  ),
                ),
            ],
          ),
          const EnTeteSection('Comment ça marche'),
          for (final (icone, titre, texte) in const [
            (
              Icons.event_repeat_rounded,
              'Même somme, même jour',
              'Rappel la veille ; cotisation en un geste avec votre code MoMo.',
            ),
            (
              Icons.lock_rounded,
              'Argent gardé par Live',
              'Les cotisations sont bloquées jusqu’au versement : personne n’y touche.',
            ),
            (
              Icons.shuffle_rounded,
              'Ordre des tours clair',
              'Tirage au sort filmé dans l’application ou ordre choisi ensemble.',
            ),
            (
              Icons.gavel_rounded,
              'Retards encadrés',
              'Rappels, puis pénalité votée par le groupe ; exclusion à la majorité.',
            ),
          ])
            LigneMenu(icone: icone, titre: titre, detail: texte),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => context.push('/achats-groupes'),
            icon: const Icon(Icons.groups_2_rounded),
            label: const Text('Voir aussi les achats groupés'),
          ),
        ],
      ),
    );
  }

  void _creer(BuildContext context) {
    var montant = 10000.0;
    var semaine = true;
    var membres = 8.0;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: LiveColors.surface,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, maj) => SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(
              20,
              0,
              20,
              16 + MediaQuery.viewInsetsOf(ctx).bottom,
            ),
            children: [
              const Text(
                'Nouvelle tontine',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              const TextField(
                decoration: InputDecoration(labelText: 'Nom du groupe'),
              ),
              const SizedBox(height: 14),
              Text(
                'Cotisation : ${fcfa(montant.round())}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Slider(
                value: montant,
                min: 2000,
                max: 100000,
                divisions: 49,
                onChanged: (v) =>
                    maj(() => montant = (v / 1000).round() * 1000),
              ),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Chaque semaine')),
                  ButtonSegment(value: false, label: Text('Chaque mois')),
                ],
                selected: {semaine},
                onSelectionChanged: (v) => maj(() => semaine = v.first),
              ),
              const SizedBox(height: 14),
              Text(
                '${membres.round()} membres · cagnotte de '
                '${fcfa((montant * membres).round())} par tour',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Slider(
                value: membres,
                min: 3,
                max: 30,
                divisions: 27,
                onChanged: (v) => maj(() => membres = v),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  informer(
                    context,
                    'Tontine créée : invitez vos membres par lien WhatsApp.',
                  );
                },
                child: const Text('Créer et inviter'),
              ),
              const SizedBox(height: 6),
              const Text(
                'Frais Live : 1 % de chaque cagnotte versée. Aucun frais '
                'pour cotiser.',
                textAlign: TextAlign.center,
                style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CarteTontine extends StatelessWidget {
  const _CarteTontine({required this.tontine, required this.payee});
  final Tontine tontine;
  final bool payee;

  @override
  Widget build(BuildContext context) {
    final t = tontine;
    final ont = t.membres.where((m) => m.$2).length + (payee ? 1 : 0);
    final monTour = t.moi == t.tour;
    return Pressable(
      onTap: () => context.push('/tontine/${t.id}'),
      child: Bloc(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: t.couleur.withValues(alpha: 0.12),
                  child: Icon(Icons.diversity_3_rounded, color: t.couleur),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.nom,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${fcfa(t.montant)} · ${t.frequence}',
                        style: const TextStyle(color: LiveColors.gris),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: ont / t.membres.length,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
              color: t.couleur,
              backgroundColor: LiveColors.voile,
            ),
            const SizedBox(height: 6),
            Text(
              '$ont / ${t.membres.length} ont cotisé · tour de '
              '${monTour ? 'vous' : t.beneficiaire} · ${t.prochaine}',
              style: const TextStyle(fontSize: 12.5, color: LiveColors.gris),
            ),
            const SizedBox(height: 8),
            Etiquette(
              payee ? 'Cotisation payée' : 'À cotiser : ${fcfa(t.montant)}',
              icone: payee
                  ? Icons.check_circle_rounded
                  : Icons.schedule_rounded,
              fond: payee ? LiveColors.teinteVerte : LiveColors.teinteAmbre,
              couleur: payee ? LiveColors.succes : LiveColors.cuivre,
            ),
          ],
        ),
      ),
    );
  }
}
