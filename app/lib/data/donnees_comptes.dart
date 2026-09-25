import 'package:flutter/material.dart';

import 'modeles_savoirs.dart';

/// Abonnés, abonnements et activité des comptes suivis (fictifs).

const comptes = <Compte>[
  Compte(
    'grace',
    'Grâce Mode',
    TypeCompte.organisation,
    Color(0xFFB45309),
    'Pagnes et robes wax · Moungali',
    verifie: true,
    abonnes: 12400,
    route: '/boutique/grace',
  ),
  Compte(
    'kimbembe',
    'Prof. Kimbembe',
    TypeCompte.enseignant,
    Color(0xFF1D4ED8),
    'Maths BAC C et D',
    verifie: true,
    abonnes: 21300,
    route: '/contenu/n1',
  ),
  Compte(
    'mbongui',
    'Fondation Mbongui',
    TypeCompte.organisation,
    Color(0xFF7C3AED),
    'Bourses d’études',
    verifie: true,
    abonnes: 9800,
    route: '/opportunite/o1',
  ),
  Compte(
    'ingrid',
    'Ingrid Code',
    TypeCompte.createur,
    Color(0xFF7C3AED),
    'Développeuse web, cours de code',
    verifie: true,
    abonnes: 15800,
    route: '/contenu/n7',
  ),
  Compte(
    'merveille',
    'Merveille K.',
    TypeCompte.personne,
    Color(0xFF7E22CE),
    'Étudiante · Moungali',
    abonnes: 240,
    route: '/profil/merveille',
  ),
  Compte(
    'palmiers',
    'Agence Les Palmiers',
    TypeCompte.organisation,
    Color(0xFF166534),
    'Logements vérifiés · Brazzaville',
    verifie: true,
    abonnes: 6400,
    route: '/boutique/palmiers',
  ),
  Compte(
    'jordy',
    'Jordy M.',
    TypeCompte.personne,
    Color(0xFF0F766E),
    'Mécanicien · Talangaï',
    abonnes: 88,
  ),
  Compte(
    'bantu',
    'Académie Bantu',
    TypeCompte.enseignant,
    Color(0xFF0F766E),
    'Anglais, bureautique',
    verifie: true,
    abonnes: 8700,
    route: '/contenu/n5',
  ),
  Compte(
    'nadege',
    'Nadège L.',
    TypeCompte.createur,
    Color(0xFF166534),
    'Recettes du pays en vidéo',
    abonnes: 3100,
  ),
  Compte(
    'prince',
    'Prince B.',
    TypeCompte.personne,
    Color(0xFF9A3412),
    'Commerçant · Poto-Poto',
    abonnes: 150,
  ),
];

Compte compteParId(String id) =>
    comptes.firstWhere((c) => c.id == id, orElse: () => comptes.first);

/// Personnes qui suivent le compte de démonstration.
final abonnesDemo = [
  for (final id in [
    'merveille',
    'jordy',
    'nadege',
    'prince',
    'kimbembe',
    'grace',
  ])
    compteParId(id),
];

/// Activité récente des comptes suivis, du plus récent au plus ancien.
final activitesSuivis = [
  Activite(
    compteParId('kimbembe'),
    'a publié un nouveau cours',
    'Maths BAC C et D : tout le programme',
    '15 000 FCFA · 42 leçons',
    'il y a 12 min',
    Icons.school_rounded,
    '/contenu/n1',
    couleur: const Color(0xFF1D4ED8),
  ),
  Activite(
    compteParId('mbongui'),
    'a publié une bourse',
    'Bourse d’excellence 2027',
    '40 places · gratuit · J-20',
    'il y a 1 h',
    Icons.workspace_premium_rounded,
    '/opportunite/o1',
    couleur: const Color(0xFF7C3AED),
  ),
  Activite(
    compteParId('grace'),
    'a mis en vente',
    'Robe wax longue',
    '15 000 FCFA · Neuf',
    'il y a 2 h',
    Icons.checkroom_rounded,
    '/produit/p2',
    couleur: const Color(0xFFB45309),
  ),
  Activite(
    compteParId('palmiers'),
    'a publié un logement',
    'Appartement 2 chambres',
    'Vérifié par Live',
    'hier',
    Icons.home_work_rounded,
    '/bien/b1',
    couleur: const Color(0xFF166534),
  ),
  Activite(
    compteParId('ingrid'),
    'est en direct',
    'Questions-réponses : premier site web',
    '312 personnes regardent',
    'hier',
    Icons.podcasts_rounded,
    '/contenu/n7',
    couleur: const Color(0xFFDC2626),
  ),
];
