import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import 'app_shell.dart';

class LuckyMoneyApp extends ConsumerWidget {
  const LuckyMoneyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const seed = Color(0xFF0F766E);
    final themeMode = ref.watch(themeModeControllerProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lucky Money',
      theme: _buildTheme(seed: seed, brightness: Brightness.light),
      darkTheme: _buildTheme(seed: seed, brightness: Brightness.dark),
      themeMode: themeMode.asData?.value ?? ThemeMode.light,
      home: const AppShell(),
    );
  }

  ThemeData _buildTheme({required Color seed, required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );
    final outline = isDark ? const Color(0xFF3B4D48) : const Color(0xFFDCE3DE);
    final surface = isDark ? const Color(0xFF17221F) : const Color(0xF7FFFFFF);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF0C1412)
          : const Color(0xFFF6F7F4),
      cardTheme: CardThemeData(
        color: surface,
        elevation: isDark ? 1 : 0.5,
        shadowColor: isDark ? Colors.black54 : const Color(0x22000000),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: outline.withValues(alpha: 0.88)),
        ),
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        backgroundColor: isDark
            ? const Color(0xFC0F1B19)
            : const Color(0xF8FFFFFF),
        indicatorColor: colorScheme.primary.withValues(alpha: 0.16),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            color: selected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF14211E) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? const Color(0xFF24332F) : null,
      ),
    );
  }
}
