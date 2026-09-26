part of 'compte_screens.dart';

const _typesEspace = [
  (
    TypeEspace.boutique,
    Icons.storefront_rounded,
    'Boutique',
    'Catalogue, vidéos, livraison',
  ),
  (
    TypeEspace.agence,
    Icons.apartment_rounded,
    'Agence immobilière',
    'Biens, agents, visites',
  ),
  (
    TypeEspace.prestataire,
    Icons.handyman_rounded,
    'Prestataire',
    'Services, devis, agenda',
  ),
  (
    TypeEspace.chaine,
    Icons.live_tv_rounded,
    'Chaîne de créateur',
    'Vidéos, fans, directs',
  ),
];

/// E-MOI-04 — Créer un espace professionnel (passage au niveau N3).
class EcranCreerEspace extends ConsumerStatefulWidget {
  const EcranCreerEspace({super.key});

  @override
  ConsumerState<EcranCreerEspace> createState() => _EcranCreerEspaceState();
}

class _EcranCreerEspaceState extends ConsumerState<EcranCreerEspace> {
  TypeEspace? _type;
  final _nom = TextEditingController(text: 'Grâce Mode Bacongo');
  final _pieces = <String>{};
  var _cree = false;

  List<String> get _justificatifs => [
    'RCCM (registre du commerce)',
    'NIU (numéro d’identification unique)',
    if (_type == TypeEspace.agence) 'Agrément d’agence immobilière',
    'Justificatif d’adresse du local',
  ];

  @override
  Widget build(BuildContext context) {
    final etat = ref.watch(liveProvider);
    if (_cree) return _succes(context);
    final pret =
        _type != null &&
        _nom.text.trim().isNotEmpty &&
        _pieces.length == _justificatifs.length;
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un espace')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!etat.identiteVerifiee) ...[
            Bloc(
              fond: LiveColors.teinteCreme,
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: LiveColors.cuivre,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Un espace pro demande d’abord la vérification de votre identité.',
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/verifier'),
                    child: const Text('Vérifier'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          const Text(
            'Quel espace ?',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          GrilleAdaptative(
            largeurMax: 200,
            espacement: 10,
            hauteur: 120,
            enfants: [
              for (final (type, icone, titre, detail) in _typesEspace)
                Semantics(
                  button: true,
                  selected: _type == type,
                  label: titre,
                  excludeSemantics: true,
                  child: Pressable(
                    onTap: () => setState(() {
                      _type = type;
                      _pieces.clear();
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _type == type
                            ? LiveColors.voile
                            : LiveColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _type == type
                              ? LiveColors.bleu
                              : LiveColors.filet,
                          width: _type == type ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(icone, color: LiveColors.bleu),
                          const Spacer(),
                          Text(
                            titre,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            detail,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: LiveColors.gris,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (_type != null) ...[
            const SizedBox(height: 20),
            TextField(
              controller: _nom,
              decoration: const InputDecoration(labelText: 'Nom de l’espace'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            const Text(
              'Justificatifs',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const Text(
              'Vérifiés par Live sous 48 h. Ils donnent droit au badge « Pro vérifié ».',
              style: TextStyle(color: LiveColors.gris),
            ),
            const SizedBox(height: 8),
            for (final j in _justificatifs)
              LigneMenu(
                icone: _pieces.contains(j)
                    ? Icons.check_circle_rounded
                    : Icons.upload_file_rounded,
                couleur: _pieces.contains(j)
                    ? LiveColors.succes
                    : LiveColors.bleu,
                titre: j,
                detail: _pieces.contains(j) ? 'Ajouté' : 'Photo ou PDF',
                onTap: () => setState(() => _pieces.add(j)),
              ),
          ],
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton(
          onPressed: pret && etat.identiteVerifiee
              ? () {
                  ref
                      .read(liveProvider.notifier)
                      .creerEspace(_nom.text.trim(), _type!);
                  setState(() => _cree = true);
                }
              : null,
          child: const Text('Créer mon espace'),
        ),
      ),
    );
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
                '${_nom.text} est créé',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Super-pouvoir débloqué : « Agence ou boutique ». Vous êtes au niveau N3 '
                '(Pro vérifié) : équipe jusqu’à 5 membres, plafonds élevés, badge.',
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.go('/moi'),
                  child: const Text('Aller à mon espace'),
                ),
              ),
              TextButton(
                onPressed: () => context.push('/espace/equipe'),
                child: const Text('Inviter mon équipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// E-MOI-05 — Équipe de l'espace : membres et rôles internes.
class EcranEquipe extends StatelessWidget {
  const EcranEquipe({super.key});

  @override
  Widget build(BuildContext context) {
    const membres = [
      ('Grâce Mabiala', 'Propriétaire', 'Tous les droits', Color(0xFF13385C)),
      (
        'Christian N.',
        'Gestionnaire',
        'Annonces, visites, messages',
        Color(0xFF166534),
      ),
      ('Mireille O.', 'Agent', 'Visites et messages', Color(0xFF7E22CE)),
      ('Junior K.', 'Agent', 'Visites et messages', Color(0xFF0369A1)),
      (
        'Estelle B.',
        'Comptable',
        'Consultation des finances',
        Color(0xFF9A3412),
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Équipe')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '5 membres sur 5 gratuits. Chaque action est journalisée : qui a publié, '
            'modifié ou remboursé.',
            style: TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 8),
          for (final (nom, role, droits, couleur) in membres)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Avatar(nom: nom, couleur: couleur, verifie: true),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nom,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          droits,
                          style: const TextStyle(
                            color: LiveColors.gris,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Etiquette(
                    role,
                    fond: LiveColors.voile,
                    couleur: LiveColors.bleu,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          const BandeauProtection(
            'Seul le propriétaire peut retirer l’argent de l’espace.',
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton.icon(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Au-delà de 5 membres : abonnement Pro Entreprise.',
              ),
            ),
          ),
          icon: const Icon(Icons.person_add_alt_1_outlined),
          label: const Text('Inviter un membre'),
        ),
      ),
    );
  }
}
