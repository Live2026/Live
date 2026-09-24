import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

/// Palette officielle de Live (fournie par le promoteur le 24/09/2026).
/// Couleur principale : le bleu. Règles d'usage et contrastes : docs/ecrans/00, section 9.
class LiveColors {
  /// Bleu Live : couleur principale (boutons, liens, navigation active).
  static const bleu = Color(0xFF13385C);

  /// Bleu nuit : titres, textes forts, texte posé sur l'orange et l'ambre.
  static const nuit = Color(0xFF041936);

  /// Orange : accent (crédits, mises en avant, sponsorisé). Jamais en texte sur blanc.
  static const orange = Color(0xFFFB9618);

  /// Orange vif : signal ponctuel (direct, nouveauté, pastille de notification).
  static const orangeVif = Color(0xFFFF8000);

  /// Ambre : bandeau prototype, étoiles, badges.
  static const ambre = Color(0xFFFCAF20);
  static const ambreClair = Color(0xFFFBCC6A);

  /// Crème : fonds d'alerte et de mise en avant.
  static const creme = Color(0xFFFBE2AC);

  /// Cuivre : texte en gros caractères sur fond crème.
  static const cuivre = Color(0xFFC27A25);

  /// Brume : surfaces neutres, bordures, fond du bandeau « Protégé par Live ».
  static const brume = Color(0xFFD7DCE4);

  // Couleurs d'état (hors marque, pour ne jamais confondre réussite et alerte).
  static const succes = Color(0xFF1E7B4F);
  static const erreur = Color(0xFFC62828);

  /// Texte secondaire (contraste 5,9 : 1 sur blanc).
  static const gris = Color(0xFF5B6573);

  // Rôles sémantiques utilisés par les écrans.
  static const fondProtection = brume;
  static const fondAlerte = creme;
}

/// Arrondi unique des boutons et des champs de saisie (8 px, demande du promoteur).
const rayonControle = 8.0;
const _forme = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(rayonControle)),
);

/// Fond très léger des champs et des boutons tonals.
const fondChamp = Color(0xFFF3F5F8);

ThemeData liveTheme() {
  final scheme =
      ColorScheme.fromSeed(
        seedColor: LiveColors.bleu,
        primary: LiveColors.bleu,
        secondary: LiveColors.orange,
        tertiary: LiveColors.ambre,
        error: LiveColors.erreur,
      ).copyWith(
        onPrimary: Colors.white,
        onSecondary: LiveColors.nuit,
        onTertiary: LiveColors.nuit,
        primaryContainer: LiveColors.brume,
        onPrimaryContainer: LiveColors.nuit,
        secondaryContainer: const Color(0xFFE6EBF2),
        onSecondaryContainer: LiveColors.bleu,
        surface: Colors.white,
        onSurface: LiveColors.nuit,
        onSurfaceVariant: LiveColors.gris,
        outline: const Color(0xFFC3CAD4),
        outlineVariant: const Color(0xFFE4E8EE),
      );
  const texteBouton = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );
  return ThemeData(
    colorScheme: scheme,
    fontFamily: 'Roboto',
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    splashFactory: InkSparkle.splashFactory,
    // Transitions de page glissées façon iOS, sur toutes les plateformes.
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        for (final p in TargetPlatform.values)
          p: const CupertinoPageTransitionsBuilder(),
      },
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: LiveColors.nuit,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: LiveColors.nuit,
      ),
    ),
    // Boutons : 8 px d'arrondi, hauteur 48 (46 pour les secondaires), sans ombre.
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: _forme,
        elevation: 0,
        textStyle: texteBouton,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(64, 46),
        shape: _forme,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(46),
        shape: _forme,
        foregroundColor: LiveColors.bleu,
        side: const BorderSide(color: Color(0xFFC3CAD4)),
        textStyle: texteBouton,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: _forme,
        foregroundColor: LiveColors.bleu,
        textStyle: texteBouton,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(shape: _forme),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        shape: _forme,
        selectedBackgroundColor: LiveColors.bleu,
        selectedForegroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFFE4E8EE)),
      ),
    ),
    cardTheme: const CardThemeData(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: Color(0xFFE4E8EE)),
      ),
    ),
    chipTheme: const ChipThemeData(
      shape: _forme,
      backgroundColor: Colors.white,
      selectedColor: LiveColors.bleu,
      checkmarkColor: Colors.white,
      secondaryLabelStyle: TextStyle(color: Colors.white),
      side: BorderSide(color: Color(0xFFE4E8EE)),
      showCheckmark: false,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      height: 64,
      indicatorColor: const Color(0xFFE6EBF2),
      indicatorShape: _forme,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (s) => TextStyle(
          fontSize: 12,
          fontWeight: s.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
          color: s.contains(WidgetState.selected)
              ? LiveColors.bleu
              : LiveColors.gris,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (s) => IconThemeData(
          color: s.contains(WidgetState.selected)
              ? LiveColors.bleu
              : LiveColors.gris,
        ),
      ),
    ),
    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: Colors.white,
      indicatorColor: Color(0xFFE6EBF2),
      indicatorShape: _forme,
      selectedIconTheme: IconThemeData(color: LiveColors.bleu),
      unselectedIconTheme: IconThemeData(color: LiveColors.gris),
      selectedLabelTextStyle: TextStyle(
        color: LiveColors.bleu,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelTextStyle: TextStyle(color: LiveColors.gris),
    ),
    badgeTheme: const BadgeThemeData(
      backgroundColor: LiveColors.orangeVif,
      textColor: LiveColors.nuit,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: LiveColors.bleu,
      linearTrackColor: Color(0xFFE6EBF2),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFFE4E8EE)),
    dialogTheme: const DialogThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: LiveColors.nuit,
      shape: _forme,
    ),
    // Champs : 8 px d'arrondi, fond léger, bordure discrète, bleu au focus.
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: fondChamp,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(rayonControle)),
        borderSide: BorderSide(color: Color(0xFFE4E8EE)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(rayonControle)),
        borderSide: BorderSide(color: Color(0xFFE4E8EE)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(rayonControle)),
        borderSide: BorderSide(color: LiveColors.bleu, width: 1.6),
      ),
    ),
  );
}
