import 'package:flutter_test/flutter_test.dart';
import 'package:live/features/explore/explore_screen.dart';

void main() {
  test('une faute de frappe est corrigée (F-RECH-01)', () {
    expect(corrigerRecherche('climatiser'), 'climatiseur');
    expect(corrigerRecherche('plonbier'), 'plombier');
  });

  test('un mot juste n’est pas corrigé', () {
    expect(corrigerRecherche('climatiseur'), isNull);
  });
}
