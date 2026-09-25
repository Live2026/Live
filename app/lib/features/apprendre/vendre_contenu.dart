part of 'apprendre_screens.dart';

/// E-APP-06 — Vendre un contenu : assistant en 6 étapes (type, informations,
/// fichiers, prix, aperçu gratuit, vérification).
class EcranVendreContenu extends ConsumerStatefulWidget {
  const EcranVendreContenu({super.key});

  @override
  ConsumerState<EcranVendreContenu> createState() => _EcranVendreContenuState();
}

class _EcranVendreContenuState extends ConsumerState<EcranVendreContenu> {
  static const _titres = [
    'Que vendez-vous ?',
    'Informations',
    'Fichiers',
    'Prix',
    'Aperçu gratuit',
    'Vérification',
  ];
  static const _prixProposes = [1000, 2500, 5000, 10000, 15000];

  var _etape = 0;
  var _type = TypeContenu.cours;
  final _titre = TextEditingController(
    text: 'Comptabilité pour les commerçants',
  );
  var _niveau = 'Débutant';
  final _fichiers = <String>['Leçon 1 · Bienvenue.mp4 · 38 Mo'];
  var _prix = 5000;
  var _apercu = 0;
  var _bandeAnnonce = true;
  var _droits = false;
  var _publie = false;

  bool get _valide => switch (_etape) {
    1 => _titre.text.trim().isNotEmpty,
    2 => _fichiers.isNotEmpty,
    5 => _droits,
    _ => true,
  };

  @override
  Widget build(BuildContext context) {
    if (_publie) return _succes(context);
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: const Text('Vendre un contenu')),
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
          onSuivant: !_valide
              ? null
              : () {
                  if (_etape < _titres.length - 1) {
                    setState(() => _etape++);
                  } else {
                    ref.read(liveProvider.notifier).publierContenu(_titre.text);
                    setState(() => _publie = true);
                  }
                },
        ),
      ),
    );
  }

  Widget _contenu() {
    final gain = (_prix * 0.85).round();
    return switch (_etape) {
      0 => Column(
        children: [
          for (final t in TypeContenu.values)
            Choix(
              titre: t.libelle,
              icone: t.icone,
              sousTitre: switch (t) {
                TypeContenu.cours => 'Leçons vidéo avec exercices',
                TypeContenu.pdf => 'Fiches, annales, modèles',
                TypeContenu.video => 'Une vidéo ou un tutoriel',
                TypeContenu.livre => 'ePub ou PDF',
                TypeContenu.serie => 'Épisodes courts réguliers',
                TypeContenu.qcm => 'Questions corrigées et chronométrées',
                TypeContenu.coaching => 'Séance en direct, sur rendez-vous',
              },
              selectionne: _type == t,
              onTap: () => setState(() => _type = t),
            ),
        ],
      ),
      1 => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titre,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(labelText: 'Titre'),
          ),
          const SizedBox(height: 12),
          const TextField(
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'Ce que l’élève saura faire à la fin…',
            ),
          ),
          const SizedBox(height: 12),
          const Text('Niveau', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final n in [
                'Débutant',
                'Intermédiaire',
                'Terminale',
                'Professionnel',
              ])
                ChoiceChip(
                  label: Text(n),
                  selected: _niveau == n,
                  onSelected: (_) => setState(() => _niveau = n),
                ),
            ],
          ),
        ],
      ),
      2 => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final f in _fichiers)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.insert_drive_file_outlined),
              title: Text(f),
              trailing: const Icon(
                Icons.check_circle,
                color: LiveColors.succes,
              ),
            ),
          OutlinedButton.icon(
            onPressed: () => setState(
              () => _fichiers.add(
                'Leçon ${_fichiers.length + 1} · Exercices.pdf · 2 Mo',
              ),
            ),
            icon: const Icon(Icons.upload_file_rounded),
            label: const Text('Ajouter un fichier'),
          ),
          const SizedBox(height: 10),
          const Text(
            'Vidéos, PDF, ePub, images. Live prépare une version légère pour '
            'les petits forfaits et reprend l’envoi après une coupure.',
            style: TextStyle(color: LiveColors.gris),
          ),
        ],
      ),
      3 => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final p in _prixProposes)
                ChoiceChip(
                  label: Text(fcfa(p)),
                  selected: _prix == p,
                  onSelected: (_) => setState(() => _prix = p),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Bloc(
            child: Column(
              children: [
                LigneMontant('Prix payé par l’élève', _prix),
                LigneMontant('Part de Live (15 %)', _prix - gain),
                const Divider(),
                LigneMontant('Vous recevez', gain, gras: true),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Versé sur votre solde Live à chaque vente, retirable sur MoMo '
            'ou Airtel Money.',
            style: TextStyle(color: LiveColors.gris),
          ),
        ],
      ),
      4 => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Partie offerte en aperçu'),
          const SizedBox(height: 6),
          for (final (i, f) in _fichiers.indexed)
            Choix(
              titre: f.split(' · ').take(2).join(' · '),
              selectionne: _apercu == i,
              onTap: () => setState(() => _apercu = i),
            ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _bandeAnnonce,
            onChanged: (v) => setState(() => _bandeAnnonce = v),
            title: const Text('Vidéo verticale de 30 s pour le fil'),
            subtitle: const Text(
              'Vos futurs élèves vous découvrent en défilant',
            ),
          ),
        ],
      ),
      _ => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 240,
            child: CarteContenu(
              contenu: Contenu(
                id: 'apercu',
                titre: _titre.text,
                type: _type,
                auteur: Vendeur(ref.watch(liveProvider).prenom),
                prix: _prix,
                couleur: const Color(0xFF0F766E),
                format:
                    '${_fichiers.length} fichier${_fichiers.length > 1 ? 's' : ''}',
                nouveau: true,
              ),
            ),
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: _droits,
            onChanged: (v) => setState(() => _droits = v ?? false),
            title: const Text(
              'Je suis l’auteur de ce contenu ou j’ai le droit de le vendre.',
            ),
          ),
          const Text(
            'Live vérifie chaque contenu en moins de 24 h (qualité, droits, '
            'contenu interdit) avant sa mise en vente.',
            style: TextStyle(color: LiveColors.gris),
          ),
        ],
      ),
    };
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
              const Text(
                'Contenu envoyé',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '« ${_titre.text} » est en vérification. Il sera en vente '
                'dans moins de 24 h.',
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => context.go('/apprendre/boutique'),
                child: const Text('Voir ma boutique'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
