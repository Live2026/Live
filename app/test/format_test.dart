import 'package:flutter_test/flutter_test.dart';
import 'package:live/core/format.dart';

void main() {
  test('fcfa sépare les milliers et ajoute la devise', () {
    expect(fcfa(85000), '85\u00A0000 FCFA');
    expect(fcfa(1500000, devise: false), '1\u00A0500\u00A0000');
    expect(fcfa(-150000), '-150\u00A0000 FCFA');
    expect(fcfa(900), '900 FCFA');
  });

  test('commission applique le taux et le minimum', () {
    expect(commission(85000, 0.06, minimum: 100), 5100);
    expect(commission(1000, 0.06, minimum: 100), 100);
    expect(commission(2000, 0.15), 300);
  });
}
