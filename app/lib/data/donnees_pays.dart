/// Villes ouvertes par Live dans la zone CEMAC, avec le pays, l'indicatif
/// et les opérateurs Mobile Money acceptés au paiement (docs/07, §12).
/// Même monnaie partout : le franc CFA (XAF).
class VilleLive {
  const VilleLive(this.ville, this.pays, this.indicatif, this.operateurs);
  final String ville;
  final String pays;
  final String indicatif;

  /// Noms affichés au paiement, dans l'ordre de part de marché.
  final List<String> operateurs;

  String get libelle => '$pays · $ville';
}

const villesLive = [
  VilleLive('Brazzaville', 'Congo', '+242', [
    'MTN Mobile Money',
    'Airtel Money',
  ]),
  VilleLive('Pointe-Noire', 'Congo', '+242', [
    'MTN Mobile Money',
    'Airtel Money',
  ]),
  VilleLive('Libreville', 'Gabon', '+241', ['Airtel Money', 'Moov Money']),
  VilleLive('Douala', 'Cameroun', '+237', ['MTN Mobile Money', 'Orange Money']),
  VilleLive('Yaoundé', 'Cameroun', '+237', [
    'MTN Mobile Money',
    'Orange Money',
  ]),
  VilleLive('N’Djamena', 'Tchad', '+235', ['Airtel Money', 'Moov Money']),
  VilleLive('Bangui', 'Centrafrique', '+236', ['Orange Money']),
  VilleLive('Malabo', 'Guinée équatoriale', '+240', ['Muni Dinero']),
];

VilleLive villeLive(String ville) => villesLive.firstWhere(
  (v) => v.ville == ville,
  orElse: () => villesLive.first,
);

/// Pays de la CEMAC à l'inscription : indicatif, format national et
/// opérateurs Mobile Money reconnus par le début du numéro.
class PaysTelephone {
  const PaysTelephone({
    required this.code,
    required this.nom,
    required this.indicatif,
    required this.format,
    required this.prefixes,
  });

  /// Code ISO 3166 (CG, GA, CM, TD, CF, GQ) : sert au drapeau.
  final String code;
  final String nom;
  final String indicatif;

  /// Exemple de numéro, groupes séparés par des espaces : `06 123 45 67`.
  final String format;

  /// Débuts de numéro et opérateur correspondant, du plus long au plus court.
  final List<(String, String)> prefixes;

  /// Longueur des groupes du format : `06 123 45 67` donne 2, 3, 2, 2.
  List<int> get groupes => [for (final g in format.split(' ')) g.length];

  int get chiffres => groupes.fold(0, (s, n) => s + n);

  /// Opérateurs du pays, sans doublon, dans l'ordre des préfixes.
  List<String> get operateurs => {for (final (_, o) in prefixes) o}.toList();

  /// Opérateur reconnu d'après les premiers chiffres, ou null.
  String? operateur(String numero) {
    final n = numero.replaceAll(RegExp(r'\D'), '');
    for (final (debut, nom) in prefixes) {
      if (n.startsWith(debut)) return nom;
    }
    return null;
  }

  bool complet(String numero) =>
      numero.replaceAll(RegExp(r'\D'), '').length == chiffres;
}

const paysTelephone = [
  PaysTelephone(
    code: 'CG',
    nom: 'Congo',
    indicatif: '+242',
    format: '06 123 45 67',
    prefixes: [('06', 'MTN'), ('05', 'Airtel'), ('04', 'Airtel')],
  ),
  PaysTelephone(
    code: 'GA',
    nom: 'Gabon',
    indicatif: '+241',
    format: '077 12 34 56',
    prefixes: [
      ('074', 'Airtel'),
      ('076', 'Airtel'),
      ('077', 'Airtel'),
      ('062', 'Moov'),
      ('065', 'Moov'),
      ('066', 'Moov'),
    ],
  ),
  PaysTelephone(
    code: 'CM',
    nom: 'Cameroun',
    indicatif: '+237',
    format: '6 71 23 45 67',
    prefixes: [
      ('650', 'MTN'),
      ('651', 'MTN'),
      ('652', 'MTN'),
      ('653', 'MTN'),
      ('654', 'MTN'),
      ('655', 'Orange'),
      ('656', 'Orange'),
      ('657', 'Orange'),
      ('658', 'Orange'),
      ('659', 'Orange'),
      ('67', 'MTN'),
      ('68', 'MTN'),
      ('69', 'Orange'),
    ],
  ),
  PaysTelephone(
    code: 'TD',
    nom: 'Tchad',
    indicatif: '+235',
    format: '66 12 34 56',
    prefixes: [('6', 'Airtel'), ('9', 'Moov')],
  ),
  PaysTelephone(
    code: 'CF',
    nom: 'Centrafrique',
    indicatif: '+236',
    format: '72 12 34 56',
    prefixes: [('72', 'Orange'), ('75', 'Orange'), ('70', 'Telecel')],
  ),
  PaysTelephone(
    code: 'GQ',
    nom: 'Guinée équatoriale',
    indicatif: '+240',
    format: '222 123 456',
    prefixes: [('222', 'GETESA'), ('555', 'Muni')],
  ),
];
