part of 'auth_screens.dart';

/// Moyens de recevoir le code, dans l'ordre où ils se débloquent
/// (comme WhatsApp : SMS d'abord, puis appel ou WhatsApp).
enum _Canal { sms, appel, whatsapp }

extension on _Canal {
  (IconData, String, String) infos(Textes t) => switch (this) {
    _Canal.sms => (Icons.sms_rounded, t.demarrageRenvoyerSms, t.demarrageNouveauCodeSms),
    _Canal.appel => (Icons.call_rounded, t.demarrageMAppeler, t.demarrageAppelDicte),
    _Canal.whatsapp => (Icons.chat_rounded, t.demarrageRecevoirWhatsapp, t.demarrageSiWhatsapp),
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
      _Canal.sms => context.t.demarrageNouveauCodeEnvoye(widget.telephone),
      _Canal.appel => context.t.demarrageAppelEnCours(widget.telephone),
      _Canal.whatsapp => context.t.demarrageCodeWhatsappEnvoye(widget.telephone),
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
              Text(
                context.t.demarrageCodeNonRecu,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              for (final (icone, texte) in [
                (Icons.signal_cellular_alt_rounded, context.t.demarrageVerifiezReseau),
                (Icons.dialpad_rounded, context.t.demarrageVerifiezNumero),
                (Icons.inbox_rounded, context.t.demarrageRegardezSms),
                (Icons.schedule_rounded, context.t.demarrageSmsDeuxMinutes),
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
                title: Text(context.t.demarrageModifierNumero),
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
                title: Text(context.t.demarrageContacterAssistance),
                subtitle: Text(context.t.demarrageAgentRepond),
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
        actions: [TextButton(onPressed: _aide, child: Text(context.t.aide))],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          const SizedBox(height: 8),
          Text(
            context.t.demarrageVerifiezVotreNumero,
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
                    _Canal.sms => context.t.demarrageCodeEnvoyeSmsA,
                    _Canal.appel => context.t.demarrageCodeDicteA,
                    _Canal.whatsapp => context.t.demarrageCodeEnvoyeWhatsappA,
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
              child: Text(context.t.demarrageMauvaisNumero),
            ),
          ),
          const SizedBox(height: 12),
          ChampCode(onComplet: _valider, etat: _etat, lireSms: true),
          const SizedBox(height: 10),
          Text(
            context.t.demarragePrototypeCode,
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
                          context.t.demarrageRenvoyerDans(minutes),
                          style: const TextStyle(color: LiveColors.gris),
                        ),
                      ),
                    ],
                  )
                : Column(
                    key: const ValueKey('options'),
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        context.t.demarragePasRecuCode,
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
    final (icone, titre, detail) = canal.infos(context.t);
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
