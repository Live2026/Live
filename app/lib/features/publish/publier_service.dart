part of 'publish_screen.dart';

/// E-PUB-05 — Proposer un service : métier, tarif, zone, réalisations.
class EcranProposerService extends ConsumerStatefulWidget {
  const EcranProposerService({super.key});

  @override
  ConsumerState<EcranProposerService> createState() =>
      _EcranProposerServiceState();
}

class _EcranProposerServiceState extends ConsumerState<EcranProposerService> {
  var _metier = 'Coiffure';
  var _tarif = 'Prix fixe';
  final _zones = <String>{'Moungali'};
  var _domicile = true;
  var _realisations = 0;
  var _publie = false;
  final _titre = TextEditingController(text: 'Nattes collées');
  final _prix = TextEditingController(text: '8000');

  @override
  Widget build(BuildContext context) {
    if (!ref.watch(liveProvider).identiteVerifiee) {
      return const _PouvoirManquant(
        titre: 'Proposer un service',
        pouvoir: 'Proposer ses services',
      );
    }
    if (_publie) {
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
                  'Votre service est en ligne',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_titre.text} · $_metier. Vous recevrez les demandes de devis '
                  'de ${_zones.join(', ')} directement dans Live.',
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => context.go('/moi'),
                    child: const Text('Terminer'),
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/pro/interventions'),
                  child: const Text('Voir mes interventions'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Proposer un service')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Votre métier',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (_, m) in metiers)
                ChoiceChip(
                  label: Text(m),
                  selected: _metier == m,
                  onSelected: (_) => setState(() => _metier = m),
                ),
            ],
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _titre,
            decoration: const InputDecoration(labelText: 'Nom du service'),
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: 'Prix fixe', label: Text('Prix fixe')),
              ButtonSegment(value: 'Sur devis', label: Text('Sur devis')),
            ],
            selected: {_tarif},
            onSelectionChanged: (s) => setState(() => _tarif = s.first),
          ),
          if (_tarif == 'Prix fixe') ...[
            const SizedBox(height: 12),
            TextField(
              controller: _prix,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Prix',
                suffixText: 'FCFA',
              ),
            ),
          ],
          const SizedBox(height: 18),
          const Text(
            'Où intervenez-vous ?',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final q in quartiersBrazzaville)
                FilterChip(
                  label: Text(q),
                  selected: _zones.contains(q),
                  onSelected: (v) =>
                      setState(() => v ? _zones.add(q) : _zones.remove(q)),
                ),
            ],
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Je me déplace à domicile'),
            value: _domicile,
            onChanged: (v) => setState(() => _domicile = v),
          ),
          const SizedBox(height: 8),
          const Text(
            'Vos réalisations',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
          ),
          const Text(
            'Photos et vidéos de vos travaux : c’est ce qui décide les clients.',
            style: TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 8),
          GrilleAdaptative(
            largeurMax: 110,
            espacement: 8,
            hauteur: 96,
            enfants: [
              for (var i = 0; i < _realisations; i++)
                Vignette(
                  couleur: Color.lerp(
                    const Color(0xFF86198F),
                    Colors.black,
                    i * 0.1,
                  )!,
                  icone: Icons.image_outlined,
                  rayon: 10,
                ),
              if (_realisations < 8)
                _Tuile(
                  icone: Icons.add_a_photo_outlined,
                  texte: 'Ajouter',
                  actif: false,
                  onTap: () => setState(() => _realisations++),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const BandeauProtection(
            'Vos clients paient un acompte bloqué par Live : vous êtes sûr d’être payé.',
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: _zones.isEmpty || _titre.text.trim().isEmpty
              ? null
              : () {
                  ref
                      .read(liveProvider.notifier)
                      .publierService(_titre.text.trim());
                  setState(() => _publie = true);
                },
          child: const Text('Publier mon service'),
        ),
      ),
    );
  }
}
