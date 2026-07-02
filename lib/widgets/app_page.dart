import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';

class AppPage extends ConsumerWidget {
  const AppPage({
    required this.backgroundImage,
    required this.title,
    required this.child,
    this.subtitle,
    this.actions = const [],
    super.key,
  });

  final String backgroundImage;
  final String title;
  final String? subtitle;
  final Widget child;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final themeMode = ref.watch(themeModeControllerProvider);
    final currentMode = themeMode.asData?.value ?? ThemeMode.light;
    final overlayColors = isDark
        ? [
            const Color(0xFF08100E).withValues(alpha: 0.58),
            const Color(0xFF08100E).withValues(alpha: 0.78),
            const Color(0xFF08100E).withValues(alpha: 0.94),
          ]
        : [
            Colors.white.withValues(alpha: 0.18),
            Colors.white.withValues(alpha: 0.62),
            const Color(0xFFF6F7F4).withValues(alpha: 0.94),
          ];
    final headerColor = isDark
        ? const Color(0xE61B2422)
        : Colors.white.withValues(alpha: 0.84);
    final headerBorderColor = isDark
        ? const Color(0xFF31413E)
        : Colors.white.withValues(alpha: 0.7);
    final themeToggleIcon = currentMode == ThemeMode.dark
        ? Icons.light_mode
        : Icons.dark_mode;
    final themeToggleTooltip = currentMode == ThemeMode.dark
        ? 'เปลี่ยนเป็นโหมดสว่าง'
        : 'เปลี่ยนเป็นโหมดมืด';

    return Stack(
      children: [
        Positioned.fill(child: Image.asset(backgroundImage, fit: BoxFit.cover)),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: overlayColors,
                stops: const [0, 0.38, 1],
              ),
            ),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
                decoration: BoxDecoration(
                  color: headerColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: headerBorderColor),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black38 : const Color(0x1A000000),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: colorScheme.onSurface,
                                ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              subtitle!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconTheme(
                      data: IconThemeData(color: colorScheme.primary),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...actions,
                          IconButton(
                            tooltip: themeToggleTooltip,
                            onPressed: () => ref
                                .read(themeModeControllerProvider.notifier)
                                .toggle(),
                            icon: Icon(themeToggleIcon),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: child,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
