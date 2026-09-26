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

/// Langues proposées au démarrage et dans Paramètres, comme WhatsApp : le
/// nom dans la langue elle-même, puis en français. Langues officielles et
/// langues les plus parlées de la zone CEMAC.
const languesLive = [
  ('fr', 'Français', 'Français'),
  ('en', 'English', 'Anglais'),
  ('es', 'Español', 'Espagnol'),
  // Écrit en lettres latines : la police embarquée n'a pas l'alphabet arabe.
  ('ar', 'Arabe', 'Arabe'),
  ('ln', 'Lingála', 'Lingala'),
  ('kg', 'Kituba', 'Kituba (munukutuba)'),
  ('sg', 'Sängö', 'Sango'),
];
