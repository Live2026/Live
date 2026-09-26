part of 'ia_screens.dart';

/// Fichier joint à l'Assistant : tout ce qu'on a sur son téléphone ou son
/// ordinateur (PDF, Word, Excel, PowerPoint, texte, Markdown, CSV, image).
class _Fichier {
  const _Fichier(this.nom, this.taille, this.pages);
  final String nom;
  final String taille;
  final int pages;

  String get extension => nom.split('.').last.toLowerCase();

  /// Prix de la lecture (Résumé de document, docs/19 : 5 à 20 crédits selon
  /// la longueur).
  int get cout => pages <= 5 ? 5 : (pages <= 15 ? 10 : 20);

  IconData get icone => switch (extension) {
    'pdf' => Icons.picture_as_pdf_rounded,
    'doc' || 'docx' => Icons.description_rounded,
    'xls' || 'xlsx' || 'csv' => Icons.table_chart_rounded,
    'ppt' || 'pptx' => Icons.slideshow_rounded,
    'jpg' || 'jpeg' || 'png' || 'heic' => Icons.image_rounded,
    'mp3' || 'm4a' || 'ogg' => Icons.audiotrack_rounded,
    _ => Icons.article_rounded,
  };

  Color get couleur => switch (extension) {
    'pdf' => const Color(0xFFDC2626),
    'doc' || 'docx' => const Color(0xFF1D4ED8),
    'xls' || 'xlsx' || 'csv' => const Color(0xFF15803D),
    'ppt' || 'pptx' => const Color(0xFFEA580C),
    'jpg' || 'jpeg' || 'png' || 'heic' => const Color(0xFF7C3AED),
    _ => LiveColors.gris,
  };
}

/// Fichiers de démonstration proposés par le sélecteur simulé.
const _fichiersDemo = [
  _Fichier('Contrat_bail_Moungali.pdf', '2,1 Mo', 4),
  _Fichier('Budget_boutique_2026.xlsx', '86 Ko', 3),
  _Fichier('CV_Grace_Mabiala.docx', '140 Ko', 2),
  _Fichier('Cours_SVT_chapitre_3.pdf', '5,4 Mo', 12),
  _Fichier('Presentation_projet.pptx', '3,2 Mo', 14),
  _Fichier('Notes_reunion.md', '6 Ko', 1),
  _Fichier('Photo_devis_plombier.jpg', '1,8 Mo', 1),
];

/// Réponse de l'Assistant : un texte, des points, une note, des actions.
class _Reponse {
  const _Reponse(this.texte, {this.points = const [], this.note, this.type});
  final String texte;
  final List<String> points;
  final String? note;

  /// Actions proposées sous la réponse (voir `_Actions`).
  final String? type;
}

/// Un message du fil : de l'utilisateur (texte et fichiers) ou de Live.
class _Message {
  const _Message.moi(this.texte, {this.fichiers = const []})
    : moi = true,
      reponse = null,
      aConfirmer = null;
  const _Message.live(_Reponse this.reponse)
    : moi = false,
      texte = '',
      fichiers = const [],
      aConfirmer = null;
  const _Message.confirmation(_Fichier this.aConfirmer)
    : moi = false,
      texte = '',
      fichiers = const [],
      reponse = null;

  final bool moi;
  final String texte;
  final List<_Fichier> fichiers;
  final _Reponse? reponse;

  /// Lecture d'un fichier en attente d'accord sur le prix (F-IA-03).
  final _Fichier? aConfirmer;
}

/// Ce que l'Assistant sait faire, en suggestions de départ.
List<(IconData, String, String)> _suggestions(Textes t) => [
  (
    Icons.home_work_rounded,
    t.iaTrouverUnLogement,
    'Un 2 pièces à Moungali à moins de 100 000',
  ),
  (Icons.handyman_rounded, t.iaReserverUnPro, 'Un plombier demain matin'),
  (
    Icons.smartphone_rounded,
    t.iaComparerDesPrix,
    'Un iPhone à moins de 90 000',
  ),
  (Icons.bolt_rounded, t.iaPayerUneFacture, 'Payer ma facture d’électricité'),
];

/// Conversations récentes (volet de gauche sur ordinateur, liste sur mobile).
List<(String, String)> _conversations(Textes t) => [
  (t.iaLogementAMoungali, t.iaAujourdHui),
  (t.iaBudgetDeLaBoutique, t.iaHier),
  (t.iaFactureE2cDeSeptembre, t.iaLun),
  (t.iaLettrePourLeStage, t.iaN18Sept),
];

/// Langues de la voix : l'assistant comprend et répond dans chacune.
const _langues = [
  ('Français', 'Je cherche un 2 pièces à Moungali à moins de 100 000'),
  ('Lingala', 'Nazali koluka ndako ya bashambre mibale na Moungali'),
  ('Kituba', 'Mono ke sosa nzo ya bashambre zole na Moungali'),
];

/// Réponse à une demande écrite ou dictée.
_Reponse _repondre(String texte) {
  final t = texte.toLowerCase();
  if (t.contains('plomb') || t.contains('électricien')) {
    return const _Reponse(
      'Serge, plombier vérifié à 1,2 km, est libre demain à 8 h.',
      points: [
        'Note 4,9 sur 71 interventions',
        'Déplacement : 5 000 FCFA, devis gratuit sur place',
        'Acompte de 30 % gardé par Live jusqu’à la fin du travail',
      ],
      type: 'pro',
    );
  }
  if (t.contains('iphone') || t.contains('téléphone') || t.contains('prix')) {
    return const _Reponse(
      'J’ai trouvé 2 iPhone à moins de 90 000 FCFA près de vous.',
      points: [
        'iPhone 11, 64 Go, Poto-Poto : 85 000 FCFA, au juste prix',
        'iPhone XR, 128 Go, Bacongo : 78 000 FCFA, batterie à 81 %',
      ],
      note:
          'Payez dans Live : l’argent est versé au vendeur quand vous '
          'confirmez la réception.',
      type: 'produit',
    );
  }
  if (t.contains('facture') || t.contains('électricité') || t.contains('e2c')) {
    return const _Reponse(
      'Votre facture E2C de septembre est de 18 450 FCFA, à payer avant le '
      '5 octobre.',
      points: ['Compteur 0412 3345 · Moungali', 'Sans frais pour vous'],
      type: 'facture',
    );
  }
  if (t.contains('logement') ||
      t.contains('pièces') ||
      t.contains('ndako') ||
      t.contains('nzo') ||
      t.contains('appartement') ||
      t.contains('studio')) {
    return const _Reponse(
      '3 appartements de 2 chambres à Moungali, de 75 000 à 95 000 FCFA.',
      points: [
        'Rue Mbaka : 85 000 FCFA, forage, visite mardi à 10 h 30',
        'Avenue de la Paix : 95 000 FCFA, compteur E2C individuel',
        'Près du marché : 75 000 FCFA, à rafraîchir',
      ],
      note:
          'Frais de visite payés dans Live, remboursés si la visite n’a '
          'pas lieu.',
      type: 'logement',
    );
  }
  return const _Reponse(
    'Je peux chercher pour vous dans tout Live, réserver une visite ou un '
    'pro, payer une facture, préparer un document ou lire un fichier.',
    points: [
      'Écrivez comme vous parlez, en français, lingala ou kituba',
      'Joignez un PDF, un Word, un Excel ou une photo avec le bouton +',
      'Ou passez en mode vocal pour discuter à voix haute',
    ],
  );
}

/// Réponse après lecture d'un fichier (payée en crédits).
_Reponse _lire(_Fichier f) => switch (f.extension) {
  'xlsx' || 'xls' || 'csv' => const _Reponse(
    'J’ai lu votre tableau « Budget boutique 2026 » (3 feuilles).',
    points: [
      'Recettes prévues : 1 200 000 FCFA par mois',
      'Dépenses : 870 000 FCFA, dont 45 % de marchandises',
      'Marge : 28 %, au-dessus de la moyenne des boutiques de mode',
      'Point d’attention : le loyer augmente de 10 % en janvier',
    ],
    type: 'budget',
  ),
  'docx' || 'doc' => const _Reponse(
    'J’ai lu votre CV (2 pages). Il est clair, mais peut être plus fort.',
    points: [
      'Ajoutez des résultats chiffrés à votre stage chez MTN',
      'Le titre est trop général : visez le poste demandé',
      'Deux fautes d’orthographe en page 2',
    ],
    type: 'cv',
  ),
  'pptx' || 'ppt' => const _Reponse(
    'J’ai lu votre présentation (14 diapositives).',
    points: [
      'Le problème et la solution sont bien posés (diapos 2 à 4)',
      'Il manque le prix de vente et les concurrents',
      'La diapo 11 (chiffres) est trop chargée : gardez 3 chiffres',
    ],
    type: 'budget',
  ),
  'md' || 'txt' => const _Reponse(
    'Voici l’essentiel de vos notes de réunion.',
    points: [
      'Décision : ouvrir la boutique en ligne sur Live en octobre',
      'Jordy s’occupe des photos, Céline des prix',
      'Prochaine réunion : samedi à 16 h',
    ],
  ),
  'jpg' || 'jpeg' || 'png' || 'heic' => const _Reponse(
    'C’est un devis de plomberie de 65 000 FCFA.',
    points: [
      'Main-d’œuvre : 25 000 FCFA ; pièces : 40 000 FCFA',
      'Le prix est dans la fourchette du marché à Brazzaville',
      'Aucune date de fin n’est indiquée : demandez-la',
    ],
    type: 'pro',
  ),
  _ when f.pages > 5 => const _Reponse(
    'Résumé de votre cours de SVT, chapitre 3 (12 pages).',
    points: [
      'La cellule est l’unité de base de tout être vivant',
      'Elle a une membrane, un cytoplasme et un noyau',
      'La mitose donne deux cellules identiques',
    ],
    note: 'Je peux vous préparer 10 questions pour réviser.',
    type: 'cours',
  ),
  _ => const _Reponse(
    'J’ai lu votre contrat de bail (4 pages). L’essentiel :',
    points: [
      'Loyer : 85 000 FCFA par mois, caution de 3 mois',
      'Durée : 1 an, renouvelable ; préavis de 2 mois',
      'Point d’attention : hausse de 10 % par an (article 6)',
      'Les réparations du toit sont à la charge du bailleur',
    ],
    note:
        'Le loyer et la caution se paient en direct au bailleur, contre '
        'reçu.',
    type: 'logement',
  ),
};
