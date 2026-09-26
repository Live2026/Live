part of 'ia_screens.dart';

/// E-IA-12 — Assistant Live : une vraie conversation, comme avec un
/// assistant IA de référence. On écrit, on dicte ou on parle en mode vocal
/// (français, lingala, kituba) ; on joint n'importe quel fichier (PDF, Word,
/// Excel, PowerPoint, texte, Markdown, image) ; Live cherche, compare,
/// réserve, paie ou lit le document.
///
/// Agir dans Live est gratuit ; lire un document coûte des crédits, avec
/// accord préalable sur le prix (F-IA-03, F-IA-07).
class EcranAssistant extends ConsumerStatefulWidget {
  const EcranAssistant({super.key});

  @override
  ConsumerState<EcranAssistant> createState() => _EcranAssistantState();
}

class _EcranAssistantState extends ConsumerState<EcranAssistant> {
  final _fil = <_Message>[];
  final _joints = <_Fichier>[];
  final _saisie = TextEditingController();
  final _defilement = ScrollController();
  var _langue = 0;
  var _reflechit = false;

  @override
  void initState() {
    super.initState();
    _saisie.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _saisie.dispose();
    _defilement.dispose();
    super.dispose();
  }

  void _enBas() => WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_defilement.hasClients) {
      _defilement.animateTo(
        _defilement.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: courbeDouce,
      );
    }
  });

  Future<void> _envoyer([String? impose]) async {
    final texte = (impose ?? _saisie.text).trim();
    final fichiers = List.of(_joints);
    if (texte.isEmpty && fichiers.isEmpty) return;
    setState(() {
      _fil.add(_Message.moi(texte, fichiers: fichiers));
      _saisie.clear();
      _joints.clear();
      _reflechit = true;
    });
    _enBas();
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _reflechit = false;
      if (fichiers.isNotEmpty) {
        for (final f in fichiers) {
          _fil.add(_Message.confirmation(f));
        }
      } else {
        _fil.add(_Message.live(_repondre(texte)));
      }
    });
    _enBas();
  }

  /// Accord sur le prix de la lecture : débit, puis réponse.
  Future<void> _lireFichier(int index, _Fichier f) async {
    final store = ref.read(liveProvider.notifier);
    if (!store.depenserCredits(f.cout)) {
      informer(context, 'Crédits insuffisants : rechargez vos crédits Live.');
      context.push('/ia/credits');
      return;
    }
    setState(() {
      _fil[index] = _Message.moi('Lire « ${f.nom} » pour ${f.cout} crédits');
      _reflechit = true;
    });
    _enBas();
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    setState(() {
      _reflechit = false;
      _fil.add(_Message.live(_lire(f)));
    });
    _enBas();
  }

  void _annulerLecture(int index) => setState(() {
    _fil[index] = const _Message.live(
      _Reponse('D’accord, je n’ai pas lu le fichier. Aucun crédit utilisé.'),
    );
  });

  void _nouvelle() => setState(() {
    _fil.clear();
    _joints.clear();
    _saisie.clear();
  });

  Future<void> _modeVocal() async {
    final echanges = await Navigator.of(context).push<List<(String, String)>>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => _ModeVocal(langue: _langue),
      ),
    );
    if (!mounted || echanges == null || echanges.isEmpty) return;
    setState(() {
      for (final (question, _) in echanges) {
        _fil
          ..add(_Message.moi(question))
          ..add(_Message.live(_repondre(question)));
      }
    });
    _enBas();
  }

  void _dicter() {
    final (langue, phrase) = _langues[_langue];
    informer(context, 'Dictée en $langue… (simulation)');
    _saisie.text = phrase;
  }

  @override
  Widget build(BuildContext context) {
    final etendu = context.taille == Taille.etendue;
    final credits = ref.watch(liveProvider.select((e) => e.credits));
    final conversation = Column(
      children: [
        Expanded(
          child: _fil.isEmpty
              ? _Accueil(onChoix: _envoyer)
              : ListView(
                  controller: _defilement,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  children: [
                    for (final (i, m) in _fil.indexed)
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 760),
                          child: _VueMessage(
                            message: m,
                            credits: credits,
                            onLire: (f) => _lireFichier(i, f),
                            onAnnuler: () => _annulerLecture(i),
                            onRegenerer: i > 0 && _fil[i - 1].moi
                                ? () => setState(
                                    () => _fil[i] = _Message.live(
                                      _repondre(_fil[i - 1].texte),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    if (_reflechit) const _Reflechit(),
                  ],
                ),
        ),
        _Saisie(
          controleur: _saisie,
          joints: _joints,
          onJoindre: (f) => setState(() => _joints.add(f)),
          onRetirer: (f) => setState(() => _joints.remove(f)),
          onEnvoyer: _envoyer,
          onDicter: _dicter,
          onVocal: _modeVocal,
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: LiveColors.teinteOrange,
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 18,
                color: LiveColors.orangeVif,
              ),
            ),
            SizedBox(width: 10),
            Flexible(
              child: Text('Assistant Live', overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        actions: [
          if (!etendu)
            IconButton(
              tooltip: 'Conversations',
              onPressed: () => _historique(context),
              icon: const Icon(Icons.history_rounded),
            ),
          IconButton(
            tooltip: 'Nouvelle conversation',
            onPressed: _nouvelle,
            icon: const Icon(Icons.edit_square),
          ),
          PopupMenuButton<int>(
            tooltip: 'Langue de la voix',
            icon: const Icon(Icons.translate_rounded),
            initialValue: _langue,
            onSelected: (i) {
              setState(() => _langue = i);
              informer(context, 'Voix en ${_langues[i].$1}.');
            },
            itemBuilder: (_) => [
              for (final (i, (langue, _)) in _langues.indexed)
                CheckedPopupMenuItem(
                  value: i,
                  checked: _langue == i,
                  child: Text(langue),
                ),
            ],
          ),
        ],
      ),
      body: etendu
          ? Row(
              children: [
                SizedBox(
                  width: 280,
                  child: _ListeConversations(onNouvelle: _nouvelle),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: conversation),
              ],
            )
          : conversation,
    );
  }

  void _historique(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: LiveColors.surface,
      builder: (ctx) => SafeArea(
        child: _ListeConversations(
          onNouvelle: () {
            Navigator.pop(ctx);
            _nouvelle();
          },
        ),
      ),
    );
  }
}

/// Premier écran : salutation et ce que l'Assistant sait faire.
class _Accueil extends ConsumerWidget {
  const _Accueil({required this.onChoix});
  final ValueChanged<String> onChoix;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prenom = ref.watch(liveProvider.select((e) => e.prenom));
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  size: 36,
                  color: LiveColors.orangeVif,
                ),
                const SizedBox(height: 12),
                Text(
                  'Bonjour $prenom, que puis-je faire pour vous ?',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Je cherche, compare, réserve et paie dans Live. Je lis aussi '
                  'vos fichiers : PDF, Word, Excel, présentations, photos.',
                  style: TextStyle(color: LiveColors.gris, height: 1.35),
                ),
                const SizedBox(height: 18),
                GrilleAdaptative(
                  largeurMax: 300,
                  espacement: 10,
                  hauteur: 108,
                  enfants: [
                    for (final (icone, titre, demande) in _suggestions)
                      Pressable(
                        onTap: () => onChoix(demande),
                        child: Bloc(
                          padding: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(icone, color: LiveColors.bleu, size: 22),
                              const Spacer(),
                              Text(
                                titre,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                demande,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: LiveColors.gris,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Conversations récentes, à gauche sur ordinateur, en panneau sur mobile.
class _ListeConversations extends StatelessWidget {
  const _ListeConversations({required this.onNouvelle});
  final VoidCallback onNouvelle;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(12),
      children: [
        FilledButton.icon(
          onPressed: onNouvelle,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Nouvelle conversation'),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(8, 16, 8, 6),
          child: Text(
            'Récentes',
            style: TextStyle(
              color: LiveColors.gris,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        for (final (titre, quand) in _conversations)
          ListTile(
            dense: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            leading: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
            title: Text(titre, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(quand),
            onTap: () => informer(context, 'Conversation « $titre » ouverte.'),
          ),
      ],
    );
  }
}
