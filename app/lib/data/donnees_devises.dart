import 'package:flutter/material.dart';

/// Devise d'envoi de Live Transfert et de la diaspora (docs/21, §4).
///
/// [taux] donne le nombre de francs CFA (XAF) pour une unité. Seules les
/// devises à parité fixe (euro, franc CFA d'Afrique de l'Ouest) ont un taux
/// garanti ; les autres suivent la cotation du partenaire de transfert,
/// bloquée pendant 30 minutes au moment de l'envoi. Les taux du prototype
/// sont indicatifs.
class Devise {
  const Devise({
    required this.code,
    required this.nom,
    required this.symbole,
    required this.zone,
    required this.taux,
    required this.pas,
    required this.couleur,
    this.fixe = false,
  });

  /// Code ISO 4217 : `EUR`, `USD`…
  final String code;
  final String nom;

  /// Symbole affiché après le montant ; le code quand la police n'a pas le
  /// symbole (naira, dirham…).
  final String symbole;

  /// Où on l'utilise, pour aider à choisir.
  final String zone;

  /// Francs CFA (XAF) pour une unité.
  final double taux;

  /// Pas du curseur d'envoi (10 €, 5 000 FCFA ouest-africains…).
  final int pas;
  final Color couleur;

  /// Parité fixe garantie par l'accord monétaire.
  final bool fixe;

  /// Montant minimal et maximal d'un envoi : de 1 à 100 pas.
  int get minimum => pas;
  int get maximum => pas * 100;

  /// Montant reçu au pays, en francs CFA.
  int versFcfa(num montant) => (montant * taux).round();

  /// Montant dans cette devise pour une somme en francs CFA.
  double depuisFcfa(int fcfa) => fcfa / taux;

  /// `100 €`, `1 250 USD`, `35,40 £` (deux décimales si besoin).
  String ecrire(num montant, {bool decimales = false}) {
    final texte = decimales
        ? montant.toStringAsFixed(2).replaceAll('.', ',')
        : _milliers(montant.round());
    return '$texte $symbole';
  }

  /// `1 € = 655,957 FCFA`.
  String get libelleTaux {
    final t = taux >= 100
        ? taux.toStringAsFixed(taux == taux.roundToDouble() ? 0 : 3)
        : taux.toStringAsFixed(taux < 1 ? 4 : 2);
    return '1 $symbole = ${t.replaceAll('.', ',')} FCFA';
  }
}

String _milliers(int n) {
  final s = n.abs().toString();
  final b = StringBuffer(n < 0 ? '-' : '');
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(' ');
    b.write(s[i]);
  }
  return b.toString();
}

/// Devises acceptées à l'envoi, par importance pour la diaspora
/// d'Afrique centrale.
const devises = [
  Devise(
    code: 'EUR',
    nom: 'Euro',
    symbole: '€',
    zone: 'France, Belgique, Europe',
    taux: 655.957,
    pas: 10,
    couleur: Color(0xFF1D4ED8),
    fixe: true,
  ),
  Devise(
    code: 'USD',
    nom: 'Dollar américain',
    symbole: 'USD',
    zone: 'États-Unis, monde',
    taux: 561.40,
    pas: 10,
    couleur: Color(0xFF15803D),
  ),
  Devise(
    code: 'GBP',
    nom: 'Livre sterling',
    symbole: '£',
    zone: 'Royaume-Uni',
    taux: 758.20,
    pas: 10,
    couleur: Color(0xFF7C3AED),
  ),
  Devise(
    code: 'CAD',
    nom: 'Dollar canadien',
    symbole: 'CAD',
    zone: 'Canada',
    taux: 404.60,
    pas: 10,
    couleur: Color(0xFFDC2626),
  ),
  Devise(
    code: 'CHF',
    nom: 'Franc suisse',
    symbole: 'CHF',
    zone: 'Suisse',
    taux: 701.30,
    pas: 10,
    couleur: Color(0xFFB91C1C),
  ),
  Devise(
    code: 'XOF',
    nom: 'Franc CFA (BCEAO)',
    symbole: 'FCFA BCEAO',
    zone: 'Sénégal, Côte d’Ivoire, Afrique de l’Ouest',
    taux: 1,
    pas: 5000,
    couleur: Color(0xFFEA580C),
    fixe: true,
  ),
  Devise(
    code: 'CNY',
    nom: 'Yuan',
    symbole: 'CNY',
    zone: 'Chine',
    taux: 78.60,
    pas: 100,
    couleur: Color(0xFFBE123C),
  ),
  Devise(
    code: 'AED',
    nom: 'Dirham',
    symbole: 'AED',
    zone: 'Émirats arabes unis, Dubaï',
    taux: 152.90,
    pas: 50,
    couleur: Color(0xFF0F766E),
  ),
  Devise(
    code: 'ZAR',
    nom: 'Rand',
    symbole: 'ZAR',
    zone: 'Afrique du Sud',
    taux: 31.80,
    pas: 200,
    couleur: Color(0xFFCA8A04),
  ),
  Devise(
    code: 'NGN',
    nom: 'Naira',
    symbole: 'NGN',
    zone: 'Nigeria',
    taux: 0.3650,
    pas: 10000,
    couleur: Color(0xFF166534),
  ),
];

Devise deviseParCode(String code) =>
    devises.firstWhere((d) => d.code == code, orElse: () => devises.first);

/// Transfert reçu de l'étranger, crédité sur le solde Live du bénéficiaire.
class TransfertRecu {
  const TransfertRecu({
    required this.id,
    required this.de,
    required this.lieu,
    required this.devise,
    required this.montant,
    required this.quand,
  });
  final String id;
  final String de;
  final String lieu;
  final String devise;
  final num montant;
  final String quand;

  int get fcfa => deviseParCode(devise).versFcfa(montant);
}

/// Transferts reçus de démonstration (côté bénéficiaire, au pays).
const transfertsRecus = [
  TransfertRecu(
    id: 'r1',
    de: 'Patrick M.',
    lieu: 'Paris',
    devise: 'EUR',
    montant: 150,
    quand: 'Aujourd’hui, 9 h 12',
  ),
  TransfertRecu(
    id: 'r2',
    de: 'Aline B.',
    lieu: 'Montréal',
    devise: 'CAD',
    montant: 200,
    quand: 'Hier, 18 h 40',
  ),
  TransfertRecu(
    id: 'r3',
    de: 'Serge N.',
    lieu: 'Houston',
    devise: 'USD',
    montant: 100,
    quand: '21 sept.',
  ),
];
