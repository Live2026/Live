import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptatif.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/store.dart';
import '../../shared/animations.dart';
import '../../shared/widgets.dart';

/// Live IA : services payés en Crédits Live (docs/19, écrans E-IA-01 à E-IA-11).
/// Les résultats sont simulés : aucun appel à un fournisseur d'IA dans le prototype.

class ChampIa {
  const ChampIa(this.cle, this.libelle, {this.exemple = '', this.lignes = 1});
  final String cle;
  final String libelle;
  final String exemple;
  final int lignes;
}

class ServiceIa {
  const ServiceIa({
    required this.id,
    required this.titre,
    required this.description,
    required this.prix,
    required this.icone,
    required this.famille,
    this.champs = const [],
    this.route,
    this.disponible = true,
    this.unite = '',
  });
  final String id;
  final String titre;
  final String description;
  final int prix;
  final IconData icone;
  final String famille;
  final List<ChampIa> champs;
  final String? route;
  final bool disponible;
  final String unite;
}

const _profil = {
  'nom': 'Grâce Mabiala',
  'poste': 'Comptable',
  'ville': 'Brazzaville',
  'telephone': '06 123 45 67',
  'experiences': 'Aide-comptable, Cabinet Nkounkou & Associés, 2022-2024 : saisie, déclarations, paie de 40 salariés',
  'formation': 'BTS Comptabilité et gestion, 2021',
  'competences': 'Sage, Excel avancé, paie, fiscalité congolaise',
  'langues': 'Français, anglais (intermédiaire), lingala',
  'entreprise': 'Société Congolaise de Distribution',
};

const servicesIa = <ServiceIa>[
  ServiceIa(
    id: 'exercice',
    titre: 'Exercice par photo',
    description: 'Comprendre étape par étape',
    prix: 5,
    icone: Icons.photo_camera,
    famille: "Réussir à l'école",
    route: '/ia/exercice',
  ),
  ServiceIa(
    id: 'resume',
    titre: 'Résumer un cours',
    description: 'Photo ou PDF, en quelques points',
    prix: 5,
    icone: Icons.summarize,
    famille: "Réussir à l'école",
    disponible: false,
  ),
  ServiceIa(
    id: 'cv',
    titre: 'CV complet',
    description: 'Mis en page, PDF et Word',
    prix: 20,
    icone: Icons.badge,
    famille: 'Trouver un emploi',
    champs: [
      ChampIa('poste', 'Poste visé', exemple: 'Comptable'),
      ChampIa('nom', 'Nom complet'),
      ChampIa('telephone', 'Téléphone'),
      ChampIa('ville', 'Ville'),
      ChampIa('experiences', 'Expériences', lignes: 3),
      ChampIa('formation', 'Formation'),
      ChampIa('competences', 'Compétences'),
      ChampIa('langues', 'Langues'),
    ],
  ),
  ServiceIa(
    id: 'lettre',
    titre: 'Lettre de motivation',
    description: 'Adaptée à une offre précise',
    prix: 10,
    icone: Icons.mail,
    famille: 'Trouver un emploi',
    champs: [
      ChampIa('poste', 'Poste visé'),
      ChampIa('entreprise', 'Entreprise'),
      ChampIa('nom', 'Votre nom'),
      ChampIa('experiences', 'Votre expérience en quelques mots', lignes: 3),
    ],
  ),
  ServiceIa(
    id: 'candidature',
    titre: 'Pack candidature',
    description: 'CV + lettre + message',
    prix: 25,
    icone: Icons.work,
    famille: 'Trouver un emploi',
    disponible: false,
  ),
  ServiceIa(
    id: 'bp_express',
    titre: 'Business plan express',
    description: '5 à 6 pages, budget de démarrage',
    prix: 50,
    icone: Icons.storefront,
    famille: 'Lancer mon activité',
    champs: [
      ChampIa('activite', 'Votre activité', exemple: 'Boulangerie de quartier'),
      ChampIa('ville', 'Ville et quartier', exemple: 'Brazzaville, Moungali'),
      ChampIa(
        'clients',
        'Vos clients',
        exemple: 'Familles et petits commerces du quartier',
      ),
      ChampIa('prix', 'Prix moyen d\'une vente (FCFA)', exemple: '2500'),
      ChampIa('ventes', 'Ventes espérées par mois', exemple: '300'),
      ChampIa('apport', 'Votre apport (FCFA)', exemple: '1500000'),
    ],
  ),
  ServiceIa(
    id: 'bp_complet',
    titre: 'Business plan complet',
    description: 'Dossier + prévisionnel 3 ans',
    prix: 150,
    icone: Icons.account_balance,
    famille: 'Lancer mon activité',
    champs: [
      ChampIa('activite', 'Votre activité', exemple: 'Boulangerie de quartier'),
      ChampIa('ville', 'Ville et quartier', exemple: 'Brazzaville, Moungali'),
      ChampIa('forme', 'Forme juridique envisagée', exemple: 'SARL'),
      ChampIa(
        'clients',
        'Vos clients',
        exemple: 'Familles et petits commerces du quartier',
      ),
      ChampIa(
        'concurrents',
        'Vos concurrents',
        exemple: 'Deux boulangeries à 1 km',
      ),
      ChampIa('prix', 'Prix moyen d\'une vente (FCFA)', exemple: '2500'),
      ChampIa('ventes', 'Ventes espérées par mois', exemple: '300'),
      ChampIa('apport', 'Votre apport (FCFA)', exemple: '1500000'),
      ChampIa('pret', 'Prêt recherché (FCFA)', exemple: '3000000'),
    ],
  ),
  ServiceIa(
    id: 'vocal',
    titre: 'Tuteur vocal',
    description: 'Réviser, préparer un entretien',
    prix: 5,
    unite: '/min',
    icone: Icons.record_voice_over,
    famille: 'Bientôt',
    disponible: false,
  ),
];

ServiceIa serviceParId(String id) => servicesIa.firstWhere((s) => s.id == id);

/// Pastille « 50 ✦ » : le symbole des crédits est une icône embarquée.
class Credits extends StatelessWidget {
  const Credits(
    this.n, {
    super.key,
    this.taille = 15,
    this.couleur,
    this.couleurIcone,
    this.suffixe = '',
  });
  final int n;
  final double taille;
  final Color? couleur;
  final Color? couleurIcone;
  final String suffixe;

  @override
  Widget build(BuildContext context) {
    // Nombre en bleu nuit (lisible), symbole des crédits en orange (accent).
    final c = couleur ?? LiveColors.nuit;
    final icone = couleurIcone ?? couleur ?? LiveColors.orange;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(end: n.toDouble()),
          duration: const Duration(milliseconds: 700),
          builder: (_, v, _) => Text(
            '${v.round()}',
            style: TextStyle(
              fontSize: taille,
              fontWeight: FontWeight.bold,
              color: c,
            ),
          ),
        ),
        const SizedBox(width: 3),
        Icon(Icons.auto_awesome, size: taille + 2, color: icone),
        if (suffixe.isNotEmpty)
          Text(
            suffixe,
            style: TextStyle(fontSize: taille * 0.85, color: c),
          ),
      ],
    );
  }
}

/// E-IA-01 — Accueil Live IA.
class EcranIa extends ConsumerWidget {
  const EcranIa({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final etat = ref.watch(liveProvider);
    final familles = <String>[];
    for (final s in servicesIa) {
      if (!familles.contains(s.famille)) familles.add(s.famille);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live IA'),
        actions: const [BoutonMessages()],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: context.grandEcran ? 24 : 16,
          vertical: 8,
        ),
        children: [
          // Carte « Mes crédits » : dégradé bleu, façon carte de portefeuille.
          Apparition(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [LiveColors.bleu, LiveColors.nuit],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33041936),
                    blurRadius: 24,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 16,
                spacing: 16,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mes Crédits Live',
                        style: TextStyle(color: Color(0xCCFFFFFF)),
                      ),
                      const SizedBox(height: 4),
                      Credits(
                        etat.credits,
                        taille: 34,
                        couleur: Colors.white,
                        couleurIcone: LiveColors.orange,
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        '1 crédit = 10 FCFA · valables 12 mois',
                        style: TextStyle(
                          color: Color(0x99FFFFFF),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 44),
                      backgroundColor: Colors.white,
                      foregroundColor: LiveColors.bleu,
                    ),
                    onPressed: () => context.push('/ia/credits'),
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Acheter des crédits'),
                  ),
                ],
              ),
            ),
          ),
          for (final f in familles) ...[
            Padding(
              padding: const EdgeInsets.only(top: 18, bottom: 8),
              child: Text(
                f.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: LiveColors.gris,
                ),
              ),
            ),
            GrilleAdaptative(
              largeurMax: 380,
              hauteur: 84,
              enfants: [
                for (final s in servicesIa.where((s) => s.famille == f))
                  _CarteService(service: s),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.folder_open),
              title: const Text('Mes documents'),
              trailing: Text('${etat.documents.length}'),
              onTap: () => context.push('/ia/documents'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _CarteService extends StatelessWidget {
  const _CarteService({required this.service});
  final ServiceIa service;

  @override
  Widget build(BuildContext context) {
    final s = service;
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (!s.disponible) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  s.famille == 'Bientôt'
                      ? '${s.titre} : disponible prochainement.'
                      : '${s.titre} : non inclus dans ce prototype.',
                ),
              ),
            );
            return;
          }
          context.push(s.route ?? '/ia/service/${s.id}');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: LiveColors.fondProtection,
                child: Icon(s.icone, color: LiveColors.bleu),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.titre,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      s.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: LiveColors.gris),
                    ),
                  ],
                ),
              ),
              Credits(
                s.prix,
                suffixe: s.unite,
                couleur: s.disponible ? null : LiveColors.gris,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// E-IA-02 — Acheter des crédits.
class EcranCredits extends ConsumerStatefulWidget {
  const EcranCredits({super.key});

  @override
  ConsumerState<EcranCredits> createState() => _EcranCreditsState();
}

class _EcranCreditsState extends ConsumerState<EcranCredits> {
  var _pack = packs.first;

  @override
  Widget build(BuildContext context) {
    final etat = ref.watch(liveProvider);
    final bouton = FilledButton(
      onPressed: () {
        ref
            .read(liveProvider.notifier)
            .preparerPaiement(
              PaiementEnCours(
                type: TypePaiement.credits,
                montant: _pack.prix,
                libelle: '${_pack.credits} Crédits Live',
                beneficiaire: 'Live',
                cibleId: _pack.id,
              ),
            );
        context.push('/payer');
      },
      child: Text('Payer ${fcfa(_pack.prix)}'),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Acheter des crédits')),
      body: DeuxColonnes(
        principale: [
          Row(children: [const Text('Votre solde : '), Credits(etat.credits)]),
          const SizedBox(height: 12),
          GrilleAdaptative(
            largeurMax: 320,
            enfants: [
              for (final p in packs)
                _CartePack(
                  pack: p,
                  selectionne: _pack == p,
                  onTap: () => setState(() => _pack = p),
                ),
            ],
          ),
        ],
        secondaire: [
          const Text('Exemples', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('1 CV = 20 crédits · 1 lettre = 10 · 1 exercice = 5'),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Offrir des crédits : non inclus dans ce prototype.',
                ),
              ),
            ),
            icon: const Icon(Icons.card_giftcard),
            label: const Text('Offrir des crédits à un proche'),
          ),
          const SizedBox(height: 12),
          const Text(
            'Crédits valables 12 mois, utilisables uniquement pour Live IA. '
            'Non remboursables en argent.',
            style: TextStyle(color: LiveColors.gris),
          ),
          if (context.grandEcran) ...[const SizedBox(height: 16), bouton],
        ],
      ),
      bottomNavigationBar: context.grandEcran
          ? null
          : BarreAction(child: bouton),
    );
  }
}

/// Un pack de crédits : nombre de crédits en grand, prix et bonus dessous.
class _CartePack extends StatelessWidget {
  const _CartePack({
    required this.pack,
    required this.selectionne,
    required this.onTap,
  });
  final Pack pack;
  final bool selectionne;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selectionne,
      label: '${pack.credits} crédits pour ${fcfa(pack.prix)}',
      excludeSemantics: true,
      child: Pressable(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: courbeDouce,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selectionne ? const Color(0xFFE6EBF2) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selectionne ? LiveColors.bleu : LiveColors.brume,
              width: selectionne ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Credits(pack.credits, taille: 22),
                    ),
                  ),
                  if (selectionne)
                    const Icon(
                      Icons.check_circle,
                      size: 20,
                      color: LiveColors.bleu,
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                fcfa(pack.prix),
                style: const TextStyle(color: LiveColors.gris),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: pack.bonus == null
                      ? Colors.transparent
                      : LiveColors.succes.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  pack.bonus == null ? 'Pack de base' : 'Bonus ${pack.bonus}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: pack.bonus == null
                        ? LiveColors.gris
                        : LiveColors.succes,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// E-IA-03 — Confirmation du prix avant la génération. Renvoie vrai si les crédits ont été débités.
Future<bool> confirmerPrix(
  BuildContext context,
  WidgetRef ref,
  String titre,
  int prix,
) async {
  final solde = ref.read(liveProvider).credits;
  final suffisant = solde >= prix;
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(titre),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Ligne('Ce service coûte', prix),
          _Ligne('Votre solde', solde),
          if (suffisant) _Ligne('Après', solde - prix),
          const SizedBox(height: 12),
          Text(
            suffisant
                ? 'Une révision gratuite incluse. Recrédité si la génération échoue.'
                : 'Solde insuffisant : il vous manque ${prix - solde} crédits.',
            style: TextStyle(
              color: suffisant ? LiveColors.gris : LiveColors.erreur,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Annuler'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(140, 44)),
          onPressed: () {
            Navigator.pop(ctx, suffisant);
            if (!suffisant) context.push('/ia/credits');
          },
          child: Text(suffisant ? 'Générer' : 'Acheter des crédits'),
        ),
      ],
    ),
  );
  if (ok != true) return false;
  return ref.read(liveProvider.notifier).depenserCredits(prix);
}

class _Ligne extends StatelessWidget {
  const _Ligne(this.libelle, this.n);
  final String libelle;
  final int n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(libelle)),
          Credits(n, couleur: Colors.black87),
        ],
      ),
    );
  }
}

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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: LiveColors.bleu,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  'Rédaction en cours…',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 360,
                  child: LinearProgressIndicator(value: _progression),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Vous pouvez quitter l\'écran : vous serez prévenu quand ce sera prêt.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: LiveColors.gris),
                ),
              ],
            ),
          ),
        ),
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
    final d = ref.watch(liveProvider).documents.firstWhere((d) => d.id == id);
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
              color: Colors.white,
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
                      color: i == 0 ? Colors.black : LiveColors.bleu,
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

/// E-IA-07 et E-IA-08 — Exercice par photo, en mode apprentissage ou solution complète.
class EcranExercice extends ConsumerStatefulWidget {
  const EcranExercice({super.key});

  @override
  ConsumerState<EcranExercice> createState() => _EcranExerciceState();
}

class _EcranExerciceState extends ConsumerState<EcranExercice> {
  var _photo = false;
  var _niveau = 'Lycée';
  var _apprentissage = true;
  var _etape = -1; // -1 : saisie ; 0..2 : étapes ; 3 : fin
  String? _retour;

  static const _etapes = [
    (
      'On veut isoler x. Que faut-il faire avec le « + 3 » ?',
      ['Le soustraire des deux côtés', 'Le multiplier par 2'],
      0,
      '2x + 3 − 3 = 11 − 3, donc 2x = 8.',
    ),
    (
      'On a 2x = 8. Comment trouver x ?',
      ['Diviser les deux côtés par 2', 'Ajouter 2 des deux côtés'],
      0,
      'x = 8 ÷ 2, donc x = 4.',
    ),
    (
      'Vérifions : que vaut 2 × 4 + 3 ?',
      ['11', '10'],
      0,
      '2 × 4 + 3 = 8 + 3 = 11. La solution x = 4 est juste.',
    ),
  ];

  Future<void> _envoyer() async {
    final prix = _apprentissage ? 5 : 8;
    if (!await confirmerPrix(context, ref, 'Exercice par photo', prix)) return;
    ref.read(liveProvider.notifier).ajouterDocument(
      'exercice',
      'Exercice · Équation',
      [
        ('Résoudre 2x + 3 = 11', 'x = 4'),
        ('Méthode', 'Soustraire 3, puis diviser par 2, puis vérifier.'),
      ],
    );
    setState(() => _etape = _apprentissage ? 0 : 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_etape < 0 ? 'Exercice par photo' : 'Équation · $_niveau'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Credits(ref.watch(liveProvider).credits)),
          ),
        ],
      ),
      body: _etape < 0 ? _saisie() : _resolution(),
      bottomNavigationBar: _etape < 0 && !context.grandEcran
          ? BarreAction(child: _boutonEnvoyer())
          : null,
    );
  }

  Widget _boutonEnvoyer() => FilledButton(
    onPressed: _photo ? _envoyer : null,
    child: Text(
      _photo
          ? 'Envoyer · ${_apprentissage ? 5 : 8} crédits'
          : 'Prenez d\'abord la photo',
    ),
  );

  Widget _saisie() {
    return DeuxColonnes(
      principale: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: _photo
                  ? Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.white,
                      child: const Text(
                        'Exercice 3 : Résoudre 2x + 3 = 11',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : const Text(
                      'Cadrez l\'énoncé',
                      style: TextStyle(color: Colors.white70),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (_photo)
          const Text(
            'Photo nette · texte lisible',
            style: TextStyle(color: LiveColors.bleu),
          ),
        OutlinedButton.icon(
          onPressed: () => setState(() => _photo = true),
          icon: const Icon(Icons.photo_camera),
          label: Text(_photo ? 'Reprendre la photo' : 'Prendre la photo'),
        ),
      ],
      secondaire: [
        const Text('Niveau', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children: [
            for (final n in const ['Collège', 'Lycée', 'Université'])
              ChoiceChip(
                label: Text(n),
                selected: _niveau == n,
                onSelected: (_) => setState(() => _niveau = n),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Choix(
          titre: 'M\'aider à comprendre',
          sousTitre: 'Étape par étape, avec des questions · 5 crédits',
          selectionne: _apprentissage,
          onTap: () => setState(() => _apprentissage = true),
        ),
        Choix(
          titre: 'Solution complète',
          sousTitre: 'Solution rédigée et justifiée · 8 crédits',
          selectionne: !_apprentissage,
          onTap: () => setState(() => _apprentissage = false),
        ),
        if (context.grandEcran) ...[
          const SizedBox(height: 12),
          _boutonEnvoyer(),
        ],
      ],
    );
  }

  Widget _resolution() {
    if (_etape >= 3) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Énoncé : Résoudre 2x + 3 = 11'),
          const SizedBox(height: 16),
          for (final e in _etapes)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, color: LiveColors.bleu),
                  const SizedBox(width: 8),
                  Expanded(child: Text(e.$4)),
                ],
              ),
            ),
          const SizedBox(height: 8),
          const Text(
            'Solution : x = 4',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => context.go('/ia'),
            child: const Text('Retour à Live IA'),
          ),
        ],
      );
    }
    final (question, choix, bon, explication) = _etapes[_etape];
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('Énoncé : Résoudre 2x + 3 = 11'),
        const SizedBox(height: 16),
        Text(
          'ÉTAPE ${_etape + 1} SUR ${_etapes.length}',
          style: const TextStyle(
            color: LiveColors.bleu,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(question, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 12),
        for (final (i, c) in choix.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: OutlinedButton(
              onPressed: () => setState(
                () => _retour = i == bon
                    ? 'Bravo ! $explication'
                    : 'Pas tout à fait. $explication',
              ),
              child: Text(c),
            ),
          ),
        if (_retour != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: LiveColors.fondProtection,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(_retour!),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => setState(() {
              _etape++;
              _retour = null;
            }),
            child: Text(
              _etape + 1 < _etapes.length
                  ? 'Étape suivante'
                  : 'Voir le récapitulatif',
            ),
          ),
        ],
      ],
    );
  }
}

/// E-IA-11 — Mes documents.
class EcranMesDocuments extends ConsumerWidget {
  const EcranMesDocuments({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docs = ref.watch(liveProvider).documents;
    return Scaffold(
      appBar: AppBar(title: const Text('Mes documents')),
      body: docs.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Aucun document pour le moment. Vos CV, lettres et business plans apparaîtront ici.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                GrilleAdaptative(
                  largeurMax: 420,
                  enfants: [
                    for (final d in docs)
                      Card(
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          leading: const Icon(Icons.description),
                          title: Text(d.titre),
                          subtitle: Text(d.quand),
                          onTap: () => context.push('/ia/document/${d.id}'),
                        ),
                      ),
                  ],
                ),
              ],
            ),
    );
  }
}
