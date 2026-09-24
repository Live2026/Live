import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptatif.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/mock.dart';
import '../../shared/widgets.dart';

/// E-FEED-01 / E-FEED-02 — Fil vertical, avec pastille d'annonce compacte.
class EcranFil extends StatefulWidget {
  const EcranFil({super.key});

  @override
  State<EcranFil> createState() => _EcranFilState();
}

class _EcranFilState extends State<EcranFil> {
  var _onglet = 1; // 0 Abonnements, 1 Pour toi, 2 Près de moi
  var _page = 0;

  @override
  Widget build(BuildContext context) {
    final liste = _onglet == 2
        ? publications
              .where(
                (p) => p.distance != null || p.verticale != Verticale.market,
              )
              .toList()
        : publications;
    final video = Stack(
      children: [
        PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: liste.length,
          onPageChanged: (i) => setState(() => _page = i),
          itemBuilder: (_, i) => _PageVideo(pub: liste[i]),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 48, right: 48),
            child: Center(
              heightFactor: 1,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  children: [
                    for (final (i, t) in const [
                      'Abonnements',
                      'Pour toi',
                      'Près de moi',
                    ].indexed)
                      TextButton(
                        onPressed: () => setState(() {
                          _onglet = i;
                          _page = 0;
                        }),
                        child: Text(
                          t,
                          style: TextStyle(
                            color: _onglet == i ? Colors.white : Colors.white60,
                            fontWeight: _onglet == i
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Positioned(
          top: 4,
          right: 4,
          child: SafeArea(child: BoutonMessages(couleur: Colors.white)),
        ),
      ],
    );
    if (!context.grandEcran) {
      return Scaffold(backgroundColor: Colors.black, body: video);
    }
    // Grand écran : la vidéo au format vertical à gauche, le détail de
    // l'annonce et les commentaires à droite (docs/ecrans/00, section 8).
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          Expanded(flex: 3, child: video),
          Expanded(
            flex: 2,
            child: ColoredBox(
              color: Colors.white,
              child: _PanneauAnnonce(
                pub: liste[_page.clamp(0, liste.length - 1)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Détail de l'annonce liée à la vidéo, affiché à droite sur grand écran.
class _PanneauAnnonce extends StatelessWidget {
  const _PanneauAnnonce({required this.pub});
  final Publication pub;

  @override
  Widget build(BuildContext context) {
    final (titre, prix, action, route, extra) = annonceDe(pub);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(pub.auteur, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(pub.texte),
        const Divider(height: 32),
        Text(titre, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          prix,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        if (extra != null) Text(extra),
        const SizedBox(height: 16),
        FilledButton(onPressed: () => context.push(route), child: Text(action)),
        const Divider(height: 32),
        const Text(
          'Commentaires (84)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text('Merveille'),
          subtitle: Text('Elle existe en taille M ?'),
        ),
        const ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text('Jordy'),
          subtitle: Text('Prix final ?'),
        ),
      ],
    );
  }
}

/// Titre, prix, action, route et information complémentaire de l'annonce liée.
(String, String, String, String, String?) annonceDe(Publication p) {
  switch (p.verticale) {
    case Verticale.market:
      final pr = produitParId(p.cibleId);
      return (
        pr.titre,
        fcfa(pr.prix),
        'Acheter',
        '/produit/${pr.id}',
        pr.livraison > 0 ? 'Livraison possible' : null,
      );
    case Verticale.immo:
      final b = bienParId(p.cibleId);
      return (
        '${b.titre} · ${b.quartier}',
        '${fcfa(b.loyer, devise: false)}/mois',
        'Visiter',
        '/bien/${b.id}',
        "Coût d'entrée : ${fcfa(b.coutEntree)}",
      );
    case Verticale.services:
      final s = prestataireParId(p.cibleId);
      return (
        '${s.nom} · ${s.metier}',
        note(s.note),
        'Réserver',
        '/services',
        'Devis gratuit',
      );
  }
}

class _PageVideo extends StatefulWidget {
  const _PageVideo({required this.pub});
  final Publication pub;

  @override
  State<_PageVideo> createState() => _PageVideoState();
}

class _PageVideoState extends State<_PageVideo> {
  var _carteOuverte = false;
  var _aime = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.pub;
    final (titre, prix, action, route, extra) = annonceDe(p);
    return GestureDetector(
      onDoubleTap: () => setState(() => _aime = true),
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [p.couleur, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.play_arrow_rounded,
                color: Colors.white24,
                size: 120,
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 140,
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(height: 18),
                _Action(
                  icone: _aime ? Icons.favorite : Icons.favorite_border,
                  texte: p.likes,
                  couleur: _aime ? Colors.redAccent : Colors.white,
                  onTap: () => setState(() => _aime = !_aime),
                ),
                _Action(
                  icone: Icons.chat_bubble_outline,
                  texte: '84',
                  onTap: () {},
                ),
                _Action(
                  icone: Icons.share,
                  texte: 'Partager',
                  onTap: () => _partager(context),
                ),
                _Action(
                  icone: Icons.flag_outlined,
                  texte: 'Signaler',
                  onTap: () {},
                ),
              ],
            ),
          ),
          Positioned(
            left: 12,
            right: 76,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      p.auteur,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified,
                      color: LiveColors.ambre,
                      size: 16,
                    ),
                    if (p.distance != null)
                      Text(
                        ' · ${p.distance}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(p.texte, style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 10),
                // Sur grand écran, le panneau de droite montre déjà l'annonce.
                if (!context.grandEcran)
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    child: GestureDetector(
                      onTap: () => _carteOuverte
                          ? context.push(route)
                          : setState(() => _carteOuverte = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: _carteOuverte ? 0.95 : 0.85,
                          ),
                          borderRadius: BorderRadius.circular(
                            _carteOuverte ? 12 : 30,
                          ),
                        ),
                        child: _carteOuverte
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    titre,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    prix,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  if (extra != null) Text(extra),
                                  const SizedBox(height: 8),
                                  FilledButton(
                                    style: FilledButton.styleFrom(
                                      minimumSize: const Size.fromHeight(40),
                                    ),
                                    onPressed: () => context.push(route),
                                    child: Text(action),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.local_offer, size: 18),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      '$titre · $prix',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '$action ›',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _partager(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Partager',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(Icons.chat, size: 36, color: Colors.green),
                    Text('WhatsApp'),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.facebook, size: 36, color: Colors.blue),
                    Text('Facebook'),
                  ],
                ),
                Column(children: [Icon(Icons.sms, size: 36), Text('SMS')]),
                Column(children: [Icon(Icons.link, size: 36), Text('Lien')]),
              ],
            ),
            SizedBox(height: 12),
            Text(
              "Le lien ouvre l'annonce dans Live, avec un aperçu (photo, titre, prix).",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icone,
    required this.texte,
    required this.onTap,
    this.couleur = Colors.white,
  });
  final IconData icone;
  final String texte;
  final VoidCallback onTap;
  final Color couleur;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Icon(icone, color: couleur, size: 32),
            Text(
              texte,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
