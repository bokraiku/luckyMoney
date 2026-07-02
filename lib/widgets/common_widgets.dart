import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  const CircleIcon({
    required this.icon,
    required this.color,
    this.size = 44,
    super.key,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = _readableAccent(context, color);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: isDark ? 0.2 : 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: iconColor, size: size * 0.5),
    );
  }
}

class CategoryPill extends StatelessWidget {
  const CategoryPill({required this.label, required this.color, super.key});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = _readableAccent(context, color);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: textColor.withValues(alpha: isDark ? 0.2 : 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class ChangePill extends StatelessWidget {
  const ChangePill({required this.value, super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark
        ? const Color(0xFF123522)
        : const Color(0xFFDCFCE7);
    final foreground = isDark
        ? const Color(0xFF9CF3B7)
        : const Color(0xFF15803D);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        value,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

Color _readableAccent(BuildContext context, Color color) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? Color.lerp(color, Colors.white, 0.35)! : color;
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    this.actionLabel,
    this.onTap,
    super.key,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(onPressed: onTap, child: Text(actionLabel!)),
      ],
    );
  }
}

class AdSlot extends StatelessWidget {
  const AdSlot({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 72,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
    );
  }
}

class QuickAction extends StatelessWidget {
  const QuickAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleIcon(icon: icon, color: color, size: 38),
              const SizedBox(height: 14),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
