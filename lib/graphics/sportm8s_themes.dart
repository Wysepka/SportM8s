import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class SportM8sColors {
  // =========================
  // Core brand
  // =========================
  static const primary = Color(0xFF0F1C2E); // App shell / navy
  static const surface = Color(0xFF18283A); // Cards / sheets
  static const accent = Color(0xFFFF8C1A);  // Sport orange (CTA)

  // =========================
  // State colors
  // =========================
  static const success = Color(0xFF2FBF71);
  static const warning = Color(0xFFF2B705);
  static const error = Color(0xFFD94C4C);
  static const info = Color(0xFF3A7CA5);

  // =========================
  // Text
  // =========================
  static const textPrimary = Color(0xFFF5F7FA);
  static const textSecondary = Color(0xFFA1ACB8);

  // =========================
  // UI helpers
  // =========================
  static const divider = Color(0xFF243447);
  static const disabled = Color(0xFF5F6B78);

  // =========================
  // Orange containers
  // =========================
  static const primaryContainer = Color(0xFFFFA24D);
  static const onPrimaryContainer = primary;

  // =========================
  // Success containers
  // =========================
  static const secondaryContainer = Color(0xFF1F4A39);
  static const onSecondaryContainer = textPrimary;

  // =========================
  // Info containers
  // =========================
  static const tertiaryContainer = Color(0xFF23455A);
  static const onTertiaryContainer = textPrimary;

  // =========================
  // Error containers
  // =========================
  static const errorContainer = Color(0xFF4B1F22);
  static const onErrorContainer = textPrimary;

  // =========================
  // Surface hierarchy (Material 3)
  // =========================
  static const surfaceDim = Color(0xFF0B1420);
  static const surfaceBright = Color(0xFF223447);

  static const surfaceContainerLowest = Color(0xFF0C1726);
  static const surfaceContainerLow = Color(0xFF122235);
  static const surfaceContainer = surface;
  static const surfaceContainerHigh = Color(0xFF1A2D41);
  static const surfaceContainerHighest = Color(0xC11C2538);

  // =========================
  // Outlines
  // =========================
  static const outline = divider;
  static const outlineVariant = Color(0xFF2D3E54);

  // =========================
  // Inverse (for SnackBars etc.)
  // =========================
  static const inverseSurface = textPrimary;
  static const onInverseSurface = primary;
  static const inversePrimary = accent;

  // =========================
  // Misc
  // =========================
  static const shadow = Colors.black;
  static const scrim = Colors.black;
  static const surfaceTint = accent;
}

class SportM8sTheme {
  static ColorScheme darkScheme = const ColorScheme.dark(
    brightness: Brightness.dark,

    // Brand
    primary: SportM8sColors.accent,
    onPrimary: SportM8sColors.primary,
    primaryContainer: SportM8sColors.primaryContainer,
    onPrimaryContainer: SportM8sColors.onPrimaryContainer,

    secondary: SportM8sColors.success,
    onSecondary: SportM8sColors.primary,
    secondaryContainer: SportM8sColors.secondaryContainer,
    onSecondaryContainer: SportM8sColors.onSecondaryContainer,

    tertiary: SportM8sColors.info,
    onTertiary: SportM8sColors.textPrimary,
    tertiaryContainer: SportM8sColors.tertiaryContainer,
    onTertiaryContainer: SportM8sColors.onTertiaryContainer,

    // Errors
    error: SportM8sColors.error,
    onError: SportM8sColors.textPrimary,
    errorContainer: SportM8sColors.errorContainer,
    onErrorContainer: SportM8sColors.onErrorContainer,

    // Surfaces
    surface: SportM8sColors.surface,
    onSurface: SportM8sColors.textPrimary,
    surfaceDim: SportM8sColors.surfaceDim,
    surfaceBright: SportM8sColors.surfaceBright,

    surfaceContainerLowest: SportM8sColors.surfaceContainerLowest,
    surfaceContainerLow: SportM8sColors.surfaceContainerLow,
    surfaceContainer: SportM8sColors.surfaceContainer,
    surfaceContainerHigh: SportM8sColors.surfaceContainerHigh,
    surfaceContainerHighest: SportM8sColors.surfaceContainerHighest,

    // Background
    background: SportM8sColors.primary,
    onBackground: SportM8sColors.textPrimary,

    // Outlines
    outline: SportM8sColors.outline,
    outlineVariant: SportM8sColors.outlineVariant,

    // Inverse
    inverseSurface: SportM8sColors.inverseSurface,
    onInverseSurface: SportM8sColors.onInverseSurface,
    inversePrimary: SportM8sColors.inversePrimary,

    // Misc
    shadow: SportM8sColors.shadow,
    scrim: SportM8sColors.scrim,
    surfaceTint: SportM8sColors.surfaceTint,

  );

  static Theme datePickerTheme(Widget? child, BuildContext context) {
    final base = Theme.of(context);

    return Theme(
      data: base.copyWith(
        colorScheme: base.colorScheme.copyWith(
          // Selected day + header action color
          primary: SportM8sColors.accent,
          onPrimary: SportM8sColors.primary,

          // Dialog surface + calendar text
          surface: SportM8sColors.surface,
          onSurface: SportM8sColors.textPrimary,

          // Optional: errors
          error: SportM8sColors.error,
          onError: SportM8sColors.textPrimary,
        ),

        dialogBackgroundColor: SportM8sColors.surface,

        datePickerTheme: DatePickerThemeData(
          backgroundColor: SportM8sColors.surface,

          headerBackgroundColor: SportM8sColors.primary,
          headerForegroundColor: SportM8sColors.textPrimary,

          // "Today" outline / highlight
          todayForegroundColor: MaterialStateProperty.all(SportM8sColors.accent),

          // Day numbers
          dayForegroundColor:
          MaterialStateProperty.all(SportM8sColors.textPrimary),

          // Selected day circle + its text
          dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return SportM8sColors.accent;
            }
            return null;
          }),
          dayOverlayColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed) ||
                states.contains(MaterialState.hovered) ||
                states.contains(MaterialState.focused)) {
              return SportM8sColors.accent.withOpacity(0.12);
            }
            return null;
          }),
          dayStyle: const TextStyle(color: SportM8sColors.textPrimary),
          weekdayStyle: const TextStyle(color: SportM8sColors.textSecondary),
          yearStyle: const TextStyle(color: SportM8sColors.textPrimary),

          // Top row + dividers
          dividerColor: SportM8sColors.divider,

          // Buttons (Cancel/OK)
          cancelButtonStyle: TextButton.styleFrom(
            foregroundColor: SportM8sColors.textSecondary,
          ),
          confirmButtonStyle: TextButton.styleFrom(
            foregroundColor: SportM8sColors.accent,
          ),
        ),
      ),
      child: child!,
    );
  }

  static Theme timePickerTheme(Widget? child, BuildContext context) {
    final base = Theme.of(context);

    return Theme(
      data: base.copyWith(
        colorScheme: base.colorScheme.copyWith(
          primary: SportM8sColors.accent,
          onPrimary: SportM8sColors.primary,
          surface: SportM8sColors.surface,
          onSurface: SportM8sColors.textPrimary,
        ),

        dialogBackgroundColor: SportM8sColors.surface,

        timePickerTheme: TimePickerThemeData(
          backgroundColor: SportM8sColors.surface,

          // Header (Material 3)
          hourMinuteTextColor: SportM8sColors.textPrimary,
          hourMinuteColor: SportM8sColors.primary,

          // When selected, make the field orange
          hourMinuteTextStyle: const TextStyle(
            fontWeight: FontWeight.w800,
          ),

          dayPeriodTextColor: SportM8sColors.textPrimary,
          dayPeriodColor: SportM8sColors.primary,
          dayPeriodBorderSide: const BorderSide(color: SportM8sColors.divider),

          dialBackgroundColor: SportM8sColors.primary,
          dialTextColor: SportM8sColors.textPrimary,
          dialHandColor: SportM8sColors.accent,
          dialTextStyle: const TextStyle(fontWeight: FontWeight.w700),

          entryModeIconColor: SportM8sColors.accent,

          // Buttons
          cancelButtonStyle: TextButton.styleFrom(
            foregroundColor: SportM8sColors.textSecondary,
          ),
          confirmButtonStyle: TextButton.styleFrom(
            foregroundColor: SportM8sColors.accent,
          ),
        ),
      ),
      child: child!,
    );
  }


  static ThemeData dark() {
    final scheme = darkScheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,

      scaffoldBackgroundColor: SportM8sColors.primary,

      appBarTheme: const AppBarTheme(
        backgroundColor: SportM8sColors.primary,
        foregroundColor: SportM8sColors.textPrimary,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),

      cardTheme: CardTheme(
        color: SportM8sColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      dividerTheme: const DividerThemeData(
        color: SportM8sColors.divider,
        thickness: 1,
        space: 1,
      ),

      textTheme: const TextTheme(
        titleLarge: TextStyle(color: SportM8sColors.textPrimary, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(color: SportM8sColors.textPrimary, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: SportM8sColors.textPrimary),
        bodyMedium: TextStyle(color: SportM8sColors.textPrimary),
        bodySmall: TextStyle(color: SportM8sColors.textSecondary),
        labelLarge: TextStyle(color: SportM8sColors.textPrimary, fontWeight: FontWeight.w600),
        labelMedium: TextStyle(color: SportM8sColors.textSecondary),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SportM8sColors.accent,
          foregroundColor: SportM8sColors.primary,
          disabledBackgroundColor: SportM8sColors.disabled,
          disabledForegroundColor: SportM8sColors.textSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: SportM8sColors.accent,
          foregroundColor: SportM8sColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: SportM8sColors.textPrimary,
          side: const BorderSide(color: SportM8sColors.divider),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SportM8sColors.surface,
        hintStyle: const TextStyle(color: SportM8sColors.textSecondary),
        labelStyle: const TextStyle(color: SportM8sColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: SportM8sColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: SportM8sColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: SportM8sColors.accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: SportM8sColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: SportM8sColors.error, width: 1.5),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: SportM8sColors.surface,
        contentTextStyle: const TextStyle(color: SportM8sColors.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Call this once (e.g. in main()) to match Android status/nav bar to your theme.
  static void setSystemUi() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: SportM8sColors.primary,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }
}