part of 'croissance_screens.dart';

/// E-PUB-08 — Publicité (bêta, phase 2) : une vidéo sponsorisée dans le fil,
/// ciblée par ville, quartier et centre d'intérêt, avec budget et portée
/// estimée. Toujours marquée « Sponsorisé ».
class EcranPublicite extends ConsumerStatefulWidget {
  const EcranPublicite({super.key});

  @override
  ConsumerState<EcranPublicite> createState() => _EcranPubliciteState();
}

class _EcranPubliciteState extends ConsumerState<EcranPublicite> {
  var _objectif = 'Ventes';
  final _quartiers = <String>{'Moungali', 'Poto-Poto'};
  final _interets = <String>{'Mode'};
  var _budget = 10000.0;
  var _jours = 3;

  @override
  Widget build(BuildContext context) {
    final campagnes = ref.watch(liveProvider.select((e) => e.publicites));
    final marge = context.grandEcran ? 24.0 : 16.0;
    final budget = (_budget / 1000).round() * 1000;
    final portee = (budget / 1000 * 900 * (1 + _quartiers.length / 4)).round();
    return Scaffold(
      appBar: AppBar(title: const Text('Publicité')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 4, marge, 32),
        children: [
          if (campagnes.isNotEmpty) ...[
            const EnTeteSection('Mes campagnes'),
            for (final c in campagnes)
              LigneMenu(
                icone: Icons.campaign_rounded,
                titre: c,
                detail: 'En vérification · diffusion sous 2 h',
                couleur: LiveColors.cuivre,
              ),
          ],
          const EnTeteSection('Votre publicité'),
          Row(
            children: [
              const SizedBox(
                width: 90,
                height: 150,
                child: Vignette(
                  couleur: Color(0xFFB45309),
                  icone: Icons.play_arrow_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nouvel arrivage de robes en wax',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const Text(
                      'Vidéo publiée il y a 2 jours',
                      style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
                    ),
                    const SizedBox(height: 6),
                    const Etiquette(
                      'Sponsorisé',
                      fond: Color(0xFFE6EBF2),
                      couleur: LiveColors.bleu,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: () => context.push('/publier/media'),
                      child: const Text('Choisir une autre vidéo'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const EnTeteSection('Objectif'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final o in const [
                'Ventes',
                'Visites de la boutique',
                'Abonnés',
                'Messages',
              ])
                ChoiceChip(
                  label: Text(o),
                  selected: _objectif == o,
                  onSelected: (_) => setState(() => _objectif = o),
                ),
            ],
          ),
          const EnTeteSection('Qui la voit'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final q in quartiersBrazzaville)
                ChoiceChip(
                  label: Text(q),
                  selected: _quartiers.contains(q),
                  onSelected: (v) => setState(
                    () => v ? _quartiers.add(q) : _quartiers.remove(q),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (_, c) in categoriesMarket.take(6))
                ChoiceChip(
                  label: Text(c),
                  selected: _interets.contains(c),
                  onSelected: (v) => setState(
                    () => v ? _interets.add(c) : _interets.remove(c),
                  ),
                ),
            ],
          ),
          const EnTeteSection('Budget et durée'),
          Text(
            fcfa(budget),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          Slider(
            value: _budget,
            min: 2000,
            max: 50000,
            divisions: 48,
            label: fcfa(budget),
            onChanged: (v) => setState(() => _budget = v),
          ),
          Wrap(
            spacing: 8,
            children: [
              for (final j in const [1, 3, 7, 14])
                ChoiceChip(
                  label: Text('$j jour${j > 1 ? 's' : ''}'),
                  selected: _jours == j,
                  onSelected: (_) => setState(() => _jours = j),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [LiveColors.bleu, LiveColors.nuit],
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.groups_rounded,
                  color: LiveColors.ambreClair,
                  size: 34,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Portée estimée',
                        style: TextStyle(color: Colors.white70),
                      ),
                      ChiffreAnime(
                        valeur: portee,
                        format: (n) => '${fcfa(n, devise: false)} personnes',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'sur $_jours jour${_jours > 1 ? 's' : ''} · objectif : ${_objectif.toLowerCase()}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: _quartiers.isEmpty
              ? null
              : () => _payer(
                  context,
                  ref,
                  TypePaiement.publicite,
                  budget,
                  'Campagne « $_objectif » · $_jours j',
                  'pub',
                ),
          child: Text('Lancer la campagne · ${fcfa(budget)}'),
        ),
      ),
    );
  }
}
