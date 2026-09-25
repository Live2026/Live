import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptatif.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/mock.dart';
import '../../shared/animations.dart';
import '../../shared/feuilles.dart';
import '../../shared/widgets.dart';

part 'page_video.dart';
part 'commentaires.dart';

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
        const Positioned(
          top: 4,
          left: 4,
          child: SafeArea(child: BoutonNotifications(couleur: Colors.white)),
        ),
        Positioned(
          top: 56,
          left: 10,
          child: SafeArea(
            child: Semantics(
              button: true,
              label: 'Voir les directs en cours',
              excludeSemantics: true,
              child: Pressable(
                onTap: () => context.push('/directs'),
                child: PastilleDirect(
                  spectateurs: directs.where((d) => d.enCours).length,
                  libelle: 'directs',
                ),
              ),
            ),
          ),
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
        Text(
          '${pub.commentaires} commentaires',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        for (final c in commentairesDemo) LigneCommentaire(c: c),
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
        '/pro/${s.id}',
        'Devis gratuit',
      );
  }
}
