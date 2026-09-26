part of 'ia_screens.dart';

/// E-IA-10 — Tuteur vocal : conversation orale facturée à la minute (phase 2).
class EcranTuteur extends ConsumerStatefulWidget {
  const EcranTuteur({super.key});

  @override
  ConsumerState<EcranTuteur> createState() => _EcranTuteurState();
}

class _EcranTuteurState extends ConsumerState<EcranTuteur>
    with SingleTickerProviderStateMixin {
  late final _pulsation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );
  var _sujet = 'Mathématiques';
  var _parle = false;
  final _echanges = <(bool, String)>[
    (
      false,
      'Bonjour Grâce ! On révise quoi aujourd’hui ? Parle-moi normalement, je t’écoute.',
    ),
  ];

  static const _reponses = [
    (true, 'Je ne comprends pas les équations du premier degré.'),
    (
      false,
      'D’accord. Une équation, c’est une balance. Si j’ajoute 3 d’un côté, je dois enlever 3 de l’autre. Essaie : 2x + 3 = 11, que fais-tu avec le 3 ?',
    ),
    (true, 'Je l’enlève des deux côtés, donc 2x = 8.'),
    (false, 'Parfait ! Et maintenant, pour trouver x ?'),
  ];

  @override
  void dispose() {
    _pulsation.dispose();
    super.dispose();
  }

  void _basculer() {
    setState(() => _parle = !_parle);
    if (_parle) {
      if (!MediaQuery.disableAnimationsOf(context)) {
        _pulsation.repeat(reverse: true);
      }
      Future<void>.delayed(const Duration(milliseconds: 1500), () {
        if (!mounted || !_parle) return;
        final suivants = _reponses.skip(_echanges.length - 1).take(2);
        setState(() {
          _echanges.addAll(suivants);
          _parle = false;
        });
        _pulsation.stop();
      });
    } else {
      _pulsation.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final credits = ref.watch(liveProvider.select((e) => e.credits));
    return Scaffold(
      backgroundColor: LiveColors.nuit,
      appBar: AppBar(
        backgroundColor: LiveColors.nuit,
        foregroundColor: Colors.white,
        title: const Text(
          'Tuteur vocal',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Credits(credits, couleur: LiveColors.surface),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                for (final s in const [
                  'Mathématiques',
                  'Français',
                  'Anglais',
                  'Entretien d’embauche',
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(s),
                      selected: _sujet == s,
                      onSelected: (_) => setState(() => _sujet = s),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final (moi, texte) in _echanges)
                  Apparition(
                    child: Align(
                      alignment: moi
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        constraints: const BoxConstraints(maxWidth: 320),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: moi
                              ? LiveColors.bleu
                              : Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          texte,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Semantics(
            button: true,
            label: _parle ? 'Arrêter de parler' : 'Parler au tuteur',
            excludeSemantics: true,
            child: GestureDetector(
              onTap: _basculer,
              child: AnimatedBuilder(
                animation: _pulsation,
                builder: (_, _) => Container(
                  width: 96 + 24 * _pulsation.value,
                  height: 96 + 24 * _pulsation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: LiveColors.orange.withValues(
                      alpha: 0.18 + 0.2 * _pulsation.value,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [LiveColors.orangeVif, LiveColors.ambre],
                      ),
                    ),
                    child: Icon(
                      _parle ? Icons.stop_rounded : Icons.mic_rounded,
                      size: 38,
                      color: LiveColors.encre,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _parle
                ? 'Je vous écoute…'
                : 'Touchez pour parler · 5 crédits / minute',
            style: const TextStyle(color: LiveColors.brume),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
