import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Garde-fous des traductions : mêmes clés en français et en anglais, mêmes
/// variables, une description pour chaque clé, et plus aucun texte écrit en
/// dur dans les écrans déjà traduits.
void main() {
  Map<String, dynamic> lire(String f) =>
      jsonDecode(File('lib/l10n/$f').readAsStringSync())
          as Map<String, dynamic>;
  final fr = lire('app_fr.arb');
  final en = lire('app_en.arb');
  Iterable<String> cles(Map<String, dynamic> m) =>
      m.keys.where((k) => !k.startsWith('@'));

  test('le français et l’anglais ont les mêmes clés', () {
    expect(cles(en).toSet().difference(cles(fr).toSet()), isEmpty);
    expect(cles(fr).toSet().difference(cles(en).toSet()), isEmpty);
  });

  test('chaque clé a une description et ses variables dans les deux langues',
      () {
    final erreurs = <String>[];
    for (final k in cles(fr)) {
      final meta = fr['@$k'] as Map<String, dynamic>?;
      if (meta?['description'] == null) erreurs.add('$k : pas de description');
      final variables =
          (meta?['placeholders'] as Map<String, dynamic>?)?.keys ?? [];
      for (final v in variables) {
        for (final (langue, m) in [('fr', fr), ('en', en)]) {
          if (!(m[k] as String).contains('{$v')) {
            erreurs.add('$k ($langue) : variable {$v} absente');
          }
        }
      }
    }
    expect(erreurs, isEmpty, reason: erreurs.join('\n'));
  });

  // Écrans entièrement traduits : un texte d'interface écrit en dur y est une
  // régression. La liste s'allonge à chaque écran traduit.
  const traduits = [
    'lib/features/auth',
    'lib/features/feed',
    'lib/features/explore',
    'lib/features/market',
    'lib/features/compte',
    'lib/features/messages',
    'lib/features/pay',
    'lib/features/immo',
    'lib/features/services',
    'lib/features/publish',
    'lib/features/ia',
    'lib/features/piliers',
    'lib/features/apprendre',
    'lib/features/opportunites',
    'lib/features/croissance',
    'lib/features/expansion',
    'lib/features/aide',
    'lib/features/confiance',
    'lib/features/direct',
    'lib/features/social',
    'lib/features/createurs',
  ];
  final enDur = RegExp(
    r'''(?:Text\(|titre: |texte: |label: |tooltip: |hintText: |labelText: )\s*(?:const )?'[A-ZÀ-Ý][a-zà-ÿ’']+ [a-zà-ÿ]''',
  );

  test('aucun texte écrit en dur dans les écrans traduits', () {
    final erreurs = <String>[];
    for (final chemin in traduits) {
      final fichiers = FileSystemEntity.isDirectorySync(chemin)
          ? Directory(chemin).listSync().whereType<File>()
          : [File(chemin)];
      for (final f in fichiers) {
        final lignes = f.readAsLinesSync();
        for (final (i, l) in lignes.indexed) {
          if (enDur.hasMatch(l)) erreurs.add('${f.path}:${i + 1} : ${l.trim()}');
        }
      }
    }
    expect(erreurs, isEmpty, reason: erreurs.join('\n'));
  });
}
