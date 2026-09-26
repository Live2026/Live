/// Pays proposés à la saisie du numéro : indicatif, format national et
/// opérateurs reconnus par le début du numéro. Afrique centrale d'abord,
/// puis Afrique de l'Ouest, puis la France et la Chine (diaspora, commerce).
///
/// Les préfixes suivent les plans de numérotation publiés ; la portabilité
/// les rend indicatifs : à confirmer par l'opérateur au paiement.
class PaysTelephone {
  const PaysTelephone({
    required this.code,
    required this.nom,
    required this.indicatif,
    required this.format,
    required this.prefixes,
    required this.region,
    this.mobileMoney = true,
  });

  /// Code ISO 3166 : sert au drapeau.
  final String code;
  final String nom;
  final String indicatif;

  /// Exemple de numéro, groupes séparés par des espaces : `06 123 45 67`.
  final String format;

  /// Débuts de numéro et opérateur correspondant, du plus long au plus court.
  final List<(String, String)> prefixes;

  final RegionTelephone region;

  /// Faux hors d'Afrique : le numéro sert à se connecter, on paie par carte.
  final bool mobileMoney;

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

enum RegionTelephone {
  centrale('Afrique centrale'),
  ouest('Afrique de l’Ouest'),
  monde('Europe et Asie');

  const RegionTelephone(this.nom);
  final String nom;
}

const _c = RegionTelephone.centrale;
const _o = RegionTelephone.ouest;
const _m = RegionTelephone.monde;

const paysTelephone = [
  // Afrique centrale
  PaysTelephone(
    code: 'CG',
    nom: 'Congo',
    indicatif: '+242',
    format: '06 123 45 67',
    prefixes: [('06', 'MTN'), ('05', 'Airtel'), ('04', 'Airtel')],
    region: _c,
  ),
  PaysTelephone(
    code: 'CD',
    nom: 'RD Congo',
    indicatif: '+243',
    format: '81 234 5678',
    prefixes: [
      ('81', 'Vodacom'),
      ('82', 'Vodacom'),
      ('83', 'Vodacom'),
      ('84', 'Orange'),
      ('85', 'Orange'),
      ('89', 'Orange'),
      ('97', 'Airtel'),
      ('98', 'Airtel'),
      ('99', 'Airtel'),
      ('90', 'Africell'),
      ('91', 'Africell'),
    ],
    region: _c,
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
    region: _c,
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
    region: _c,
  ),
  PaysTelephone(
    code: 'TD',
    nom: 'Tchad',
    indicatif: '+235',
    format: '66 12 34 56',
    prefixes: [('6', 'Airtel'), ('9', 'Moov')],
    region: _c,
  ),
  PaysTelephone(
    code: 'CF',
    nom: 'Centrafrique',
    indicatif: '+236',
    format: '72 12 34 56',
    prefixes: [('72', 'Orange'), ('75', 'Orange'), ('70', 'Telecel')],
    region: _c,
  ),
  PaysTelephone(
    code: 'GQ',
    nom: 'Guinée équatoriale',
    indicatif: '+240',
    format: '222 123 456',
    prefixes: [('222', 'GETESA'), ('555', 'Muni')],
    region: _c,
  ),
  PaysTelephone(
    code: 'AO',
    nom: 'Angola',
    indicatif: '+244',
    format: '923 123 456',
    prefixes: [
      ('92', 'Unitel'),
      ('93', 'Unitel'),
      ('94', 'Unitel'),
      ('91', 'Movicel'),
      ('99', 'Movicel'),
      ('95', 'Africell'),
    ],
    region: _c,
  ),
  PaysTelephone(
    code: 'ST',
    nom: 'São Tomé-et-Príncipe',
    indicatif: '+239',
    format: '981 2345',
    prefixes: [('98', 'CST'), ('99', 'CST'), ('90', 'Unitel')],
    region: _c,
  ),
  PaysTelephone(
    code: 'RW',
    nom: 'Rwanda',
    indicatif: '+250',
    format: '78 123 4567',
    prefixes: [
      ('78', 'MTN'),
      ('79', 'MTN'),
      ('72', 'Airtel'),
      ('73', 'Airtel'),
    ],
    region: _c,
  ),
  PaysTelephone(
    code: 'BI',
    nom: 'Burundi',
    indicatif: '+257',
    format: '79 12 34 56',
    prefixes: [
      ('79', 'Econet Leo'),
      ('61', 'Lumitel'),
      ('68', 'Lumitel'),
      ('69', 'Lumitel'),
    ],
    region: _c,
  ),
  // Afrique de l'Ouest
  PaysTelephone(
    code: 'CI',
    nom: 'Côte d’Ivoire',
    indicatif: '+225',
    format: '07 12 34 56 78',
    prefixes: [('07', 'Orange'), ('05', 'MTN'), ('01', 'Moov')],
    region: _o,
  ),
  PaysTelephone(
    code: 'SN',
    nom: 'Sénégal',
    indicatif: '+221',
    format: '77 123 45 67',
    prefixes: [
      ('77', 'Orange'),
      ('78', 'Orange'),
      ('76', 'Free'),
      ('70', 'Expresso'),
    ],
    region: _o,
  ),
  PaysTelephone(
    code: 'ML',
    nom: 'Mali',
    indicatif: '+223',
    format: '76 12 34 56',
    prefixes: [('7', 'Orange'), ('6', 'Moov'), ('9', 'Moov')],
    region: _o,
  ),
  PaysTelephone(
    code: 'BF',
    nom: 'Burkina Faso',
    indicatif: '+226',
    format: '70 12 34 56',
    prefixes: [
      ('74', 'Orange'),
      ('75', 'Orange'),
      ('76', 'Orange'),
      ('77', 'Orange'),
      ('70', 'Moov'),
      ('71', 'Moov'),
      ('72', 'Moov'),
      ('73', 'Moov'),
      ('78', 'Telecel'),
      ('79', 'Telecel'),
    ],
    region: _o,
  ),
  PaysTelephone(
    code: 'BJ',
    nom: 'Bénin',
    indicatif: '+229',
    format: '01 97 12 34 56',
    prefixes: [
      ('0196', 'MTN'),
      ('0197', 'MTN'),
      ('0161', 'MTN'),
      ('0162', 'MTN'),
      ('0194', 'Moov'),
      ('0195', 'Moov'),
      ('0198', 'Moov'),
      ('0199', 'Moov'),
    ],
    region: _o,
  ),
  PaysTelephone(
    code: 'TG',
    nom: 'Togo',
    indicatif: '+228',
    format: '90 12 34 56',
    prefixes: [
      ('90', 'Yas'),
      ('91', 'Yas'),
      ('92', 'Yas'),
      ('93', 'Yas'),
      ('96', 'Moov'),
      ('97', 'Moov'),
      ('98', 'Moov'),
      ('99', 'Moov'),
    ],
    region: _o,
  ),
  PaysTelephone(
    code: 'NE',
    nom: 'Niger',
    indicatif: '+227',
    format: '90 12 34 56',
    prefixes: [('9', 'Airtel'), ('8', 'Moov')],
    region: _o,
  ),
  PaysTelephone(
    code: 'GN',
    nom: 'Guinée',
    indicatif: '+224',
    format: '620 12 34 56',
    prefixes: [('62', 'Orange'), ('66', 'MTN'), ('65', 'Cellcom')],
    region: _o,
  ),
  PaysTelephone(
    code: 'NG',
    nom: 'Nigeria',
    indicatif: '+234',
    format: '803 123 4567',
    prefixes: [
      ('803', 'MTN'),
      ('806', 'MTN'),
      ('703', 'MTN'),
      ('706', 'MTN'),
      ('813', 'MTN'),
      ('816', 'MTN'),
      ('903', 'MTN'),
      ('805', 'Glo'),
      ('807', 'Glo'),
      ('705', 'Glo'),
      ('815', 'Glo'),
      ('802', 'Airtel'),
      ('808', 'Airtel'),
      ('708', 'Airtel'),
      ('812', 'Airtel'),
      ('902', 'Airtel'),
      ('809', '9mobile'),
      ('817', '9mobile'),
      ('818', '9mobile'),
    ],
    region: _o,
  ),
  PaysTelephone(
    code: 'GH',
    nom: 'Ghana',
    indicatif: '+233',
    format: '24 123 4567',
    prefixes: [
      ('24', 'MTN'),
      ('54', 'MTN'),
      ('55', 'MTN'),
      ('59', 'MTN'),
      ('20', 'Telecel'),
      ('50', 'Telecel'),
      ('26', 'AirtelTigo'),
      ('27', 'AirtelTigo'),
      ('56', 'AirtelTigo'),
      ('57', 'AirtelTigo'),
    ],
    region: _o,
  ),
  // Europe et Asie : connexion par SMS, paiement par carte.
  PaysTelephone(
    code: 'FR',
    nom: 'France',
    indicatif: '+33',
    format: '6 12 34 56 78',
    prefixes: [('6', 'Mobile'), ('7', 'Mobile')],
    region: _m,
    mobileMoney: false,
  ),
  PaysTelephone(
    code: 'CN',
    nom: 'Chine',
    indicatif: '+86',
    format: '138 1234 5678',
    prefixes: [
      ('13', 'Mobile'),
      ('15', 'Mobile'),
      ('17', 'Mobile'),
      ('18', 'Mobile'),
      ('19', 'Mobile'),
    ],
    region: _m,
    mobileMoney: false,
  ),
];
