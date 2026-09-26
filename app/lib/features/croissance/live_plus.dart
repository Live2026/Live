part of 'croissance_screens.dart';

/// E-IA-12 — Live Plus (phase 2, document 19 §3.2) : abonnement mensuel
/// avec des Crédits Live inclus. Proposé en fidélisation, jamais imposé.
class EcranLivePlus extends ConsumerStatefulWidget {
  const EcranLivePlus({super.key});

  @override
  ConsumerState<EcranLivePlus> createState() => _EcranLivePlusState();
}

class _EcranLivePlusState extends ConsumerState<EcranLivePlus> {
  var _formule = 'eleve';

  late final _formules = [
    (
      'eleve',
      context.t.croissanceLivePlusEleve,
      1500,
      200,
      [
        context.t.croissanceN200CreditsChaqueMois,
        context.t.croissanceExercicesEnModeApprentissage,
        context.t.croissanceIdealPourLeBac,
      ],
    ),
    (
      'pro',
      'Live Plus Pro',
      3500,
      500,
      [
        context.t.croissanceN500CreditsChaqueMois,
        context.t.croissancePrioriteDeGeneration,
        context.t.croissanceModelesDeDocumentsPremium,
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final etat = ref.watch(liveProvider);
    final marge = context.grandEcran ? 24.0 : 16.0;
    final choisie = _formules.firstWhere((f) => f.$1 == _formule);
    return Scaffold(
      appBar: AppBar(title: Text(context.t.croissanceLivePlus)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 32),
        children: [
          Text(
            context.t.croissanceVosCreditsLiveIa,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            etat.formulePlus == null
                ? context.t.croissanceSoldeActuel(etat.credits)
                : context.t.croissanceFormuleActive(
                    etat.formulePlus == 'pro'
                        ? 'Live Plus Pro'
                        : context.t.croissanceLivePlusEleve,
                  ),
            style: const TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 16),
          GrilleAdaptative(
            largeurMax: 420,
            espacement: 12,
            enfants: [
              for (final (id, nom, prix, credits, avantages) in _formules)
                Pressable(
                  onTap: () => setState(() => _formule = id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: _formule == id
                          ? const LinearGradient(
                              colors: [LiveColors.bleu, LiveColors.nuit],
                            )
                          : null,
                      color: _formule == id ? null : LiveColors.surface,
                      border: Border.all(
                        color: _formule == id
                            ? LiveColors.bleu
                            : LiveColors.filet,
                      ),
                    ),
                    child: DefaultTextStyle.merge(
                      style: TextStyle(
                        color: _formule == id ? Colors.white : LiveColors.encre,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  nom,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              if (id == 'pro')
                                Etiquette(
                                  context.t.croissanceLePlusComplet,
                                  fond: LiveColors.orangeVif,
                                  couleur: Colors.white,
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: fcfa(prix),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                TextSpan(text: context.t.croissanceParMois),
                              ],
                            ),
                          ),
                          Text(
                            context.t.croissancePrixCredit(
                              (prix * 10 / credits)
                                  .toStringAsFixed(1)
                                  .replaceAll('.', ','),
                            ),
                            style: TextStyle(
                              fontSize: 12.5,
                              color: _formule == id
                                  ? LiveColors.ambreClair
                                  : LiveColors.succes,
                            ),
                          ),
                          const SizedBox(height: 10),
                          for (final a in avantages)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    size: 18,
                                    color: _formule == id
                                        ? LiveColors.ambreClair
                                        : LiveColors.succes,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(a)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            context.t.croissanceSansEngagementArretezQuand,
            style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: () => _payer(
            context,
            ref,
            TypePaiement.livePlus,
            choisie.$3,
            context.t.croissanceUnMois(choisie.$2),
            choisie.$1,
          ),
          child: Text(context.t.croissanceSabonner(fcfa(choisie.$3))),
        ),
      ),
    );
  }
}
