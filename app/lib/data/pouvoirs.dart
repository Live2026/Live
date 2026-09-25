import 'package:flutter/material.dart';

import 'etat.dart';

/// Les « super-pouvoirs » de Live : les capacités du document 03, section 5.
///
/// Tout le monde commence comme simple utilisateur. Un pouvoir se débloque
/// selon ce que la personne publie, son niveau de vérification (N1 à N3)
/// ou son abonnement Pro. Il n'existe pas de rôle figé : on cumule des pouvoirs.
enum Condition { inscription, identite, professionnel, abonnementPro }

class Pouvoir {
  const Pouvoir({
    required this.id,
    required this.titre,
    required this.description,
    required this.icone,
    required this.condition,
    required this.gain,
    this.route,
  });

  /// Identifiant de la capacité (C-VENDRE, C-RETIRER…).
  final String id;
  final String titre;
  final String description;
  final IconData icone;
  final Condition condition;

  /// Ce que ce pouvoir rapporte ou permet, en une ligne.
  final String gain;

  /// Écran pour utiliser le pouvoir une fois débloqué.
  final String? route;

  bool actifPour(LiveState e) => switch (condition) {
    Condition.inscription => true,
    Condition.identite => e.niveau >= 2,
    Condition.professionnel => e.niveau >= 3,
    Condition.abonnementPro => e.pro,
  };

  /// Ce qu'il reste à faire pour débloquer le pouvoir.
  String get pourDebloquer => switch (condition) {
    Condition.inscription => 'Inclus pour tout le monde',
    Condition.identite => "Vérifiez votre identité (2 minutes)",
    Condition.professionnel => 'Créez un espace pro vérifié (RCCM, NIU)',
    Condition.abonnementPro => 'Passez à Live Pro (5 000 FCFA / mois)',
  };

  String get routeDeblocage => switch (condition) {
    Condition.inscription => '/moi',
    Condition.identite => '/verifier',
    Condition.professionnel => '/espace/nouveau',
    Condition.abonnementPro => '/live-pro',
  };
}

const pouvoirs = <Pouvoir>[
  Pouvoir(
    id: 'C-ACHETER',
    titre: 'Acheter protégé',
    description:
        'Payer en MoMo, Airtel ou Visa, argent bloqué jusqu’à réception.',
    icone: Icons.shopping_bag_rounded,
    condition: Condition.inscription,
    gain: 'Remboursé si rien n’arrive',
    route: '/market',
  ),
  Pouvoir(
    id: 'C-PUBLIER-SOCIAL',
    titre: 'Publier des vidéos',
    description: 'Partager vidéos et photos dans le fil, comme sur TikTok.',
    icone: Icons.videocam_rounded,
    condition: Condition.inscription,
    gain: 'Se faire connaître',
    route: '/publier/media',
  ),
  Pouvoir(
    id: 'C-VENDRE',
    titre: 'Vendre',
    description: 'Jusqu’à 3 annonces sans vérification, illimité ensuite.',
    icone: Icons.sell_rounded,
    condition: Condition.inscription,
    gain: '0 % de commission pendant 3 mois',
    route: '/vendre',
  ),
  Pouvoir(
    id: 'C-IA',
    titre: 'Live IA',
    description: 'CV, lettres, exercices, business plans avec vos crédits.',
    icone: Icons.auto_awesome_rounded,
    condition: Condition.inscription,
    gain: '20 crédits offerts, 10 chaque mois',
    route: '/ia',
  ),
  Pouvoir(
    id: 'C-RETIRER',
    titre: 'Retirer ses gains',
    description: 'Envoyer ses gains sur son numéro MTN MoMo ou Airtel Money.',
    icone: Icons.account_balance_wallet_rounded,
    condition: Condition.identite,
    gain: 'Sans frais de retrait',
    route: '/gains',
  ),
  Pouvoir(
    id: 'C-SERVICES',
    titre: 'Proposer ses services',
    description:
        'Plombier, coiffeuse, traiteur… recevoir des demandes de devis.',
    icone: Icons.handyman_rounded,
    condition: Condition.identite,
    gain: 'Acomptes garantis par Live',
    route: '/publier/service',
  ),
  Pouvoir(
    id: 'C-IMMO-PARTICULIER',
    titre: 'Louer ou vendre un bien',
    description: 'Publier son logement, fixer ses frais de visite.',
    icone: Icons.home_work_rounded,
    condition: Condition.identite,
    gain: 'Frais de visite versés après chaque visite',
    route: '/publier/bien',
  ),
  Pouvoir(
    id: 'C-CREATEUR',
    titre: 'Créateur',
    description: 'Recevoir des cadeaux de ses fans dès 500 abonnés.',
    icone: Icons.star_rounded,
    condition: Condition.identite,
    gain: 'Revenus de votre audience',
    route: '/profil/moi',
  ),
  Pouvoir(
    id: 'C-IMMO-AGENCE',
    titre: 'Agence ou boutique',
    description: 'Espace pro avec équipe, tableau de bord et badge vérifié.',
    icone: Icons.storefront_rounded,
    condition: Condition.professionnel,
    gain: 'Badge « Pro vérifié », plafonds élevés',
    route: '/agence',
  ),
  Pouvoir(
    id: 'C-STATS-AVANCEES',
    titre: 'Live Pro',
    description:
        'Statistiques détaillées, boosts moins chers, réponses rapides.',
    icone: Icons.insights_rounded,
    condition: Condition.abonnementPro,
    gain: '−30 % sur les boosts',
    route: '/live-pro',
  ),
];

Pouvoir pouvoirParId(String id) => pouvoirs.firstWhere((p) => p.id == id);

/// Libellé du niveau de confiance (document 03, section 4).
String libelleNiveau(int n) => switch (n) {
  1 => 'Téléphone vérifié',
  2 => 'Identité vérifiée',
  3 => 'Pro vérifié',
  _ => 'Partenaire',
};
