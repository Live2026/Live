import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live/core/router.dart';
import 'package:live/main.dart';

import 'outils.dart';

Future<void> _taper(WidgetTester tester, String code) async {
  for (final c in code.split('')) {
    await tester.tap(find.text(c).last);
    await tester.pump();
  }
  await tester.pump(const Duration(milliseconds: 200));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('code secret : deux saisies identiques, sinon on recommence', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    sansAnimations(tester);
    routeur.go('/pin');
    await tester.pumpWidget(const ProviderScope(child: LiveApp()));
    await tester.pumpAndSettle();

    await _taper(tester, '1234');
    expect(find.text('Confirmez votre code'), findsOneWidget);
    await _taper(tester, '5678');
    expect(
      find.text('Les deux codes sont différents. Recommencez.'),
      findsOneWidget,
    );

    await _taper(tester, '1234');
    await _taper(tester, '1234');
    expect(find.text('Qu’est-ce qui vous intéresse ?'), findsOneWidget);
  });
}
