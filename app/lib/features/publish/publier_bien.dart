part of 'publish_screen.dart';

/// Écran affiché quand un super-pouvoir manque (E-PUB-07 — Vérification requise).
class _PouvoirManquant extends StatelessWidget {
  const _PouvoirManquant({required this.titre, required this.pouvoir});
  final String titre;
  final String pouvoir;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titre)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 24),
          EtatVide(
            icone: Icons.lock_outline_rounded,
            texte: context.t.publishPouvoirVerrou(pouvoir),
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: () => context.push('/verifier'),
          child: Text(context.t.publishVerifierMonIdentite),
        ),
      ),
    );
  }
}

/// E-PUB-04 — Publier un bien : assistant en 5 étapes.
class EcranPublierBien extends ConsumerStatefulWidget {
  const EcranPublierBien({super.key});

  @override
  ConsumerState<EcranPublierBien> createState() => _EcranPublierBienState();
}

class _EcranPublierBienState extends ConsumerState<EcranPublierBien> {
  var _etape = 0;
  var _vente = false;
  var _type = TypeBien.appartement;
  var _quartier = 'Moungali';
  var _loyer = 90000;
  var _avance = 3;
  var _caution = 1;
  var _commission = 1;
  var _frais = 2000;
  var _chambres = 2;
  var _douches = 1;
  var _meuble = false;
  var _parking = true;
  var _forage = true;
  var _photos = 0;
  var _video = false;
  var _publie = false;

  late final _titres = [
    context.t.publishLeBien,
    context.t.publishOu,
    context.t.publishPrix,
    context.t.publishDetails,
    context.t.publishPhotos,
  ];

  int get _entree =>
      _vente ? _loyer : _loyer * (_avance + _caution + _commission);

  bool get _valide => _etape != 4 || (_photos >= 5 && _video);

  @override
  Widget build(BuildContext context) {
    if (!ref.watch(liveProvider).identiteVerifiee) {
      return _PouvoirManquant(
        titre: context.t.publishPublierUnBien,
        pouvoir: context.t.publishLouerOuVendreUn,
      );
    }
    if (_publie) return _succes(context);
    return Scaffold(
      appBar: AppBar(title: Text(context.t.publishBienEtape(_etape + 1))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              for (var i = 0; i < 5; i++)
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: i <= _etape ? LiveColors.bleu : LiveColors.filet,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _titres[_etape],
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: KeyedSubtree(key: ValueKey(_etape), child: _contenu()),
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: Row(
          children: [
            if (_etape > 0) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _etape--),
                  child: Text(context.t.retour),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: !_valide
                    ? null
                    : () {
                        if (_etape < 4) {
                          setState(() => _etape++);
                        } else {
                          ref
                              .read(liveProvider.notifier)
                              .publierBien('${_type.libelle} · $_quartier');
                          setState(() => _publie = true);
                        }
                      },
                child: Text(
                  _etape < 4
                      ? context.t.continuer
                      : context.t.publishPublierLeBien,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contenu() {
    switch (_etape) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<bool>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: false,
                  label: Text(context.t.publishALouer),
                ),
                ButtonSegment(
                  value: true,
                  label: Text(context.t.publishAVendre),
                ),
              ],
              selected: {_vente},
              onSelectionChanged: (s) => setState(() => _vente = s.first),
            ),
            const SizedBox(height: 16),
            GrilleAdaptative(
              largeurMax: 130,
              espacement: 8,
              hauteur: 88,
              enfants: [
                for (final t in TypeBien.values)
                  _Tuile(
                    icone: t.icone,
                    texte: t.libelleDe(context.t),
                    actif: _type == t,
                    onTap: () => setState(() => _type = t),
                  ),
              ],
            ),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final q in quartiersBrazzaville)
                  ChoiceChip(
                    label: Text(q),
                    selected: _quartier == q,
                    onSelected: (_) => setState(() => _quartier = q),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: context.t.publishRepereConnu,
                hintText: context.t.publishExDerriereLeMarche,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: context.t.publishAdresseExacte,
                helperText: context.t.publishDonneeSeulementApresLe,
              ),
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Pas(
              _vente
                  ? context.t.publishPrixDeVente
                  : context.t.publishLoyerParMois,
              fcfaCourt(_loyer),
              () => setState(
                () => _loyer = (_loyer - (_vente ? 1000000 : 5000)).clamp(
                  5000,
                  1 << 31,
                ),
              ),
              () => setState(() => _loyer += _vente ? 1000000 : 5000),
            ),
            if (!_vente) ...[
              _Pas(
                context.t.publishAvance,
                context.t.publishNMois(_avance),
                () => setState(() => _avance = (_avance - 1).clamp(0, 12)),
                () => setState(() => _avance++),
              ),
              _Pas(
                context.t.publishCaution,
                context.t.publishNMois(_caution),
                () => setState(() => _caution = (_caution - 1).clamp(0, 6)),
                () => setState(() => _caution++),
              ),
              _Pas(
                context.t.publishCommission,
                context.t.publishNMois(_commission),
                () =>
                    setState(() => _commission = (_commission - 1).clamp(0, 2)),
                () =>
                    setState(() => _commission = (_commission + 1).clamp(0, 2)),
              ),
            ],
            _Pas(
              context.t.publishFraisDeVisite,
              fcfa(_frais),
              () => setState(() => _frais = (_frais - 500).clamp(0, 10000)),
              () => setState(() => _frais = (_frais + 500).clamp(0, 10000)),
            ),
            const SizedBox(height: 12),
            Bloc(
              fond: LiveColors.champ,
              child: LigneMontant(
                _vente
                    ? context.t.publishPrixAffiche
                    : context.t.publishCoutDEntreeAffiche,
                _entree,
                gras: true,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              context.t.publishLeCoutDEntree,
              style: TextStyle(color: LiveColors.gris, fontSize: 13),
            ),
          ],
        );
      case 3:
        return Column(
          children: [
            _Pas(
              context.t.publishChambres,
              '$_chambres',
              () => setState(() => _chambres = (_chambres - 1).clamp(0, 10)),
              () => setState(() => _chambres++),
            ),
            _Pas(
              context.t.publishDouches,
              '$_douches',
              () => setState(() => _douches = (_douches - 1).clamp(0, 10)),
              () => setState(() => _douches++),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.t.publishMeuble),
              value: _meuble,
              onChanged: (v) => setState(() => _meuble = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.t.publishParking),
              value: _parking,
              onChanged: (v) => setState(() => _parking = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.t.publishEauDeForage),
              value: _forage,
              onChanged: (v) => setState(() => _forage = v),
            ),
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.t.publishPhotosMin(
                _photos,
                _video ? context.t.publishVideoAjouteeSuffixe : '',
              ),
              style: const TextStyle(color: LiveColors.gris),
            ),
            const SizedBox(height: 10),
            GrilleAdaptative(
              largeurMax: 110,
              espacement: 8,
              hauteur: 96,
              enfants: [
                _Tuile(
                  icone: _video
                      ? Icons.check_circle_rounded
                      : Icons.videocam_outlined,
                  texte: _video
                      ? context.t.publishVideoAjoutee
                      : context.t.publishVideoDeVisite,
                  actif: _video,
                  onTap: () => setState(() => _video = true),
                ),
                for (var i = 0; i < _photos; i++)
                  Vignette(
                    couleur: Color.lerp(
                      const Color(0xFF166534),
                      Colors.black,
                      i * 0.1,
                    )!,
                    icone: Icons.image_outlined,
                    rayon: 10,
                  ),
                if (_photos < 12)
                  _Tuile(
                    icone: Icons.add_a_photo_outlined,
                    texte: context.t.publishAjouter,
                    actif: false,
                    onTap: () => setState(() => _photos++),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            BandeauProtection(context.t.publishLiveVerifieQueVos),
          ],
        );
    }
  }

  Widget _succes(BuildContext context) {
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
                context.t.publishBienEnvoyeEnVerification,
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                context.t.publishBienEnvoyeTexte(
                  _type.libelleDe(context.t),
                  _quartier,
                  _vente ? fcfaCourt(_loyer) : context.t.parMois(fcfa(_loyer)),
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
            ],
          ),
        ),
      ),
    );
  }
}
