import 'package:flutter/material.dart';

/// ============================================================
/// APP COLOR PALETTE — PlanC
/// ============================================================
///
/// Estructura:
///   1. AppColors      → tots els valors de color crus (constants)
///   2. AppColorScheme → ColorScheme complet per a mode clar i fosc
///   3. AppSemanticColors → tokens semàntics específics de l'app
///                          (no coberts pel ColorScheme estàndard)
///
/// NORMA: cap pantalla ha d'usar mai un Color() hardcoded.
/// Sempre s'ha d'accedir via Theme.of(context).colorScheme
/// o via AppSemanticColors.
/// ============================================================

// ──────────────────────────────────────────────────────────────
// 1. RAW COLOR VALUES
// ──────────────────────────────────────────────────────────────

abstract final class AppColors {
  // ── Brand orange ─────────────────────────────────────────────
  /// Taronja principal de la marca. Base de la paleta.
  static const Color orange50 = Color(0xFFFFF4E0);
  static const Color orange100 = Color(0xFFFFE0B0);
  static const Color orange200 = Color(0xFFFFCA70);
  static const Color orange300 = Color(0xFFFFAA30);
  static const Color orange400 = Color(0xFFFC9510);
  static const Color orange500 = Color(0xFFFB8500); // ← primary brand
  static const Color orange600 = Color(0xFFE07500);
  static const Color orange700 = Color(0xFFC46400);
  static const Color orange800 = Color(0xFF9A5000);
  static const Color orange900 = Color(0xFF6B3400);

  // ── Neutrals càlids (base de superfícies i textos) ───────────
  static const Color neutral0 = Color(0xFFFFFFFF);
  static const Color neutral50 = Color(0xFFF8F6F1); // scaffold light
  static const Color neutral100 = Color(0xFFF0EDE6);
  static const Color neutral150 = Color(0xFFE9E5DD);
  static const Color neutral200 = Color(0xFFE0DBD2);
  static const Color neutral300 = Color(0xFFD0C9C0);
  static const Color neutral400 = Color(0xFF9A9088);
  static const Color neutral500 = Color(0xFF80796E);
  static const Color neutral600 = Color(0xFF4F4A42);
  static const Color neutral700 = Color(0xFF2E2B24);
  static const Color neutral750 = Color(0xFF252218);
  static const Color neutral800 = Color(0xFF1C1A14); // text dark-on-light
  static const Color neutral850 = Color(0xFF18160F); // scaffold dark
  static const Color neutral900 = Color(0xFF110F09);

  // ── Superfícies en mode fosc ──────────────────────────────────
  static const Color darkSurface0 = Color(0xFF110F09);
  static const Color darkSurface1 = Color(0xFF1D1B14);
  static const Color darkSurface2 = Color(0xFF22201A);
  static const Color darkSurface3 = Color(0xFF2A2820);
  static const Color darkSurface4 = Color(0xFF2D2A22);
  static const Color darkSurface5 = Color(0xFF38342B);

  // ── Verd (success / tickets / accions positives) ──────────────
  static const Color green50 = Color(0xFFE8F5E9);
  static const Color green200 = Color(0xFFA5D6A7);
  static const Color green500 = Color(0xFF4CAF50);
  static const Color green700 = Color(0xFF2E7D32);
  static const Color greenDark200 = Color(0xFF6DC76F);
  static const Color greenDark800 = Color(0xFF1B3E1E);

  // ── Vermell (error / accions destructives) ────────────────────
  static const Color red50 = Color(0xFFFFEDEA);
  static const Color red400 = Color(0xFFFF6B6B);
  static const Color red700 = Color(0xFFD32F2F);
  static const Color red900 = Color(0xFF8C1212);
  static const Color redDark = Color(0xFFFFB4AB);

  // ── Ambre/groc (valoracions, avisos) ─────────────────────────
  static const Color amber400 = Color(0xFFFFC107);
  static const Color amber500 = Color(0xFFF59E0B);
  static const Color amber700 = Color(0xFFE65100);

  // ── Blau (informació, notificacions) ─────────────────────────
  static const Color blue300 = Color(0xFF64B5F6);
  static const Color blue700 = Color(0xFF1565C0);

  // ── Oliva/verd secundari (accentua sense competir amb l'orange)
  static const Color olive400 = Color(0xFFA2CF78);
  static const Color olive600 = Color(0xFF5B7A40);
  static const Color olive900 = Color(0xFF182800);
  static const Color oliveDark300 = Color(0xFFBDEAA4);
  static const Color oliveDark800 = Color(0xFF2F5300);

  // ── Colors de categoria (immutables, NO canviar) ─────────────
  // Aquests s'usen als markers del mapa i als chips de filtre.
  static const Color catTotes = Color(0xFFFF9800); // taronja viu (chip "Totes")
  static const Color catExposicions = Color(0xFFF44336); // Colors.red
  static const Color catInfantil = Color(0xFFFF4081); // Colors.pinkAccent
  static const Color catTeatre = Color(0xFFFFC107); // Colors.amber
  static const Color catConcerts = Color(0xFF4CAF50); // Colors.green
  static const Color catFestes = Color(0xFFFF5722); // Colors.deepOrange
  static const Color catFestivalsIMostres = Color(0xFF9C27B0); // Colors.purple
  static const Color catConferencies = Color(0xFF00BCD4); // Colors.cyan
  static const Color catRutesIVisites = Color(0xFF2196F3); // Colors.blue
  static const Color catAltres = Color(0xFF3F51B5); // Colors.indigo
}

// ──────────────────────────────────────────────────────────────
// 2. COLOR SCHEMES (Material 3)
// ──────────────────────────────────────────────────────────────

abstract final class AppColorScheme {
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,

    // Primary (orange)
    primary: AppColors.orange500,
    onPrimary: AppColors.neutral0,
    primaryContainer: AppColors.orange200,
    onPrimaryContainer: AppColors.orange900,

    // Secondary (bru càlid — complementa el primary sense cridar l'atenció)
    secondary: Color(0xFF8B6A50),
    onSecondary: AppColors.neutral0,
    secondaryContainer: AppColors.orange200,
    onSecondaryContainer: Color(0xFF2E1600),

    // Tertiary (oliva — per accions/etiquetes de naturalesa diferent)
    tertiary: AppColors.olive600,
    onTertiary: AppColors.neutral0,
    tertiaryContainer: AppColors.olive400,
    onTertiaryContainer: AppColors.olive900,

    // Error
    error: AppColors.red700,
    onError: AppColors.neutral0,
    errorContainer: AppColors.red50,
    onErrorContainer: Color(0xFF410002),

    // Superfícies
    surface: AppColors.neutral50,
    onSurface: AppColors.neutral800,
    surfaceContainerLowest: AppColors.neutral0,
    surfaceContainerLow: AppColors.neutral150,
    surfaceContainer: AppColors.neutral200,
    surfaceContainerHigh: AppColors.neutral200,
    surfaceContainerHighest: Color(0xFFDAD5CC),

    onSurfaceVariant: AppColors.neutral600,
    outline: AppColors.neutral500,
    outlineVariant: AppColors.neutral300,

    // Inverse (per SnackBars, tooltips sobre fons fosc)
    inverseSurface: AppColors.neutral700,
    onInverseSurface: AppColors.neutral50,
    inversePrimary: AppColors.orange300,

    // Misc
    shadow: Colors.black,
    scrim: Colors.black,
    surfaceTint: AppColors.orange500,
  );

  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,

    // Primary (orange més clar per contrast sobre fons fosc)
    primary: AppColors.orange300,
    onPrimary: AppColors.orange900,
    primaryContainer: Color(0xFF6D3200),
    onPrimaryContainer: AppColors.orange100,

    // Secondary
    secondary: Color(0xFFD4B89A),
    onSecondary: Color(0xFF4A2800),
    secondaryContainer: Color(0xFF6A3E20),
    onSecondaryContainer: AppColors.orange100,

    // Tertiary
    tertiary: AppColors.olive400,
    onTertiary: Color(0xFF1E3A00),
    tertiaryContainer: AppColors.oliveDark800,
    onTertiaryContainer: AppColors.oliveDark300,

    // Error
    error: AppColors.redDark,
    onError: Color(0xFF690005),
    errorContainer: AppColors.red900,
    onErrorContainer: Color(0xFFFFDAD6),

    // Superfícies
    surface: AppColors.neutral850,
    onSurface: Color(0xFFE8E2D8),
    surfaceContainerLowest: AppColors.darkSurface0,
    surfaceContainerLow: AppColors.darkSurface2,
    surfaceContainer: AppColors.darkSurface3,
    surfaceContainerHigh: AppColors.darkSurface4,
    surfaceContainerHighest: AppColors.darkSurface5,

    onSurfaceVariant: Color(0xFFCAC4B8),
    outline: Color(0xFF958E84),
    outlineVariant: Color(0xFF4A4540),

    // Inverse
    inverseSurface: Color(0xFFE8E2D8),
    onInverseSurface: AppColors.neutral700,
    inversePrimary: AppColors.orange500,

    // Misc
    shadow: Colors.black,
    scrim: Colors.black,
    surfaceTint: AppColors.orange300,
  );
}

// ──────────────────────────────────────────────────────────────
// 3. SEMANTIC TOKENS (específics de PlanC)
//    Colors que no encaixen al ColorScheme estàndard però
//    necessiten ser consistents a tota l'app.
// ──────────────────────────────────────────────────────────────

class AppSemanticColors {
  final bool isDark;
  const AppSemanticColors({required this.isDark});

  /// Obté la instància correcta a partir del context.
  static AppSemanticColors of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return AppSemanticColors(isDark: brightness == Brightness.dark);
  }

  // ── Estat: èxit / accions positives ──────────────────────────
  Color get success => isDark ? AppColors.greenDark200 : AppColors.green700;
  Color get successSurface =>
      isDark ? AppColors.greenDark800 : AppColors.green50;
  Color get onSuccess => isDark ? AppColors.darkSurface0 : AppColors.neutral0;

  // ── Estat: avís ───────────────────────────────────────────────
  Color get warning => isDark ? AppColors.amber400 : AppColors.amber700;
  Color get warningSurface => isDark ? Color(0xFF3D2500) : Color(0xFFFFF3E0);

  // ── Estat: informació ─────────────────────────────────────────
  Color get info => isDark ? AppColors.blue300 : AppColors.blue700;
  Color get infoSurface => isDark ? Color(0xFF0D2A4A) : Color(0xFFE3F2FD);

  // ── Valoracions (estrelles) ───────────────────────────────────
  Color get ratingFilled => AppColors.amber500;
  Color get ratingEmpty => isDark ? AppColors.neutral600 : AppColors.neutral300;

  // ── Compra d'entrades ─────────────────────────────────────────
  Color get ticketButton =>
      isDark ? AppColors.greenDark200 : AppColors.green700;
  Color get ticketButtonSurface =>
      isDark ? AppColors.greenDark800 : AppColors.green50;
  Color get onTicketButton => AppColors.neutral0;

  // ── Chat ─────────────────────────────────────────────────────
  /// Bombolla de missatge propi
  Color get chatBubbleOwn => isDark ? Color(0xFF5C2800) : AppColors.orange100;
  Color get onChatBubbleOwn =>
      isDark ? AppColors.orange100 : AppColors.orange900;

  /// Bombolla de missatge de l'altre
  Color get chatBubbleOther =>
      isDark ? AppColors.darkSurface4 : AppColors.neutral150;
  Color get onChatBubbleOther =>
      isDark ? Color(0xFFE8E2D8) : AppColors.neutral800;

  /// Barra d'input del xat
  Color get chatInputFill =>
      isDark ? AppColors.darkSurface3 : AppColors.neutral100;

  // ── Mapa ─────────────────────────────────────────────────────
  /// Color de farcit del marcador per defecte (sense categoria)
  Color get markerDefault => isDark ? AppColors.orange300 : AppColors.orange500;

  // ── Camps de formulari / inputs ──────────────────────────────
  Color get inputFill => isDark ? AppColors.darkSurface3 : AppColors.neutral100;
  Color get inputBorder => isDark ? AppColors.neutral600 : AppColors.neutral300;
  Color get inputFocusBorder =>
      isDark ? AppColors.orange300 : AppColors.orange500;

  // ── Cards i contenidors ───────────────────────────────────────
  Color get cardSurface => isDark ? AppColors.darkSurface2 : AppColors.neutral0;
  Color get cardBorder =>
      isDark ? AppColors.darkSurface5 : AppColors.neutral200;

  // ── BottomNavigationBar ───────────────────────────────────────
  Color get navBarBackground =>
      isDark ? AppColors.darkSurface1 : AppColors.neutral0;
  Color get navBarSelected =>
      isDark ? AppColors.orange300 : AppColors.orange500;
  Color get navBarUnselected =>
      isDark ? Color(0xFF9A9088) : AppColors.neutral500;

  // ── AppBar ────────────────────────────────────────────────────
  Color get appBarBackground =>
      isDark ? AppColors.neutral850 : AppColors.neutral50;
  Color get appBarForeground =>
      isDark ? Color(0xFFE8E2D8) : AppColors.neutral800;

  // ── Divisors / separadors ─────────────────────────────────────
  Color get divider => isDark ? AppColors.darkSurface5 : AppColors.neutral200;

  // ── Tags / chips de categoria ─────────────────────────────────
  /// Superfície d'un chip quan NO és seleccionat
  Color get chipSurface =>
      isDark ? AppColors.darkSurface4 : AppColors.neutral150;
  Color get onChipSurface => isDark ? Color(0xFFCAC4B8) : AppColors.neutral600;

  // ── Overlays / modals ─────────────────────────────────────────
  Color get barrierColor => Colors.black.withAlpha(150);
  Color get shimmerBase =>
      isDark ? AppColors.darkSurface3 : AppColors.neutral150;
  Color get shimmerHighlight =>
      isDark ? AppColors.darkSurface5 : AppColors.neutral0;

  // ── Accions destructives ──────────────────────────────────────
  Color get destructive => isDark ? AppColors.red400 : AppColors.red700;
  Color get destructiveSurface => isDark ? AppColors.red900 : AppColors.red50;
}

// ──────────────────────────────────────────────────────────────
// 4. TEXT STYLES (jerarquia tipogràfica)
//    Usar via Theme.of(context).textTheme quan sigui possible.
//    Aquí es defineixen les mides i pesos canònics.
// ──────────────────────────────────────────────────────────────

abstract final class AppTextStyles {
  // Mides
  static const double sizeDisplay = 32;
  static const double sizeHeadline = 24;
  static const double sizeTitle = 20;
  static const double sizeBody = 16;
  static const double sizeBodySm = 14;
  static const double sizeCaption = 12;
  static const double sizeOverline = 11;

  // Pesos
  static const FontWeight weightRegular = FontWeight.w400;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightSemibold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.w700;
}

// ──────────────────────────────────────────────────────────────
// 5. RADIS I ELEVACIONS
// ──────────────────────────────────────────────────────────────

abstract final class AppRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 999; // pill / cercle
}

abstract final class AppElevation {
  static const double none = 0;
  static const double low = 1;
  static const double medium = 3;
  static const double high = 6;
}
