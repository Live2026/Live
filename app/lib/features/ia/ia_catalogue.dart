part of 'ia_screens.dart';

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
    description: 'Assistant en 6 étapes, prévisionnel 3 ans',
    prix: 150,
    icone: Icons.account_balance,
    famille: 'Lancer mon activité',
    route: '/ia/business-plan',
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
    famille: 'Réussir à l\'école',
    route: '/ia/tuteur',
  ),
];

ServiceIa serviceParId(String id) =>
    servicesIa.firstWhere((s) => s.id == id, orElse: () => servicesIa.first);

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
