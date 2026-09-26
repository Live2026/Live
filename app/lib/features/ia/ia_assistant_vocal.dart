part of 'ia_screens.dart';

/// Mode vocal de l'Assistant : on parle, Live écoute puis répond à voix
/// haute, comme au téléphone. Gratuit pour agir dans Live (F-IA2-04). En
/// sortant, l'échange s'ajoute à la conversation écrite.
class _ModeVocal extends StatefulWidget {
  const _ModeVocal({required this.langue});
  final int langue;

  @override
  State<_ModeVocal> createState() => _ModeVocalState();
}

enum _EtatVocal { ecoute, reflechit, parle }

class _ModeVocalState extends State<_ModeVocal>
    with SingleTickerProviderStateMixin {
  late final _pulsation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );
  late var _langue = widget.langue;
  var _etat = _EtatVocal.ecoute;
  var _micCoupe = false;
  String? _entendu;
  String? _reponse;
  final _echanges = <(String, String)>[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!MediaQuery.disableAnimationsOf(context)) {
      _pulsation.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulsation.dispose();
    super.dispose();
  }

  /// Simule une phrase entendue, puis la réponse de Live.
  Future<void> _entendre() async {
    if (_micCoupe || _etat != _EtatVocal.ecoute) return;
    final phrase = _langues[_langue].$2;
    setState(() {
      _entendu = phrase;
      _etat = _EtatVocal.reflechit;
    });
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    final r = _repondre(phrase);
    setState(() {
      _reponse = r.texte;
      _etat = _EtatVocal.parle;
      _echanges.add((phrase, r.texte));
    });
    await Future<void>.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;
    setState(() => _etat = _EtatVocal.ecoute);
  }

  @override
  Widget build(BuildContext context) {
    final statut = _micCoupe
        ? 'Micro coupé'
        : switch (_etat) {
            _EtatVocal.ecoute => 'Je vous écoute… touchez le cercle et parlez',
            _EtatVocal.reflechit => 'Live réfléchit…',
            _EtatVocal.parle => 'Live vous répond',
          };
    return Scaffold(
      backgroundColor: LiveColors.nuit,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Mode vocal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  PopupMenuButton<int>(
                    tooltip: 'Langue',
                    initialValue: _langue,
                    onSelected: (i) => setState(() => _langue = i),
                    itemBuilder: (_) => [
                      for (final (i, (l, _)) in _langues.indexed)
                        CheckedPopupMenuItem(
                          value: i,
                          checked: i == _langue,
                          child: Text(l),
                        ),
                    ],
                    child: Chip(
                      avatar: const Icon(Icons.translate_rounded, size: 18),
                      label: Text(_langues[_langue].$1),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Semantics(
                button: true,
                container: true,
                label: 'Parler',
                onTap: _entendre,
                excludeSemantics: true,
                child: GestureDetector(
                  onTap: _entendre,
                  child: AnimatedBuilder(
                    animation: _pulsation,
                    builder: (_, _) {
                      final v = _etat == _EtatVocal.reflechit
                          ? 0.0
                          : _pulsation.value;
                      return Container(
                        width: 170 + 30 * v,
                        height: 170 + 30 * v,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: _micCoupe
                                ? const [Color(0xFF6B7280), Color(0xFF374151)]
                                : const [
                                    LiveColors.ambre,
                                    LiveColors.orangeVif,
                                    Color(0xFF7C2D12),
                                  ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: LiveColors.orangeVif.withValues(
                                alpha: _micCoupe ? 0 : 0.25 + 0.25 * v,
                              ),
                              blurRadius: 40 + 30 * v,
                              spreadRadius: 4 + 10 * v,
                            ),
                          ],
                        ),
                        child: Icon(
                          _etat == _EtatVocal.parle
                              ? Icons.graphic_eq_rounded
                              : Icons.mic_rounded,
                          color: Colors.white,
                          size: 56,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                statut,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFFD7DCE4)),
              ),
              const SizedBox(height: 16),
              if (_entendu != null)
                Text(
                  '« $_entendu »',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              if (_reponse != null) ...[
                const SizedBox(height: 12),
                Text(
                  _reponse!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: LiveColors.ambre,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.filledTonal(
                    tooltip: _micCoupe
                        ? 'Rétablir le micro'
                        : 'Couper le micro',
                    iconSize: 30,
                    onPressed: () => setState(() => _micCoupe = !_micCoupe),
                    icon: Icon(
                      _micCoupe ? Icons.mic_off_rounded : Icons.mic_rounded,
                    ),
                  ),
                  const SizedBox(width: 32),
                  IconButton.filled(
                    tooltip: 'Terminer',
                    iconSize: 30,
                    style: IconButton.styleFrom(
                      backgroundColor: LiveColors.erreur,
                    ),
                    onPressed: () => Navigator.pop(context, _echanges),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
