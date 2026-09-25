import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/store.dart';
import '../../shared/animations.dart';
import '../../shared/widgets.dart';

part 'reclamation.dart';

/// Objet d'une transaction à noter ou à contester, selon son type.
(String, String, int) objetTransaction(WidgetRef ref, String type, String id) {
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
        'Visite · ${v?.bien.titre ?? 'Appartement 2 chambres'}',
        v?.bien.annonceur.nom ?? 'Agence Les Palmiers',
        v?.bien.fraisVisite ?? 2000,
      );
    }(),
    _ => () {
      final p = e.prestations.where((p) => p.id == id).firstOrNull;
      return (
        'Réparation fuite',
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

  static const _pointsPositifs = [
    'Conforme aux photos',
    'Ponctuel',
    'Aimable',
    'Bon prix',
    'Bien emballé',
  ];
  static const _pointsNegatifs = [
    'Pas conforme',
    'En retard',
    'Pas joignable',
    'Trop cher',
  ];

  @override
  Widget build(BuildContext context) {
    final (objet, pour, _) = objetTransaction(ref, widget.type, widget.id);
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
                const Text(
                  'Merci pour votre avis',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  'Il aide toute la communauté à choisir $pour en confiance.',
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => context.go('/accueil'),
                    child: const Text('Terminer'),
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
      appBar: AppBar(title: const Text('Laisser un avis')),
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
            'Comment s’est passé votre échange avec $pour ?',
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
              const [
                'Touchez une étoile',
                'Très mauvais',
                'Mauvais',
                'Correct',
                'Bien',
                'Excellent',
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
                  FilterChip(
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
            decoration: const InputDecoration(
              labelText: 'Votre commentaire (facultatif)',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Seuls les clients ayant payé dans Live peuvent noter : les avis sont donc vérifiés.',
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
          child: const Text('Publier mon avis'),
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
  var _souhait = 'Remboursement total';
  final _texte = TextEditingController();

  List<String> get _motifs => switch (widget.type) {
    'commande' => [
      'Je n’ai rien reçu',
      'Produit différent de l’annonce',
      'Produit abîmé ou en panne',
      'Il manque des articles',
    ],
    'visite' => [
      'Le bien ne correspond pas',
      'L’agent n’est pas venu',
      'Le bien est déjà loué',
      'On m’a demandé de l’argent en plus',
    ],
    _ => [
      'Travail mal fait',
      'Le prestataire n’est pas venu',
      'Travail non terminé',
      'Dégâts causés',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final (objet, pour, montant) = objetTransaction(
      ref,
      widget.type,
      widget.id,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Signaler un problème')),
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
                    '$objet · $pour\n${fcfa(montant)} restent bloqués par Live pendant l’examen.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Que s’est-il passé ?',
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
            decoration: const InputDecoration(
              labelText: 'Expliquez en quelques mots',
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Preuves',
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
          const Text(
            'Ce que vous demandez',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final s in const [
                'Remboursement total',
                'Remboursement partiel',
                'Échange ou reprise',
              ])
                ChoiceChip(
                  label: Text(s),
                  selected: _souhait == s,
                  onSelected: (_) => setState(() => _souhait = s),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const BandeauProtection(
            'L’autre partie a 48 h pour répondre. Sinon, Live décide sur la base de vos preuves.',
          ),
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
          child: const Text('Envoyer ma réclamation'),
        ),
      ),
    );
  }
}
