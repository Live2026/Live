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

List<ServiceIa> servicesIa(Textes t) => [
  ServiceIa(
    id: 'exercice',
    titre: t.iaExerciceParPhoto,
    description: t.iaComprendreEtapeParEtape,
    prix: 5,
    icone: Icons.photo_camera,
    famille: t.iaReussirALEcole,
    route: '/ia/exercice',
  ),
  ServiceIa(
    id: 'resume',
    titre: t.iaResumerUnCours,
    description: t.iaPhotoOuPdfEn,
    prix: 5,
    icone: Icons.summarize,
    famille: t.iaReussirALEcole,
    disponible: false,
  ),
  ServiceIa(
    id: 'cv',
    titre: t.iaCvComplet,
    description: t.iaMisEnPagePdf,
    prix: 20,
    icone: Icons.badge,
    famille: t.iaTrouverUnEmploi,
    champs: [
      ChampIa('poste', t.iaPosteVise, exemple: 'Comptable'),
      ChampIa('nom', t.iaNomComplet),
      ChampIa('telephone', t.iaTelephone),
      ChampIa('ville', t.iaVille),
      ChampIa('experiences', t.iaExperiences, lignes: 3),
      ChampIa('formation', t.iaFormation),
      ChampIa('competences', t.iaCompetences),
      ChampIa('langues', t.iaLangues),
    ],
  ),
  ServiceIa(
    id: 'lettre',
    titre: t.iaLettreDeMotivation,
    description: t.iaAdapteeAUneOffre,
    prix: 10,
    icone: Icons.mail,
    famille: t.iaTrouverUnEmploi,
    champs: [
      ChampIa('poste', t.iaPosteVise),
      ChampIa('entreprise', t.iaEntreprise),
      ChampIa('nom', t.iaVotreNom),
      ChampIa('experiences', t.iaVotreExperienceEnQuelques, lignes: 3),
    ],
  ),
  ServiceIa(
    id: 'candidature',
    titre: t.iaPackCandidature,
    description: t.iaCvLettreMessage,
    prix: 25,
    icone: Icons.work,
    famille: t.iaTrouverUnEmploi,
    disponible: false,
  ),
  ServiceIa(
    id: 'bp_express',
    titre: t.iaBusinessPlanExpress,
    description: t.iaN5A6Pages,
    prix: 50,
    icone: Icons.storefront,
    famille: t.iaLancerMonActivite,
    champs: [
      ChampIa(
        'activite',
        t.iaVotreActivite,
        exemple: t.iaBoulangerieDeQuartier,
      ),
      ChampIa('ville', t.iaVilleEtQuartier, exemple: 'Brazzaville, Moungali'),
      ChampIa(
        'clients',
        t.iaVosClients,
        exemple: t.iaFamillesEtPetitsCommerces,
      ),
      ChampIa('prix', t.iaPrixMoyenDUne, exemple: '2500'),
      ChampIa('ventes', t.iaVentesEspereesParMois, exemple: '300'),
      ChampIa('apport', t.iaVotreApportFcfa, exemple: '1500000'),
    ],
  ),
  ServiceIa(
    id: 'bp_complet',
    titre: t.iaBusinessPlanComplet,
    description: t.iaAssistantEn6Etapes,
    prix: 150,
    icone: Icons.account_balance,
    famille: t.iaLancerMonActivite,
    route: '/ia/business-plan',
    champs: [
      ChampIa(
        'activite',
        t.iaVotreActivite,
        exemple: t.iaBoulangerieDeQuartier,
      ),
      ChampIa('ville', t.iaVilleEtQuartier, exemple: 'Brazzaville, Moungali'),
      ChampIa('forme', t.iaFormeJuridiqueEnvisagee, exemple: 'SARL'),
      ChampIa(
        'clients',
        t.iaVosClients,
        exemple: t.iaFamillesEtPetitsCommerces,
      ),
      ChampIa(
        'concurrents',
        t.iaVosConcurrents,
        exemple: t.iaDeuxBoulangeriesA1,
      ),
      ChampIa('prix', t.iaPrixMoyenDUne, exemple: '2500'),
      ChampIa('ventes', t.iaVentesEspereesParMois, exemple: '300'),
      ChampIa('apport', t.iaVotreApportFcfa, exemple: '1500000'),
      ChampIa('pret', t.iaPretRechercheFcfa, exemple: '3000000'),
    ],
  ),
  ServiceIa(
    id: 'vocal',
    titre: t.iaTuteurVocal,
    description: t.iaReviserPreparerUnEntretien,
    prix: 5,
    unite: '/min',
    icone: Icons.record_voice_over,
    famille: t.iaReussirALEcole,
    route: '/ia/tuteur',
  ),
];

ServiceIa serviceParId(Textes t, String id) {
  final tous = servicesIa(t);
  return tous.firstWhere((s) => s.id == id, orElse: () => tous.first);
}

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
    // Nombre dans la couleur du texte (lisible dans les deux modes), symbole des crédits en orange (accent).
    final c = couleur ?? LiveColors.encre;
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
