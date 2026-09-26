import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

/// Couleur de Live qui suit le mode clair ou sombre : une valeur pour
/// chaque mode, choisie à l'affichage selon [LiveColors.sombre]. Reste
/// `const`, donc utilisable partout où une couleur fixe l'était.
class CouleurLive extends Color {
  const CouleurLive(super.clair, this._sombre);
  final int _sombre;

  Color get _nuit => Color(_sombre);

  @override
  double get a => LiveColors.sombre ? _nuit.a : super.a;
  @override
  double get r => LiveColors.sombre ? _nuit.r : super.r;
  @override
  double get g => LiveColors.sombre ? _nuit.g : super.g;
  @override
  double get b => LiveColors.sombre ? _nuit.b : super.b;
}

/// Palette officielle de Live (fournie par le promoteur le 24/09/2026).
/// Couleur principale : le bleu. Règles d'usage et contrastes : docs/ecrans/00, section 9.
/// Chaque couleur a sa valeur pour le mode sombre (docs/ecrans/00, section 10).
class LiveColors {
  /// Mode sombre actif : fixé par l'application avant chaque construction.
  static bool sombre = false;

  /// Bleu Live : couleur principale (boutons, liens, navigation active).
  static const bleu = CouleurLive(0xFF13385C, 0xFF4180C0);

  /// Bleu nuit : fonds sombres de la marque (identique dans les deux modes).
  static const nuit = Color(0xFF041936);

  /// Encre : titres et textes forts (bleu nuit en clair, presque blanc en sombre).
  static const encre = CouleurLive(0xFF041936, 0xFFE8EDF4);

  /// Orange : accent (crédits, mises en avant, sponsorisé). Jamais en texte sur blanc.
  static const orange = Color(0xFFFB9618);

  /// Orange vif : signal ponctuel (direct, nouveauté, pastille de notification).
  static const orangeVif = Color(0xFFFF8000);

  /// Ambre : bandeau prototype, étoiles, badges.
  static const ambre = Color(0xFFFCAF20);
  static const ambreClair = Color(0xFFFBCC6A);

  /// Crème : fonds d'alerte et de mise en avant.
  static const creme = CouleurLive(0xFFFBE2AC, 0xFF3B2F18);

  /// Cuivre : texte en gros caractères sur fond crème.
  static const cuivre = CouleurLive(0xFFC27A25, 0xFFF2B870);

  /// Brume : surfaces neutres, bordures, fond du bandeau « Protégé par Live ».
  static const brume = CouleurLive(0xFFD7DCE4, 0xFF2A3441);

  /// Texte clair posé sur les fonds sombres de la marque (cartes d'argent,
  /// dégradés) : le même dans les deux modes.
  static const brumeClaire = Color(0xFFD7DCE4);

  // Couleurs d'état (hors marque, pour ne jamais confondre réussite et alerte).
  static const succes = CouleurLive(0xFF1E7B4F, 0xFF3DBB7E);
  static const erreur = CouleurLive(0xFFC62828, 0xFFFF6B6B);

  /// Texte secondaire (contraste 5,9 : 1 sur blanc, 6,8 : 1 sur la surface sombre).
  static const gris = CouleurLive(0xFF5B6573, 0xFF9AA6B5);

  // Surfaces et filets.
  /// Fond des pages, des cartes et des panneaux.
  static const surface = CouleurLive(0xFFFFFFFF, 0xFF121A24);

  /// Fond léger des champs et des boutons tonals.
  static const champ = CouleurLive(0xFFF3F5F8, 0xFF1C2633);
  static const champ2 = CouleurLive(0xFFEFF2F6, 0xFF1E2835);

  /// Voile : puces, pistes, indicateurs, fonds discrets.
  static const voile = CouleurLive(0xFFE6EBF2, 0xFF243040);

  /// Filet : séparateurs et bordures fines.
  static const filet = CouleurLive(0xFFE4E8EE, 0xFF2A3544);

  /// Bord : bordures des champs et des boutons secondaires.
  static const bord = CouleurLive(0xFFC3CAD4, 0xFF3A4656);
  static const bord2 = CouleurLive(0xFFC5CCD6, 0xFF3A4656);

  /// Fond du motif de démarrage.
  static const fondMotif = CouleurLive(0xFFFBF8F3, 0xFF0E1520);
  static const fondMotif2 = CouleurLive(0xFFF8F5EF, 0xFF0E1520);

  // Teintes claires (fonds d'étiquettes et d'encadrés).
  static const teinteVerte = CouleurLive(0xFFE7F4EC, 0xFF16301F);
  static const teinteOrange = CouleurLive(0xFFFFF1E0, 0xFF3A2A14);
  static const teinteAmbre = CouleurLive(0xFFFFF4E0, 0xFF3A2C16);
  static const teinteRouge = CouleurLive(0xFFFDECEC, 0xFF3A1D1D);
  static const teinteCreme = CouleurLive(0xFFFFF7EA, 0xFF35291A);

  static const teinteViolette = CouleurLive(0xFFF1ECFE, 0xFF2A2140);

  // Messagerie.
  static const fondConversation = CouleurLive(0xFFEEF1F5, 0xFF0B121A);
  static const bulleMoi = CouleurLive(0xFFDCEBFA, 0xFF1F3A5C);
  static const bulleVoile = CouleurLive(0xFFD9E6F2, 0xFF2A3A50);

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
const fondChamp = LiveColors.champ;

/// Thème de Live, clair ou sombre ; les couleurs suivent [LiveColors.sombre].
ThemeData liveTheme({bool sombre = false}) {
  final scheme =
      ColorScheme.fromSeed(
        seedColor: const Color(0xFF13385C),
        brightness: sombre ? Brightness.dark : Brightness.light,
        primary: LiveColors.bleu,
        secondary: LiveColors.orange,
        tertiary: LiveColors.ambre,
        error: LiveColors.erreur,
      ).copyWith(
        onPrimary: Colors.white,
        onSecondary: LiveColors.nuit,
        onTertiary: LiveColors.nuit,
        primaryContainer: LiveColors.brume,
        onPrimaryContainer: LiveColors.encre,
        secondaryContainer: LiveColors.voile,
        onSecondaryContainer: LiveColors.bleu,
        surface: LiveColors.surface,
        onSurface: LiveColors.encre,
        onSurfaceVariant: LiveColors.gris,
        outline: LiveColors.bord,
        outlineVariant: LiveColors.filet,
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
    scaffoldBackgroundColor: LiveColors.surface,
    splashFactory: InkSparkle.splashFactory,
    // Transitions de page glissées façon iOS, sur toutes les plateformes.
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        for (final p in TargetPlatform.values)
          p: const CupertinoPageTransitionsBuilder(),
      },
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: LiveColors.surface,
      foregroundColor: LiveColors.encre,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: LiveColors.encre,
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
        side: const BorderSide(color: LiveColors.bord),
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
        side: const BorderSide(color: LiveColors.filet),
      ),
    ),
    cardTheme: const CardThemeData(
      color: LiveColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: LiveColors.filet),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: _forme,
      backgroundColor: LiveColors.surface,
      selectedColor: LiveColors.bleu,
      checkmarkColor: Colors.white,
      // Texte blanc sur puce sélectionnée, quel que soit le type de puce :
      // une couleur conditionnelle, que la puce résout elle-même (un style
      // conditionnel perdrait sa couleur à la fusion).
      labelStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: WidgetStateColor.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? Colors.white
              : LiveColors.encre,
        ),
      ),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      side: const BorderSide(color: LiveColors.filet),
      showCheckmark: false,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: LiveColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      height: 64,
      indicatorColor: LiveColors.voile,
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
      backgroundColor: LiveColors.surface,
      indicatorColor: LiveColors.voile,
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
      linearTrackColor: LiveColors.voile,
    ),
    dividerTheme: const DividerThemeData(color: LiveColors.filet),
    dialogTheme: const DialogThemeData(
      backgroundColor: LiveColors.surface,
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
        borderSide: BorderSide(color: LiveColors.filet),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(rayonControle)),
        borderSide: BorderSide(color: LiveColors.filet),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(rayonControle)),
        borderSide: BorderSide(color: LiveColors.bleu, width: 1.6),
      ),
    ),
  );
}
