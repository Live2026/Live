import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/store.dart';
import '../../shared/animations.dart';
import '../../shared/widgets.dart';
import '../../l10n/textes.dart';

part 'reclamation.dart';

/// Objet d'une transaction à noter ou à contester, selon son type.
(String, String, int) objetTransaction(
  Textes t,
  WidgetRef ref,
  String type,
  String id,
) {
  final e = ref.read(liveProvider);
  return switch (type) {
    'commande' => () {
      final c = e.achats.where((c) => c.id == id).firstOrNull;
      return (
        c?.produit.titre ?? 'iPhone 11 64 Go',
        c?.produit.vendeur.nom ?? 'Grâce Mode',
        c?.total ?? 85000,
      );
    }(),
    'visite' => () {
      final v = e.visites.where((v) => v.id == id).firstOrNull;
      return (
        t.confianceVisiteDe(v?.bien.titre ?? t.confianceAppartement2Chambres),
        v?.bien.annonceur.nom ?? 'Agence Les Palmiers',
        v?.bien.fraisVisite ?? 2000,
      );
    }(),
    _ => () {
      final p = e.prestations.where((p) => p.id == id).firstOrNull;
      return (
        t.confianceReparationFuite,
        p?.devis.prestataire.nom ?? 'Serge',
        p?.devis.total ?? 25000,
      );
    }(),
  };
}

/// E-CONF-01 — Laisser un avis (uniquement après une transaction payée).
class EcranAvis extends ConsumerStatefulWidget {
  const EcranAvis({super.key, required this.type, required this.id});
  final String type;
  final String id;

  @override
  ConsumerState<EcranAvis> createState() => _EcranAvisState();
}

class _EcranAvisState extends ConsumerState<EcranAvis> {
  var _note = 0;
  final _points = <String>{};
  final _texte = TextEditingController();
  var _envoye = false;

  late final _pointsPositifs = [
    context.t.confianceConformeAuxPhotos,
    context.t.confiancePonctuel,
    context.t.confianceAimable,
    context.t.confianceBonPrix,
    context.t.confianceBienEmballe,
  ];
  late final _pointsNegatifs = [
    context.t.confiancePasConforme,
    context.t.confianceEnRetard,
    context.t.confiancePasJoignable,
    context.t.confianceTropCher,
  ];

  @override
  Widget build(BuildContext context) {
    final (objet, pour, _) = objetTransaction(
      context.t,
      ref,
      widget.type,
      widget.id,
    );
    if (_envoye) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                const CocheAnimee(taille: 96),
                const SizedBox(height: 12),
                Text(
                  context.t.confianceMerciPourVotreAvis,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  context.t.confianceAideCommunaute(pour),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => context.go('/accueil'),
                    child: Text(context.t.confianceTerminer),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    final points = _note >= 4 || _note == 0 ? _pointsPositifs : _pointsNegatifs;
    return Scaffold(
      appBar: AppBar(title: Text(context.t.confianceLaisserUnAvis)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Avatar(
              nom: pour,
              couleur: LiveColors.bleu,
              taille: 64,
              verifie: true,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.t.confianceCommentEchange(pour),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          Text(
            objet,
            textAlign: TextAlign.center,
            style: const TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 16),
          SelecteurEtoiles(
            note: _note,
            onChange: (n) => setState(() => _note = n),
          ),
          Center(
            child: Text(
              [
                context.t.confianceTouchezUneEtoile,
                context.t.confianceTresMauvais,
                context.t.confianceMauvais,
                context.t.confianceCorrect,
                context.t.confianceBien,
                context.t.confianceExcellent,
              ][_note],
              style: const TextStyle(color: LiveColors.gris),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Wrap(
              key: ValueKey(points.first),
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                for (final p in points)
                  ChoiceChip(
                    label: Text(p),
                    selected: _points.contains(p),
                    onSelected: (v) =>
                        setState(() => v ? _points.add(p) : _points.remove(p)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _texte,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: context.t.confianceVotreCommentaireFacultatif,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.t.confianceSeulsLesClientsAyant,
            style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: _note == 0
              ? null
              : () {
                  ref
                      .read(liveProvider.notifier)
                      .donnerAvis('${widget.type}-${widget.id}');
                  setState(() => _envoye = true);
                },
          child: Text(context.t.confiancePublierMonAvis),
        ),
      ),
    );
  }
}

/// E-CONF-03 — Signaler un problème sur une commande, une visite ou une prestation.
class EcranProbleme extends ConsumerStatefulWidget {
  const EcranProbleme({super.key, required this.type, required this.id});
  final String type;
  final String id;

  @override
  ConsumerState<EcranProbleme> createState() => _EcranProblemeState();
}

class _EcranProblemeState extends ConsumerState<EcranProbleme> {
  String? _motif;
  var _photos = 0;
  late var _souhait = context.t.confianceRemboursementTotal;
  final _texte = TextEditingController();

  List<String> get _motifs => switch (widget.type) {
    'commande' => [
      context.t.confianceJeNAiRien,
      context.t.confianceProduitDifferentDeL,
      context.t.confianceProduitAbimeOuEn,
      context.t.confianceIlManqueDesArticles,
    ],
    'visite' => [
      context.t.confianceLeBienNeCorrespond,
      context.t.confianceLAgentNEst,
      context.t.confianceLeBienEstDeja,
      context.t.confianceOnMADemande,
    ],
    _ => [
      context.t.confianceTravailMalFait,
      context.t.confianceLePrestataireNEst,
      context.t.confianceTravailNonTermine,
      context.t.confianceDegatsCauses,
    ],
  };

  @override
  Widget build(BuildContext context) {
    final (objet, pour, montant) = objetTransaction(
      context.t,
      ref,
      widget.type,
      widget.id,
    );
    return Scaffold(
      appBar: AppBar(title: Text(context.t.confianceSignalerUnProbleme)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Bloc(
            child: Row(
              children: [
                const Icon(Icons.lock_outline_rounded, color: LiveColors.bleu),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.t.confianceObjetBloques(objet, pour, fcfa(montant)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.t.confianceQueSEstIl,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          for (final m in _motifs)
            Choix(
              titre: m,
              selectionne: _motif == m,
              onTap: () => setState(() => _motif = m),
            ),
          const SizedBox(height: 8),
          TextField(
            controller: _texte,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: context.t.confianceExpliquezEnQuelquesMots,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.t.confiancePreuves,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var i = 0; i < _photos; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: Vignette(
                      couleur: const Color(0xFF475569),
                      icone: Icons.image_outlined,
                      rayon: 8,
                    ),
                  ),
                ),
              if (_photos < 4)
                SizedBox(
                  width: 64,
                  height: 64,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () => setState(() => _photos++),
                    child: const Icon(Icons.add_a_photo_outlined),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            context.t.confianceCeQueVousDemandez,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final s in [
                context.t.confianceRemboursementTotal,
                context.t.confianceRemboursementPartiel,
                context.t.confianceEchangeOuReprise,
              ])
                ChoiceChip(
                  label: Text(s),
                  selected: _souhait == s,
                  onSelected: (_) => setState(() => _souhait = s),
                ),
            ],
          ),
          const SizedBox(height: 16),
          BandeauProtection(context.t.confianceLAutrePartieA),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: _motif == null
              ? null
              : () {
                  final id = ref
                      .read(liveProvider.notifier)
                      .ouvrirReclamation('$objet · $pour', _motif!, montant);
                  context.pushReplacement('/reclamation/$id');
                },
          child: Text(context.t.confianceEnvoyerMaReclamation),
        ),
      ),
    );
  }
}
