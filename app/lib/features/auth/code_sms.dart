part of 'auth_screens.dart';

/// Moyens de recevoir le code, dans l'ordre où ils se débloquent
/// (comme WhatsApp : SMS d'abord, puis appel ou WhatsApp).
enum _Canal { sms, appel, whatsapp }

extension on _Canal {
  (IconData, String, String) get infos => switch (this) {
    _Canal.sms => (
      Icons.sms_rounded,
      'Renvoyer le SMS',
      'Nouveau code par SMS',
    ),
    _Canal.appel => (
      Icons.call_rounded,
      'M’appeler',
      'Un appel automatique vous dicte le code',
    ),
    _Canal.whatsapp => (
      Icons.chat_rounded,
      'Recevoir sur WhatsApp',
      'Si WhatsApp est installé sur ce numéro',
    ),
  };
}

/// E-AUTH-03 — Code reçu par SMS : six cases, décompte avant renvoi, puis
/// appel ou WhatsApp, et « Modifier le numéro ». Le prototype accepte
/// n'importe quel code.
class EcranCode extends StatefulWidget {
  const EcranCode({
    super.key,
    required this.telephone,
    required this.operateur,
  });
  final String telephone;
  final String operateur;

  @override
  State<EcranCode> createState() => _EcranCodeState();
}

class _EcranCodeState extends State<EcranCode> {
  var _reste = 45;
  var _canal = _Canal.sms;
  var _etat = EtatCode.saisie;
  var _envois = 1;
  Timer? _minuteur;

  @override
  void initState() {
    super.initState();
    _demarrer(45);
  }

  void _demarrer(int secondes) {
    _minuteur?.cancel();
    setState(() => _reste = secondes);
    _minuteur = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_reste <= 1) t.cancel();
      setState(() => _reste--);
    });
  }

  @override
  void dispose() {
    _minuteur?.cancel();
    super.dispose();
  }

  void _renvoyer(_Canal canal) {
    setState(() {
      _canal = canal;
      _envois++;
      _etat = EtatCode.saisie;
    });
    // Chaque nouvel envoi allonge l'attente, contre les abus.
    _demarrer(45 + 15 * _envois);
    informer(context, switch (canal) {
      _Canal.sms => 'Nouveau code envoyé par SMS au ${widget.telephone}.',
      _Canal.appel => 'Appel en cours au ${widget.telephone} : décrochez.',
      _Canal.whatsapp => 'Code envoyé sur WhatsApp au ${widget.telephone}.',
    });
  }

  Future<void> _valider(String code) async {
    setState(() => _etat = EtatCode.succes);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    context.push('/profil', extra: (widget.telephone, widget.operateur));
    setState(() => _etat = EtatCode.saisie);
  }

  void _aide() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: LiveColors.surface,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Code non reçu ?',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              for (final (icone, texte) in const [
                (
                  Icons.signal_cellular_alt_rounded,
                  'Vérifiez que vous avez du réseau.',
                ),
                (Icons.dialpad_rounded, 'Vérifiez le numéro saisi.'),
                (
                  Icons.inbox_rounded,
                  'Regardez vos SMS, même ceux des numéros inconnus.',
                ),
                (
                  Icons.schedule_rounded,
                  'Le SMS peut prendre jusqu’à 2 minutes.',
                ),
              ])
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(icone, color: LiveColors.bleu),
                  title: Text(texte),
                ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.edit_rounded, color: LiveColors.bleu),
                title: const Text('Modifier le numéro'),
                onTap: () {
                  Navigator.pop(ctx);
                  context.pop();
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.support_agent_rounded,
                  color: LiveColors.bleu,
                ),
                title: const Text('Contacter l’assistance Live'),
                subtitle: const Text(
                  'Un agent répond en moins de 2 h, 7 j / 7',
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/aide/ecrire?sujet=Compte');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final attente = _reste > 0;
    final minutes =
        '${_reste ~/ 60}:${(_reste % 60).toString().padLeft(2, '0')}';
    return Scaffold(
      appBar: BarreDemarrage(
        actions: [TextButton(onPressed: _aide, child: const Text('Aide'))],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          const SizedBox(height: 8),
          const Text(
            'Vérifiez votre numéro',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: LiveColors.bleu,
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: switch (_canal) {
                    _Canal.sms => 'Code envoyé par SMS au ',
                    _Canal.appel => 'Code dicté par appel au ',
                    _Canal.whatsapp => 'Code envoyé sur WhatsApp au ',
                  },
                ),
                TextSpan(
                  text: widget.telephone,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const TextSpan(text: '. '),
              ],
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(color: LiveColors.gris, fontSize: 15),
          ),
          Center(
            child: TextButton(
              onPressed: () => context.pop(),
              child: const Text('Mauvais numéro ? Le modifier'),
            ),
          ),
          const SizedBox(height: 12),
          ChampCode(onComplet: _valider, etat: _etat, lireSms: true),
          const SizedBox(height: 10),
          const Text(
            'Prototype : tapez 6 chiffres au choix.',
            textAlign: TextAlign.center,
            style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
          ),
          const SizedBox(height: 22),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: attente
                ? Row(
                    key: const ValueKey('attente'),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          value: _reste / (45 + 15 * _envois),
                          strokeWidth: 2.5,
                          color: LiveColors.orange,
                          backgroundColor: LiveColors.voile,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          'Renvoyer le code dans $minutes',
                          style: const TextStyle(color: LiveColors.gris),
                        ),
                      ),
                    ],
                  )
                : Column(
                    key: const ValueKey('options'),
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Vous n’avez pas reçu le code ?',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      for (final (i, canal) in _Canal.values.indexed)
                        Apparition(
                          rang: i,
                          child: _OptionCanal(
                            canal: canal,
                            onTap: () => _renvoyer(canal),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _OptionCanal extends StatelessWidget {
  const _OptionCanal({required this.canal, required this.onTap});
  final _Canal canal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (icone, titre, detail) = canal.infos;
    final couleur = switch (canal) {
      _Canal.sms => LiveColors.bleu,
      _Canal.appel => LiveColors.succes,
      _Canal.whatsapp => const Color(0xFF25D366),
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: couleur.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: couleur,
                  child: Icon(icone, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titre,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        detail,
                        style: const TextStyle(
                          color: LiveColors.gris,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: LiveColors.gris),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
