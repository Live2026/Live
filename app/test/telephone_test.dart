import 'package:flutter_test/flutter_test.dart';
import 'package:live/data/donnees_telephone.dart';

void main() {
  test(
    'au moins vingt pays, sans doublon, dont RDC, Côte d’Ivoire, France, Chine',
    () {
      expect(paysTelephone.length, greaterThanOrEqualTo(20));
      final codes = paysTelephone.map((p) => p.code).toList();
      expect(codes.toSet().length, codes.length);
      expect(codes, containsAll(['CG', 'CD', 'CI', 'FR', 'CN']));
      for (final p in paysTelephone) {
        expect(p.operateurs, isNotEmpty, reason: p.nom);
        expect(p.indicatif, startsWith('+'), reason: p.nom);
      }
    },
  );

  test('opérateurs reconnus d’après le début du numéro', () {
    PaysTelephone pays(String code) =>
        paysTelephone.firstWhere((p) => p.code == code);
    expect(pays('CD').operateur('81 234 5678'), 'Vodacom');
    expect(pays('CI').operateur('07 12 34 56 78'), 'Orange');
    expect(pays('CI').complet('07 12 34 56 78'), isTrue);
    expect(pays('FR').mobileMoney, isFalse);
    expect(pays('CG').mobileMoney, isTrue);
  });

  test('un début de numéro impossible est signalé, pas un début valide', () {
    final congo = paysTelephone.firstWhere((p) => p.code == 'CG');
    expect(congo.debutInconnu('07'), isTrue);
    expect(congo.debutInconnu('0'), isFalse);
    expect(congo.debutInconnu('06 1'), isFalse);
    expect(congo.debutInconnu(''), isFalse);
    expect(congo.debutsConnus, '06, 05, 04');
  });
}
