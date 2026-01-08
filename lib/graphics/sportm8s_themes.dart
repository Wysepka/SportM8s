import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class SportM8sColors {
  // Core
  static const primary = Color(0xFF0F1C2E); // Midnight Navy (scaffold/app shell)
  static const surface = Color(0xFF18283A); // Dark Steel (cards/sheets)
  static const accent = Color(0xFFFF8C1A); // Sport Orange (CTA)
  static const success = Color(0xFF2FBF71); // Active Green

  // Text
  static const textPrimary = Color(0xFFF5F7FA);
  static const textSecondary = Color(0xFFA1ACB8);

  // UI
  static const divider = Color(0xFF243447);
  static const disabled = Color(0xFF5F6B78);

  // Status
  static const warning = Color(0xFFF2B705);
  static const error = Color(0xFFD94C4C);
  static const info = Color(0xFF3A7CA5);

  static const surfaceContainerHighest = const Color(0xC11C2538);
}

class SportM8sTheme {
  static ColorScheme darkScheme = const ColorScheme.dark(
    primary: SportM8sColors.primary,
    onPrimary: SportM8sColors.textPrimary,

    secondary: SportM8sColors.accent,
    onSecondary: Color(0xFF0F1C2E), // readable on orange

    tertiary: SportM8sColors.success,
    onTertiary: Color(0xFF0F1C2E),

    surface: SportM8sColors.surface,
    onSurface: SportM8sColors.textPrimary,

    background: SportM8sColors.primary,
    onBackground: SportM8sColors.textPrimary,

    error: SportM8sColors.error,
    onError: SportM8sColors.textPrimary,

    surfaceContainerHighest: SportM8sColors.surfaceContainerHighest,

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