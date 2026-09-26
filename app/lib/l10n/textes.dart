import 'package:flutter/widgets.dart';

import 'gen/app_localizations.dart';

export 'gen/app_localizations.dart';

/// Textes de l'interface dans la langue choisie : `context.t.commencer`.
/// Fichiers : lib/l10n/app_fr.arb (référence) et app_en.arb ; les autres
/// langues proposées retombent sur le français en attendant leur traduction.
extension TextesLive on BuildContext {
  Textes get t => Textes.of(this);
}

/// Langues dont l'interface est traduite.
const languesTraduites = {'fr', 'en'};
