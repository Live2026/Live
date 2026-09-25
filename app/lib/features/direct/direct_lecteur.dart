part of 'direct_screens.dart';

/// Un message du direct : commentaire ou cadeau reçu.
class _Evenement {
  const _Evenement(this.auteur, this.texte, {this.cadeau});
  final String auteur;
  final String texte;
  final Cadeau? cadeau;
}

const _commentairesDemo = [
  _Evenement('Merveille K.', 'La robe bleue existe en M ?'),
  _Evenement('Jordy M.', 'Bonsoir depuis Talangaï'),
  _Evenement('Nadège L.', 'J’ai reçu la mienne hier, top !'),
  _Evenement('Prince B.', 'Livraison à Ouenzé possible ?'),
  _Evenement('Merveille K.', 'Je prends le pagne !'),
];

/// E-DIR-02 — Regarder un direct, plein écran : hôte, spectateurs,
/// commentaires qui défilent, produit épinglé payable dans Live, cadeaux,
/// cœurs qui montent. Le créateur reçoit 75 % des cadeaux.
class EcranDirect extends ConsumerStatefulWidget {
  const EcranDirect({super.key, required this.id});
  final String id;

  @override
  ConsumerState<EcranDirect> createState() => _EcranDirectState();
}

class _EcranDirectState extends ConsumerState<EcranDirect> {
  final _evenements = <_Evenement>[..._commentairesDemo.take(3)];
  final _coeurs = <int>[];
  final _saisie = TextEditingController();
  Timer? _minuteur;
  var _suivant = 3;
  var _produit = 0;
  Cadeau? _grandCadeau;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _minuteur?.cancel();
    if (!MediaQuery.of(context).disableAnimations) {
      // Le direct vit : un nouveau commentaire toutes les 3 secondes.
      _minuteur = Timer.periodic(const Duration(seconds: 3), (_) {
        if (!mounted) return;
        setState(() {
          _evenements.add(
            _commentairesDemo[_suivant % _commentairesDemo.length],
          );
          _suivant++;
        });
      });
    }
  }

  @override
  void dispose() {
    _minuteur?.cancel();
    super.dispose();
  }

  void _aimer() {
    if (MediaQuery.of(context).disableAnimations) return;
    final id = DateTime.now().microsecondsSinceEpoch;
    setState(() => _coeurs.add(id));
    Future<void>.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _coeurs.remove(id));
    });
  }

  void _cadeauEnvoye(Cadeau c) {
    setState(() {
      _evenements.add(_Evenement('Vous', 'a envoyé ${c.nom}', cadeau: c));
      _grandCadeau = c;
    });
    Future<void>.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) setState(() => _grandCadeau = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final d = directParId(widget.id);
    final suivi = ref.watch(
      liveProvider.select((e) => e.suivis.contains(d.hote.id)),
    );
    final epingles = [for (final id in d.produits) produitParId(id)];
    final ecran = Stack(
      fit: StackFit.expand,
      children: [
        Vignette(couleur: d.couleur, icone: Icons.videocam_rounded, rayon: 0),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0x66000000),
                Colors.transparent,
                Color(0xB3000000),
              ],
              stops: [0, 0.4, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 6, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(4, 4, 6, 4),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Avatar(
                              nom: d.hote.nom,
                              couleur: d.hote.couleur,
                              taille: 34,
                              verifie: true,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    d.hote.nom,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    '${compact(d.hote.abonnes)} abonnés',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            if (!suivi)
                              FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFFFE2C55),
                                  minimumSize: const Size(0, 30),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                ),
                                onPressed: () => ref
                                    .read(liveProvider.notifier)
                                    .basculerSuivi(d.hote.id),
                                child: const Text('Suivre'),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  PastilleDirect(spectateurs: d.spectateurs),
                  IconButton(
                    tooltip: 'Quitter le direct',
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Cœurs qui montent à droite.
        for (final id in _coeurs) _CoeurVolant(key: ValueKey(id)),
        if (_grandCadeau != null)
          Center(child: _GrandCadeau(cadeau: _grandCadeau!)),
        Positioned(
          right: 8,
          bottom: 150,
          child: Column(
            children: [
              _ActionDirect(
                icone: Icons.favorite_rounded,
                libelle: 'J’aime',
                onTap: _aimer,
              ),
              _ActionDirect(
                icone: Icons.card_giftcard_rounded,
                libelle: 'Cadeau',
                couleur: LiveColors.ambre,
                onTap: () => _ouvrirCadeaux(context, ref, d, _cadeauEnvoye),
              ),
              _ActionDirect(
                icone: Icons.ios_share_rounded,
                libelle: 'Partager',
                onTap: () => partager(context, d.titre),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FilCommentaires(evenements: _evenements),
                  const SizedBox(height: 8),
                  if (epingles.isNotEmpty)
                    _ProduitEpingle(
                      produit: epingles[_produit % epingles.length],
                      nombre: epingles.length,
                      onSuivant: () => setState(() => _produit++),
                    )
                  else if (d.bien != null)
                    _BienEpingle(bien: bienParId(d.bien!)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _saisie,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Commenter…',
                            hintStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white24,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                          ),
                          onSubmitted: (t) {
                            if (t.trim().isEmpty) return;
                            setState(
                              () =>
                                  _evenements.add(_Evenement('Vous', t.trim())),
                            );
                            _saisie.clear();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: context.grandEcran
          ? Center(
              child: AspectRatio(aspectRatio: 9 / 16, child: ecran),
            )
          : ecran,
    );
  }
}
