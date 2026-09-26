import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/format.dart';
import '../core/theme.dart';
import '../l10n/textes.dart';

/// Panneaux du bas communs : signaler, partager, options, filtres.

Future<T?> _feuille<T>(BuildContext context, Widget contenu) =>
    showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      backgroundColor: LiveColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: contenu,
      ),
    );

/// E-CONF-02 — Signaler un contenu, un profil ou un message.
Future<void> signaler(BuildContext context, String quoi, {bool immo = false}) {
  final motifs = [
    if (immo) ...[context.t.dejaLoueOuVendu, context.t.annonceFausseOuPhotos],
    context.t.arnaqueOuDemandeDe,
    context.t.produitInterditOuDangereux,
    context.t.contenuChoquantOuViolent,
    context.t.harcelementOuProposHaineux,
    context.t.autreRaison,
  ];
  return _feuille<void>(
    context,
    StatefulBuilder(
      builder: (ctx, setState) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.t.feuilleSignalerQuoi(quoi),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            context.t.votreSignalementEstAnonyme,
            style: TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 8),
          for (final m in motifs)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(m),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.t.merciSignalementEnvoyeA)),
                );
              },
            ),
        ],
      ),
    ),
  );
}

/// E-FEED-04 — Partager une annonce ou une vidéo (lien avec aperçu).
Future<void> partager(BuildContext context, String titre) {
  final cibles = [
    (Icons.chat_rounded, 'WhatsApp', Color(0xFF25D366)),
    (Icons.facebook_rounded, 'Facebook', Color(0xFF1877F2)),
    (Icons.sms_rounded, 'SMS', Color(0xFF13385C)),
    (Icons.link_rounded, context.t.copierLeLien, LiveColors.gris),
    (Icons.send_rounded, context.t.dansLive, Color(0xFFFB9618)),
  ];
  return _feuille<void>(
    context,
    Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.t.partager,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: LiveColors.champ,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.link_rounded, color: LiveColors.bleu),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titre,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      context.t.liveAfricaA8kq2,
                      style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: [
            for (final (icone, nom, couleur) in cibles)
              SizedBox(
                width: 72,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(context.t.feuillePartage(nom))),
                    );
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: couleur,
                        child: Icon(icone, color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        nom,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    ),
  );
}

/// E-FEED-05 — Options d'une publication.
Future<void> optionsPublication(BuildContext context, String auteur) {
  final options = [
    (Icons.bookmark_border_rounded, context.t.enregistrer, null),
    (Icons.visibility_off_outlined, context.t.pasInteresse, null),
    (Icons.person_off_outlined, context.t.feuilleMasquer(auteur), null),
    (Icons.flag_outlined, context.t.signaler, 'signaler'),
  ];
  return _feuille<void>(
    context,
    Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (icone, texte, action) in options)
          ListTile(
            leading: Icon(
              icone,
              color: action == null ? LiveColors.encre : LiveColors.erreur,
            ),
            title: Text(
              texte,
              style: TextStyle(
                color: action == null ? LiveColors.encre : LiveColors.erreur,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              if (action == 'signaler') {
                signaler(context, context.t.cetteVideo);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.t.feuilleNote(texte))),
                );
              }
            },
          ),
      ],
    ),
  );
}

/// E-EXP-04 — Filtres Immo : budget maximum. Renvoie 0 pour « tous ».
Future<int?> ouvrirFiltresImmo(
  BuildContext context, {
  required int? budget,
  required bool vente,
}) {
  final paliers = vente
      ? [0, 20000000, 50000000, 100000000]
      : [0, 50000, 100000, 150000, 200000];
  var choix = budget ?? 0;
  return _feuille<int>(
    context,
    StatefulBuilder(
      builder: (ctx, setState) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.t.filtres,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Text(
            vente ? context.t.prixMaximum : context.t.loyerMaximumParMois,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final p in paliers)
                ChoiceChip(
                  label: Text(
                    p == 0
                        ? context.t.tous
                        : context.t.feuilleMax(fcfaCourt(p)),
                  ),
                  selected: choix == p,
                  onSelected: (_) => setState(() => choix = p),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            context.t.equipements,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          _Bascules([
            context.t.feuilleForage,
            context.t.feuilleMeuble,
            context.t.feuilleParking,
            context.t.feuilleNonInondable,
          ]),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, choix),
            child: Text(context.t.afficherLesResultats),
          ),
        ],
      ),
    ),
  );
}

class _Bascules extends StatefulWidget {
  const _Bascules(this.options);
  final List<String> options;

  @override
  State<_Bascules> createState() => _BasculesState();
}

class _BasculesState extends State<_Bascules> {
  final _actives = <String>{};

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final o in widget.options)
          ChoiceChip(
            label: Text(o),
            selected: _actives.contains(o),
            onSelected: (v) =>
                setState(() => v ? _actives.add(o) : _actives.remove(o)),
          ),
      ],
    );
  }
}

/// Invite à débloquer un super-pouvoir avant d'utiliser une fonction (E-PUB-07).
Future<void> pouvoirRequis(
  BuildContext context, {
  required String titre,
  required String raison,
  required String route,
  required String action,
}) {
  return _feuille<void>(
    context,
    Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: const BoxDecoration(
            color: LiveColors.teinteOrange,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.bolt_rounded,
            size: 38,
            color: LiveColors.orangeVif,
          ),
        ),
        Text(
          titre,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(raison, textAlign: TextAlign.center),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.push(route);
            },
            child: Text(action),
          ),
        ),
      ],
    ),
  );
}
