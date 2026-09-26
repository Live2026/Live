part of 'ia_screens.dart';

/// E-IA-04 à E-IA-06 — Générateur commun (CV, lettre, business plans).
class EcranGenerateur extends ConsumerStatefulWidget {
  const EcranGenerateur({super.key, required this.serviceId});
  final String serviceId;

  @override
  ConsumerState<EcranGenerateur> createState() => _EcranGenerateurState();
}

class _EcranGenerateurState extends ConsumerState<EcranGenerateur> {
  late final ServiceIa _service = serviceParId(widget.serviceId);
  late final Map<String, TextEditingController> _champs = {
    for (final c in _service.champs)
      c.cle: TextEditingController(text: c.exemple),
  };
  var _enCours = false;
  var _progression = 0.0;

  void _remplirProfil() {
    setState(() {
      for (final e in _champs.entries) {
        final v = _profil[e.key];
        if (v != null) e.value.text = v;
      }
    });
  }

  String _v(String cle, [String defaut = '']) {
    final t = _champs[cle]?.text.trim() ?? '';
    return t.isEmpty ? (_profil[cle] ?? defaut) : t;
  }

  Future<void> _generer() async {
    if (!await confirmerPrix(context, ref, _service.titre, _service.prix)) {
      return;
    }
    setState(() => _enCours = true);
    for (var i = 1; i <= 10; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 220));
      if (!mounted) return;
      setState(() => _progression = i / 10);
    }
    final id = ref
        .read(liveProvider.notifier)
        .ajouterDocument(_service.id, _titreDocument(), _resultat());
    if (mounted) context.pushReplacement('/ia/document/$id');
  }

  String _titreDocument() => switch (_service.id) {
    'cv' => 'CV · ${_v('poste')}',
    'lettre' => 'Lettre · ${_v('entreprise')}',
    _ => 'Business plan · ${_v('activite')}',
  };

  /// Résultat simulé, construit à partir des réponses (le vrai service appelle le fournisseur d'IA).
  List<(String, String)> _resultat() {
    switch (_service.id) {
      case 'cv':
        return [
          (
            _v('nom').toUpperCase(),
            '${_v('poste')} · ${_v('ville')} · ${_v('telephone')}',
          ),
          (
            'Profil',
            '${_v('poste')} rigoureuse et organisée, avec une expérience confirmée en cabinet. '
                'Habituée aux échéances fiscales et sociales, je sais fiabiliser les comptes et '
                'accompagner la direction dans ses décisions.',
          ),
          ('Expérience', _v('experiences')),
          ('Formation', _v('formation')),
          ('Compétences', _v('competences')),
          ('Langues', _v('langues')),
        ];
      case 'lettre':
        return [
          ('Objet', 'Candidature au poste de ${_v('poste')}'),
          (
            'Madame, Monsieur,',
            'Votre entreprise, ${_v('entreprise')}, est une référence à Brazzaville. '
                'Je souhaite mettre mon expérience au service de vos équipes en tant que ${_v('poste')}.\n\n'
                '${_v('experiences')}. Cette expérience m\'a appris la rigueur, le respect des délais '
                'et le sens du service.\n\n'
                'Je serais heureuse de vous rencontrer pour vous présenter ma motivation. '
                'Je vous prie d\'agréer, Madame, Monsieur, mes salutations distinguées.',
          ),
          ('Signature', _v('nom')),
        ];
      default:
        final prix = int.tryParse(_v('prix', '2500')) ?? 2500;
        final ventes = int.tryParse(_v('ventes', '300')) ?? 300;
        final ca = prix * ventes;
        final complet = _service.id == 'bp_complet';
        return [
          (
            'Résumé du projet',
            '${_v('activite')} à ${_v('ville')}. Clients : ${_v('clients').toLowerCase()}. '
                'Chiffre d\'affaires visé : ${fcfa(ca)} par mois.',
          ),
          (
            'Marché',
            'Demande locale régulière, peu d\'offre de qualité à proximité. '
                '${complet ? 'Concurrence : ${_v('concurrents')}. ' : ''}'
                'Avantage recherché : fraîcheur, prix accessibles, livraison dans le quartier.',
          ),
          (
            'Offre et prix',
            'Prix moyen d\'une vente : ${fcfa(prix)}. Objectif : $ventes ventes par mois.',
          ),
          (
            'Budget de démarrage',
            'Apport personnel : ${fcfa(int.tryParse(_v('apport', '0')) ?? 0)}'
                '${complet ? '\nPrêt recherché : ${fcfa(int.tryParse(_v('pret', '0')) ?? 0)}' : ''}\n'
                'Postes principaux : équipement, stock de départ, local, fonds de roulement.',
          ),
          if (complet) ...[
            (
              'Forme juridique',
              '${_v('forme')} de droit congolais (OHADA), immatriculée au RCCM.',
            ),
            (
              'Prévisionnel sur 3 ans',
              'Année 1 : ${fcfa(ca * 12)} de chiffre d\'affaires\n'
                  'Année 2 : ${fcfa((ca * 12 * 1.2).round())}\n'
                  'Année 3 : ${fcfa((ca * 12 * 1.4).round())}',
            ),
          ],
          (
            'Avertissement',
            'Document d\'aide à la préparation : vérifiez les chiffres et faites-le relire '
                'par un professionnel avant tout engagement.',
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _service;
    if (_enCours) {
      return Scaffold(
        appBar: AppBar(title: Text(s.titre)),
        body: EtapesGeneration(progression: _progression),
      );
    }
    final bouton = FilledButton.icon(
      onPressed: _generer,
      icon: const Icon(Icons.auto_awesome),
      label: Text('Générer · ${s.prix} crédits'),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(s.titre),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Credits(ref.watch(liveProvider).credits)),
          ),
        ],
      ),
      body: DeuxColonnes(
        principale: [
          if (s.id == 'cv' || s.id == 'lettre')
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(minimumSize: const Size(0, 44)),
                onPressed: _remplirProfil,
                icon: const Icon(Icons.person),
                label: const Text('Remplir avec mon profil Live'),
              ),
            ),
          const SizedBox(height: 12),
          GrilleAdaptative(
            largeurMax: 420,
            enfants: [
              for (final c in s.champs)
                TextField(
                  controller: _champs[c.cle],
                  maxLines: c.lignes,
                  decoration: InputDecoration(labelText: c.libelle),
                ),
            ],
          ),
          if (s.id == 'cv' || s.id == 'lettre')
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'L\'IA reformule vos informations ; elle n\'invente ni expérience ni diplôme.',
                style: TextStyle(color: LiveColors.gris),
              ),
            ),
        ],
        secondaire: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Vous obtiendrez',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(s.description),
                  const Text('Export PDF et Word · une révision gratuite'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Prix : '),
                      Credits(s.prix),
                      Text(
                        '  (${fcfa(s.prix * 10)})',
                        style: const TextStyle(color: LiveColors.gris),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (s.id.startsWith('bp'))
            const BoutonEcouter(
              'Répondez simplement aux questions sur votre projet. Live IA rédige ensuite un dossier '
              'que vous pourrez modifier, télécharger et présenter à une banque ou à un partenaire. '
              'Vérifiez toujours les chiffres avant de vous engager.',
            ),
          if (context.grandEcran) ...[const SizedBox(height: 12), bouton],
        ],
      ),
      bottomNavigationBar: context.grandEcran
          ? null
          : BarreAction(child: bouton),
    );
  }
}

/// E-IA-06 — Document généré.
class EcranDocument extends ConsumerWidget {
  const EcranDocument({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = ref
        .watch(liveProvider)
        .documents
        .firstWhere(
          (d) => d.id == id,
          // Ouverture directe (démonstration) : CV d'exemple.
          orElse: () => DocumentIa(
            id: id,
            type: 'cv',
            titre: 'CV · Comptable',
            contenu: [
              (
                'Profil',
                'Comptable rigoureuse, 3 ans d’expérience en cabinet.',
              ),
              ('Expérience', _profil['experiences']!),
              ('Formation', _profil['formation']!),
              ('Compétences', _profil['competences']!),
            ],
            quand: "à l'instant",
          ),
        );
    void simule(String quoi) => ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$quoi (simulé dans le prototype)')));
    final actions = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilledButton.icon(
          style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
          onPressed: () => simule('Téléchargement du PDF'),
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text('Télécharger PDF'),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48)),
          onPressed: () => simule('Téléchargement Word'),
          child: const Text('Word'),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48)),
          onPressed: () => simule('Partage'),
          child: const Text('Partager'),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48)),
          onPressed: () => simule('Révision gratuite'),
          child: const Text('Révision gratuite'),
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(title: Text(d.titre)),
      body: DeuxColonnes(
        ratio: 2,
        principale: [
          const Text(
            'Document prêt',
            style: TextStyle(
              color: LiveColors.bleu,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: LiveColors.surface,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(color: Color(0x14000000), blurRadius: 12),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (i, (titre, texte)) in d.contenu.indexed) ...[
                  Text(
                    i == 0 ? titre : titre.toUpperCase(),
                    style: TextStyle(
                      fontSize: i == 0 ? 22 : 13,
                      fontWeight: FontWeight.bold,
                      color: i == 0 ? LiveColors.encre : LiveColors.bleu,
                      letterSpacing: i == 0 ? 0 : 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(texte, style: const TextStyle(height: 1.45)),
                  const SizedBox(height: 14),
                ],
              ],
            ),
          ),
        ],
        secondaire: [
          actions,
          const SizedBox(height: 12),
          const Text(
            'Généré avec Live IA : relisez avant d\'envoyer. Le document est conservé dans « Mes documents ».',
            style: TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => context.go('/ia'),
            child: const Text('Retour à Live IA'),
          ),
        ],
      ),
    );
  }
}
