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
            texte:
                '« $pouvoir » est un super-pouvoir. Il se débloque quand Live '
                'a vérifié votre identité (pièce d’identité et selfie, 2 minutes). '
                'C’est ce qui rassure vos futurs clients.',
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: () => context.push('/verifier'),
          child: const Text('Vérifier mon identité'),
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

  static const _titres = ['Le bien', 'Où ?', 'Prix', 'Détails', 'Photos'];

  int get _entree =>
      _vente ? _loyer : _loyer * (_avance + _caution + _commission);

  bool get _valide => _etape != 4 || (_photos >= 5 && _video);

  @override
  Widget build(BuildContext context) {
    if (!ref.watch(liveProvider).identiteVerifiee) {
      return const _PouvoirManquant(
        titre: 'Publier un bien',
        pouvoir: 'Louer ou vendre un bien',
      );
    }
    if (_publie) return _succes(context);
    return Scaffold(
      appBar: AppBar(title: Text('Publier un bien · ${_etape + 1}/5')),
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
                      color: i <= _etape
                          ? LiveColors.bleu
                          : const Color(0xFFE4E8EE),
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
                  child: const Text('Retour'),
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
                child: Text(_etape < 4 ? 'Continuer' : 'Publier le bien'),
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
              segments: const [
                ButtonSegment(value: false, label: Text('À louer')),
                ButtonSegment(value: true, label: Text('À vendre')),
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
                    texte: t.libelle,
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
            const TextField(
              decoration: InputDecoration(
                labelText: 'Repère connu',
                hintText: 'Ex. derrière le marché Total',
              ),
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Adresse exacte',
                helperText: 'Donnée seulement après le paiement de la visite',
              ),
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Pas(
              _vente ? 'Prix de vente' : 'Loyer par mois',
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
                'Avance',
                '$_avance mois',
                () => setState(() => _avance = (_avance - 1).clamp(0, 12)),
                () => setState(() => _avance++),
              ),
              _Pas(
                'Caution',
                '$_caution mois',
                () => setState(() => _caution = (_caution - 1).clamp(0, 6)),
                () => setState(() => _caution++),
              ),
              _Pas(
                'Commission',
                '$_commission mois',
                () =>
                    setState(() => _commission = (_commission - 1).clamp(0, 2)),
                () =>
                    setState(() => _commission = (_commission + 1).clamp(0, 2)),
              ),
            ],
            _Pas(
              'Frais de visite',
              fcfa(_frais),
              () => setState(() => _frais = (_frais - 500).clamp(0, 10000)),
              () => setState(() => _frais = (_frais + 500).clamp(0, 10000)),
            ),
            const SizedBox(height: 12),
            Bloc(
              fond: const Color(0xFFF3F5F8),
              child: LigneMontant(
                _vente ? 'Prix affiché' : 'Coût d’entrée affiché',
                _entree,
                gras: true,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Le coût d’entrée est affiché en entier aux visiteurs : pas de mauvaise surprise.',
              style: TextStyle(color: LiveColors.gris, fontSize: 13),
            ),
          ],
        );
      case 3:
        return Column(
          children: [
            _Pas(
              'Chambres',
              '$_chambres',
              () => setState(() => _chambres = (_chambres - 1).clamp(0, 10)),
              () => setState(() => _chambres++),
            ),
            _Pas(
              'Douches',
              '$_douches',
              () => setState(() => _douches = (_douches - 1).clamp(0, 10)),
              () => setState(() => _douches++),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Meublé'),
              value: _meuble,
              onChanged: (v) => setState(() => _meuble = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Parking'),
              value: _parking,
              onChanged: (v) => setState(() => _parking = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Eau de forage'),
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
              'Au moins 5 photos et 1 vidéo de visite ($_photos/5 photos${_video ? ', vidéo ajoutée' : ''}).',
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
                  texte: _video ? 'Vidéo ajoutée' : 'Vidéo de visite',
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
                    texte: 'Ajouter',
                    actif: false,
                    onTap: () => setState(() => _photos++),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            const BandeauProtection(
              'Live vérifie que vos photos ne sont pas déjà utilisées ailleurs.',
            ),
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
              const Text(
                'Bien envoyé en vérification',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                '${_type.libelle} à $_quartier · ${_vente ? fcfaCourt(_loyer) : '${fcfa(_loyer)} / mois'}.\n'
                'En ligne sous 2 h après contrôle des photos. Pensez à confirmer '
                'la disponibilité tous les 30 jours.',
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
            ],
          ),
        ),
      ),
    );
  }
}

/// Tuile sélectionnable carrée (types de bien, ajout de média).
class _Tuile extends StatelessWidget {
  const _Tuile({
    required this.icone,
    required this.texte,
    required this.actif,
    required this.onTap,
  });
  final IconData icone;
  final String texte;
  final bool actif;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: actif,
      label: texte,
      excludeSemantics: true,
      child: Pressable(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: actif ? const Color(0xFFE6EBF2) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: actif ? LiveColors.bleu : const Color(0xFFE4E8EE),
              width: actif ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icone, color: LiveColors.bleu),
              const SizedBox(height: 4),
              Text(
                texte,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ligne avec boutons − et + (compteurs et montants).
class _Pas extends StatelessWidget {
  const _Pas(this.libelle, this.valeur, this.moins, this.plus);
  final String libelle;
  final String valeur;
  final VoidCallback moins;
  final VoidCallback plus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(libelle)),
          IconButton.outlined(
            tooltip: 'Moins',
            onPressed: moins,
            icon: const Icon(Icons.remove_rounded, size: 18),
          ),
          SizedBox(
            width: 104,
            child: Text(
              valeur,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          IconButton.outlined(
            tooltip: 'Plus',
            onPressed: plus,
            icon: const Icon(Icons.add_rounded, size: 18),
          ),
        ],
      ),
    );
  }
}
