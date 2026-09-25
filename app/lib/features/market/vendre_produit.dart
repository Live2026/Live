part of 'market_screens.dart';

/// Attributs proposés selon la catégorie (F-MKT-PUB-03).
const _attributs = <String, List<(String, List<String>)>>{
  'Téléphones': [
    ('Marque', ['Samsung', 'Apple', 'Tecno', 'Itel', 'Infinix']),
    ('Stockage', ['32 Go', '64 Go', '128 Go', '256 Go']),
  ],
  'Mode': [
    ('Taille', ['S', 'M', 'L', 'XL']),
    ('Tissu', ['Wax', 'Coton', 'Bazin', 'Cuir']),
  ],
  'Électroménager': [
    ('Marque', ['LG', 'Samsung', 'Hisense', 'Autre']),
  ],
  'Auto-moto': [
    ('Type', ['Moto', 'Pièce', 'Accessoire']),
  ],
};

/// E-PUB-03 — Vendre un produit : assistant en 6 étapes (catégorie, photos,
/// informations, prix et stock, remise et paiement, aperçu), pré-rempli par
/// Live IA, avec le gain affiché. Se termine par l'écran « Félicitations ».
class EcranVendre extends ConsumerStatefulWidget {
  const EcranVendre({super.key});

  @override
  ConsumerState<EcranVendre> createState() => _EcranVendreState();
}

class _EcranVendreState extends ConsumerState<EcranVendre> {
  static const _titres = [
    'Que vendez-vous ?',
    'Photos et vidéo',
    'Informations',
    'Prix et stock',
    'Remise et paiement',
    'Aperçu',
  ];

  var _etape = 0;
  String? _categorie;
  var _photos = 0;
  var _video = false;
  final _titre = TextEditingController();
  final _description = TextEditingController();
  final _choix = <String, String>{};
  var _etat = 'Très bon état';
  final _prix = TextEditingController();
  var _negociable = true;
  var _promo = false;
  var _ancien = 0;
  var _quantite = 1;
  var _quartier = 'Moungali';
  var _mainPropre = true;
  var _livraison = true;
  var _fraisLivraison = 2000;
  var _avanceSeulement = false;
  var _certifie = false;
  var _publie = false;

  int get _montant => int.tryParse(_prix.text.replaceAll(' ', '')) ?? 0;

  /// R-MKT-02 : pas de numéro de téléphone dans le titre ou la description.
  bool get _coordonnees =>
      RegExp(r'(\d[\s.]?){8,}').hasMatch('${_titre.text} ${_description.text}');

  bool get _valide => switch (_etape) {
    0 => _categorie != null,
    1 => _photos > 0,
    2 => _titre.text.trim().isNotEmpty && !_coordonnees,
    3 => _montant > 0,
    4 => _mainPropre || _livraison,
    _ => _certifie,
  };

  /// Mise à jour utilisable depuis les étapes définies dans vendre_etapes.dart.
  void _maj(VoidCallback f) => setState(f);

  void _suivant() {
    if (_etape < _titres.length - 1) {
      setState(() => _etape++);
      return;
    }
    ref.read(liveProvider.notifier).publier(_titre.text.trim(), _montant);
    setState(() => _publie = true);
  }

  void _rediger() => setState(() {
    if (_titre.text.trim().isEmpty) {
      _titre.text = switch (_categorie) {
        'Mode' => 'Robe wax longue, taille M',
        'Électroménager' => 'Climatiseur 1 CV, très bon état',
        _ => 'Samsung Galaxy A10 32 Go',
      };
    }
    _description.text =
        'Très bon état, fonctionne parfaitement, vendu avec ses accessoires. '
        'Remise en main propre à $_quartier ou livraison à Brazzaville.';
  });

  @override
  Widget build(BuildContext context) {
    if (_publie) return _felicitations(context);
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendre un produit'),
        actions: [
          TextButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Brouillon enregistré.')),
            ),
            child: const Text('Brouillon'),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 8, marge, 24),
        children: [
          EtapesAssistant(titres: _titres, etape: _etape),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: KeyedSubtree(key: ValueKey(_etape), child: _contenu()),
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: BoutonsAssistant(
          etape: _etape,
          derniere: _etape == _titres.length - 1,
          onRetour: () => setState(() => _etape--),
          onSuivant: _valide ? _suivant : null,
        ),
      ),
    );
  }

  Widget _contenu() => switch (_etape) {
    0 => _etapeCategorie(),
    1 => _etapePhotos(),
    2 => _etapeInfos(),
    3 => _etapePrix(),
    4 => _etapeRemise(),
    _ => _etapeApercu(),
  };

  Widget _etapeCategorie() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrilleAdaptative(
          largeurMax: 200,
          espacement: 10,
          hauteur: 96,
          enfants: [
            for (final (icone, nom) in categoriesMarket)
              _TuileChoix(
                icone: icone,
                titre: nom,
                actif: _categorie == nom,
                onTap: () => setState(() {
                  _categorie = nom;
                  _choix.clear();
                }),
              ),
          ],
        ),
        const SizedBox(height: 12),
        const Bloc(
          fond: Color(0xFFF1ECFE),
          padding: 12,
          child: Row(
            children: [
              Icon(Icons.percent_rounded, color: Color(0xFF6D28D9)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  '0 % de commission pendant 3 mois. Votre argent est garanti '
                  'avant la remise.',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _etapePhotos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: const Color(0xFFF3F5F8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: LiveColors.brume, width: 2),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _photos = (_photos + 1).clamp(0, 10)),
            child: const SizedBox(
              height: 120,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    color: LiveColors.bleu,
                    size: 30,
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Ajouter une photo',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Jusqu’à 10 photos · la première sert de couverture',
                    style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (_photos > 0)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < _photos; i++)
                Stack(
                  children: [
                    Apparition(
                      child: Vignette(
                        couleur: Colors.primaries[i * 3 % 18],
                        icone: Icons.image_rounded,
                        hauteur: 76,
                        largeur: 76,
                        rayon: 10,
                      ),
                    ),
                    if (i == 0)
                      const Positioned(
                        left: 4,
                        bottom: 4,
                        child: Etiquette('Couverture'),
                      ),
                  ],
                ),
            ],
          ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _video,
          onChanged: (v) => setState(() => _video = v),
          title: const Text('Ajouter une vidéo de 60 s'),
          subtitle: const Text(
            'Publiée aussi dans le fil avec le bouton « Acheter » : 3 fois plus de vues.',
          ),
        ),
        const Text(
          'Conseil : de près, en pleine lumière, sur un fond uni. Prototype : '
          'chaque appui ajoute une photo fictive.',
          style: TextStyle(color: LiveColors.gris, fontSize: 12.5),
        ),
      ],
    );
  }
}

/// Tuile de choix (catégorie) : icône, libellé, cadre accentué si choisie.
class _TuileChoix extends StatelessWidget {
  const _TuileChoix({
    required this.icone,
    required this.titre,
    required this.actif,
    required this.onTap,
  });
  final IconData icone;
  final String titre;
  final bool actif;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: actif,
      label: titre,
      excludeSemantics: true,
      child: Pressable(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: actif ? LiveColors.fondProtection : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: actif ? LiveColors.bleu : const Color(0xFFE4E8EE),
              width: actif ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icone, color: LiveColors.bleu),
                  const Spacer(),
                  if (actif)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: LiveColors.bleu,
                      size: 20,
                    ),
                ],
              ),
              const Spacer(),
              Text(
                titre,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
