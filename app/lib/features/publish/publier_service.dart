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
  late final _titre = TextEditingController(
    text: context.t.publishNattesCollees,
  );
  final _prix = TextEditingController(text: '8000');

  @override
  Widget build(BuildContext context) {
    if (!ref.watch(liveProvider).identiteVerifiee) {
      return _PouvoirManquant(
        titre: context.t.publishProposerUnService,
        pouvoir: context.t.publishProposerSesServices,
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
                Text(
                  context.t.publishVotreServiceEstEn,
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  context.t.publishServiceEnLigneTexte(
                    _titre.text,
                    _metier,
                    _zones.join(', '),
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => context.go('/moi'),
                    child: Text(context.t.publishTerminer),
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/pro/interventions'),
                  child: Text(context.t.publishVoirMesInterventions),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(context.t.publishProposerUnService)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            context.t.publishVotreMetier,
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
            decoration: InputDecoration(
              labelText: context.t.publishNomDuService,
            ),
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: 'Prix fixe',
                label: Text(context.t.publishPrixFixe),
              ),
              ButtonSegment(
                value: 'Sur devis',
                label: Text(context.t.publishSurDevis),
              ),
            ],
            selected: {_tarif},
            onSelectionChanged: (s) => setState(() => _tarif = s.first),
          ),
          if (_tarif == 'Prix fixe') ...[
            const SizedBox(height: 12),
            TextField(
              controller: _prix,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: context.t.publishPrix,
                suffixText: 'FCFA',
              ),
            ),
          ],
          const SizedBox(height: 18),
          Text(
            context.t.publishOuIntervenezVous,
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final q in quartiersBrazzaville)
                ChoiceChip(
                  label: Text(q),
                  selected: _zones.contains(q),
                  onSelected: (v) =>
                      setState(() => v ? _zones.add(q) : _zones.remove(q)),
                ),
            ],
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(context.t.publishJeMeDeplaceA),
            value: _domicile,
            onChanged: (v) => setState(() => _domicile = v),
          ),
          const SizedBox(height: 8),
          Text(
            context.t.publishVosRealisations,
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
          ),
          Text(
            context.t.publishPhotosEtVideosDe,
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
                  texte: context.t.publishAjouter,
                  actif: false,
                  onTap: () => setState(() => _realisations++),
                ),
            ],
          ),
          const SizedBox(height: 12),
          BandeauProtection(context.t.publishVosClientsPaientUn),
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
          child: Text(context.t.publishPublierMonService),
        ),
      ),
    );
  }
}
