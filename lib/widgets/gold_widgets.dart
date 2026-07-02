import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import 'common_widgets.dart';

class GoldSummaryCard extends StatelessWidget {
  const GoldSummaryCard({this.expanded = false, super.key});

  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final gold = mockGold;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleIcon(
                  icon: Icons.diamond_outlined,
                  color: Color(0xFFB45309),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ราคาทองวันนี้',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        gold.updatedAt,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                ChangePill(value: gold.changeText),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: PriceColumn(
                    title: 'ทองแท่งขายออก',
                    value: gold.barSell,
                    accent: const Color(0xFFB45309),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PriceColumn(
                    title: 'ทองรูปพรรณขายออก',
                    value: gold.ornamentSell,
                    accent: const Color(0xFF0F766E),
                  ),
                ),
              ],
            ),
            if (expanded) ...[
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: PriceColumn(
                      title: 'ทองแท่งซื้อเข้า',
                      value: gold.barBuy,
                      accent: const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PriceColumn(
                      title: 'รูปพรรณซื้อเข้า',
                      value: gold.ornamentBuy,
                      accent: const Color(0xFF475569),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class PriceColumn extends StatelessWidget {
  const PriceColumn({
    required this.title,
    required this.value,
    required this.accent,
    super.key,
  });

  final String title;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayAccent = isDark
        ? Color.lerp(accent, Colors.white, 0.48)!
        : accent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: displayAccent,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class GoldChartCard extends StatelessWidget {
  const GoldChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final values = [38, 44, 41, 48, 46, 54, 58];
    final barColor = isDark ? const Color(0xFFE58E45) : const Color(0xFFB45309);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'แนวโน้ม 7 วัน',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 112,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final value in values) ...[
                    Expanded(
                      child: Container(
                        height: value.toDouble(),
                        decoration: BoxDecoration(
                          color: barColor.withValues(alpha: 0.84),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    if (value != values.last) const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoldCalculatorCard extends StatelessWidget {
  const GoldCalculatorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'คำนวณราคาทอง',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                GoldWeightChip(label: '1 บาท', value: '41,100'),
                GoldWeightChip(label: '2 สลึง', value: '20,550'),
                GoldWeightChip(label: '1 สลึง', value: '10,275'),
                GoldWeightChip(label: 'ครึ่งสลึง', value: '5,138'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GoldWeightChip extends StatelessWidget {
  const GoldWeightChip({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF322313) : const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0xFF8B5E28) : const Color(0xFFFDE68A),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            '$value บาท',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: isDark ? const Color(0xFFFFCF8A) : const Color(0xFF92400E),
            ),
          ),
        ],
      ),
    );
  }
}
