/// Écrit un montant au format `25 000 FCFA` (espace comme séparateur des milliers).
String fcfa(int montant, {bool devise = true}) {
  final negatif = montant < 0;
  final chiffres = montant.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < chiffres.length; i++) {
    if (i > 0 && (chiffres.length - i) % 3 == 0) buffer.write('\u00A0');
    buffer.write(chiffres[i]);
  }
  final texte = '${negatif ? '-' : ''}$buffer';
  return devise ? '$texte FCFA' : texte;
}

/// Commission Live arrondie à l'entier, avec un minimum éventuel.
int commission(int montant, double taux, {int minimum = 0}) {
  final c = (montant * taux).round();
  return c < minimum ? minimum : c;
}

/// Note sur 5 au format français : `4,9/5`.
String note(double n) => '${n.toStringAsFixed(1).replaceAll('.', ',')}/5';

/// Montant court pour les gros prix : `95 M FCFA`, `18 M FCFA`, `650 000 FCFA`.
String fcfaCourt(int montant) {
  if (montant >= 1000000) {
    final m = montant / 1000000;
    final t = m == m.roundToDouble()
        ? m.toStringAsFixed(0)
        : m.toStringAsFixed(1).replaceAll('.', ',');
    return '$t M FCFA';
  }
  return fcfa(montant);
}

/// Nombre court façon réseaux sociaux : `12,4k`, `310`.
String compact(int n) {
  if (n >= 1000) {
    final k = n / 1000;
    return '${k.toStringAsFixed(k >= 100 ? 0 : 1).replaceAll('.', ',').replaceAll(',0', '')}k';
  }
  return '$n';
}
