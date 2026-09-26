part of 'messages_screens.dart';

/// Un élément du fil de discussion.
sealed class _Element {
  const _Element();
}

class _Texte extends _Element {
  const _Texte(this.texte, this.heure, {this.moi = false});
  final String texte;
  final String heure;
  final bool moi;
}

class _Vocal extends _Element {
  const _Vocal(this.duree, this.heure, {this.moi = false});
  final String duree;
  final String heure;
  final bool moi;
}

class _Lieu extends _Element {
  const _Lieu(this.lieu, this.heure);
  final String lieu;
  final String heure;
}

class _Systeme extends _Element {
  const _Systeme(this.texte);
  final String texte;
}

/// E-CHAT-02 — Conversation liée à une annonce, façon WhatsApp : bulles avec
/// heure et coches, note vocale, offre et contre-offre, alerte anti-arnaque.
class EcranConversation extends StatefulWidget {
  const EcranConversation({super.key});

  @override
  State<EcranConversation> createState() => _EcranConversationState();
}

class _EcranConversationState extends State<EcranConversation> {
  final _saisie = TextEditingController();
  final _defilement = ScrollController();
  var _offreAcceptee = false;
  final _envoyes = <_Element>[];

  late final _rapides = [
    context.t.messagesToujoursDisponible,
    context.t.messagesDernierPrix,
    context.t.messagesOuSeRencontrer,
  ];

  void _envoyer(_Element e) {
    setState(() => _envoyes.add(e));
    Future<void>.delayed(const Duration(milliseconds: 80), () {
      if (_defilement.hasClients) {
        _defilement.animateTo(
          _defilement.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: courbeDouce,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vide = _saisie.text.trim().isEmpty;
    return Scaffold(
      backgroundColor: LiveColors.fondConversation,
      appBar: AppBar(
        titleSpacing: 0,
        title: InkWell(
          onTap: () => context.push('/boutique/grace'),
          child: Row(
            children: [
              Avatar(
                nom: 'Grâce Mode',
                couleur: Color(0xFFB45309),
                taille: 38,
                enLigne: true,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Grâce Mode',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    context.t.messagesEnLigneProVerifie,
                    style: TextStyle(fontSize: 12, color: LiveColors.succes),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          ...boutonsAppel(context, 'Grâce Mode'),
          IconButton(
            tooltip: context.t.messagesOptions,
            onPressed: () => _options(context),
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Material(
            color: LiveColors.surface,
            child: InkWell(
              onTap: () => context.push('/produit/p1'),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 44,
                      height: 44,
                      child: Vignette(
                        couleur: Color(0xFF334155),
                        icone: Icons.phone_iphone,
                        rayon: 8,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'iPhone 11 64 Go',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '85 000 FCFA · Moungali',
                            style: TextStyle(
                              color: LiveColors.gris,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 36),
                      ),
                      onPressed: () => context.push('/commande/p1'),
                      child: Text(context.t.messagesPayer),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: CustomPaint(
              painter: _MotifFond(),
              child: ListView(
                controller: _defilement,
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                children: [
                  _Pastille(context.t.messagesAujourdHui),
                  _Info(context.t.messagesPayezToujoursAvecLe),
                  const _BulleTexte(
                    _Texte(
                      'Bonjour, toujours disponible ?',
                      '10:12',
                      moi: true,
                    ),
                  ),
                  const _BulleTexte(
                    _Texte(
                      'Oui ! Il est comme sur les photos. Batterie 86 %.',
                      '10:14',
                    ),
                  ),
                  const _BulleVocale(_Vocal('0:12', '10:15')),
                  _CarteOffre(
                    titre: context.t.messagesOffreVousProposez75,
                    detail: context.t.messagesRefuseeParGrace,
                    moi: true,
                  ),
                  const _BulleTexte(
                    _Texte(
                      'Envoie 80 000 directement sur mon MoMo 06 999 88 77, ça ira plus vite.',
                      '10:40',
                    ),
                  ),
                  const _AlerteArnaque(),
                  _CarteOffre(
                    titre: context.t.messagesContreOffreGrace80,
                    detail: _offreAcceptee
                        ? context.t.messagesOffreAccepteeLienDe
                        : context.t.messagesValableJusquADemain,
                    action: _offreAcceptee
                        ? FilledButton(
                            onPressed: () => context.push('/commande/p1'),
                            child: Text(context.t.messagesPayer80000Fcfa),
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => _envoyer(
                                    _Systeme(
                                      context.t.messagesVousAvezRefuseLa,
                                    ),
                                  ),
                                  child: Text(context.t.messagesRefuser),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: FilledButton(
                                  onPressed: () =>
                                      setState(() => _offreAcceptee = true),
                                  child: Text(context.t.messagesAccepter),
                                ),
                              ),
                            ],
                          ),
                  ),
                  for (final e in _envoyes)
                    switch (e) {
                      _Texte() => Apparition(child: _BulleTexte(e)),
                      _Vocal() => Apparition(child: _BulleVocale(e)),
                      _Lieu() => Apparition(child: _BulleLieu(e)),
                      _Systeme() => _Info(e.texte),
                    },
                ],
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              children: [
                for (final r in _rapides)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ActionChip(
                      backgroundColor: LiveColors.surface,
                      label: Text(r),
                      onPressed: () =>
                          _envoyer(_Texte(r, 'maintenant', moi: true)),
                    ),
                  ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: LiveColors.surface,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            tooltip: context.t.messagesJoindre,
                            onPressed: () => _joindre(context),
                            icon: const Icon(
                              Icons.add_rounded,
                              color: LiveColors.gris,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _saisie,
                              minLines: 1,
                              maxLines: 4,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                hintText: context.t.messagesMessage,
                                filled: false,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: context.t.messagesPhoto,
                            onPressed: () => _envoyer(
                              _Systeme(
                                context.t.messagesPhotoEnvoyeeSimulation,
                              ),
                            ),
                            icon: const Icon(
                              Icons.photo_camera_outlined,
                              color: LiveColors.gris,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Semantics(
                    button: true,
                    label: vide
                        ? context.t.messagesNoteVocale
                        : context.t.messagesEnvoyer,
                    excludeSemantics: true,
                    child: Pressable(
                      echelle: 0.9,
                      onTap: () {
                        if (vide) {
                          _envoyer(
                            const _Vocal('0:07', 'maintenant', moi: true),
                          );
                        } else {
                          _envoyer(
                            _Texte(
                              _saisie.text.trim(),
                              'maintenant',
                              moi: true,
                            ),
                          );
                          _saisie.clear();
                          setState(() {});
                        }
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: LiveColors.bleu,
                          shape: BoxShape.circle,
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          transitionBuilder: (c, a) =>
                              ScaleTransition(scale: a, child: c),
                          child: Icon(
                            vide ? Icons.mic_rounded : Icons.send_rounded,
                            key: ValueKey(vide),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
