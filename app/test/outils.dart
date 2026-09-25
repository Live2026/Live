import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Active « réduire les animations » : l'application coupe alors ses
/// animations en boucle (fil vidéo, disque, progression), comme sur un
/// téléphone réglé ainsi, et pumpAndSettle peut se stabiliser.
void sansAnimations(WidgetTester tester) {
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      const FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
}

/// Charge la vraie police Roboto : sans elle, les tests utilisent une police
/// aux glyphes carrés, deux fois plus larges, qui fausse les débordements.
Future<void> chargerPolices() async {
  final roboto = FontLoader('Roboto');
  for (final f in Directory('assets/fonts').listSync().whereType<File>()) {
    if (f.path.endsWith('.ttf')) {
      roboto.addFont(
        Future.value(
          ByteData.sublistView(Uint8List.fromList(f.readAsBytesSync())),
        ),
      );
    }
  }
  await roboto.load();
}
