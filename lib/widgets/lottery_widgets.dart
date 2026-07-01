import 'package:flutter/material.dart';

import '../models/lottery_result.dart';
import '../models/saved_lottery_number.dart';
import 'common_widgets.dart';

class LotteryCountdownCard extends StatelessWidget {
  const LotteryCountdownCard({required this.drawDate, super.key});

  final String drawDate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleIcon(
              icon: Icons.event_available_outlined,
              color: Color(0xFF0F766E),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drawDate,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'พร้อมแจ้งเตือนเมื่อประกาศผล',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF64716D),
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.notifications_active_outlined, size: 18),
              label: const Text('เตือน'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultBanner extends StatelessWidget {
  const ResultBanner({
    required this.message,
    required this.isWinner,
    super.key,
  });

  final String message;
  final bool isWinner;

  @override
  Widget build(BuildContext context) {
    final color = isWinner ? const Color(0xFF15803D) : const Color(0xFFB45309);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          Icon(
            isWinner ? Icons.verified_outlined : Icons.info_outline,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PrizeBoard extends StatelessWidget {
  const PrizeBoard({required this.result, super.key});

  final LotteryResult result;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ผลรางวัล ${result.drawDate}',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            PrizeRow(label: 'รางวัลที่ 1', value: result.firstPrize),
            PrizeRow(
              label: 'เลขหน้า 3 ตัว',
              value: result.frontThree.join('  '),
            ),
            PrizeRow(
              label: 'เลขท้าย 3 ตัว',
              value: result.backThree.join('  '),
            ),
            PrizeRow(label: 'เลขท้าย 2 ตัว', value: result.lastTwo),
          ],
        ),
      ),
    );
  }
}

class PrizeRow extends StatelessWidget {
  const PrizeRow({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF64716D)),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0F766E),
            ),
          ),
        ],
      ),
    );
  }
}

class SavedNumberTile extends StatelessWidget {
  const SavedNumberTile({
    required this.item,
    required this.status,
    required this.onDelete,
    super.key,
  });

  final SavedLotteryNumber item;
  final SavedNumberStatus status;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      SavedNumberStatus.waiting => const Color(0xFF64748B),
      SavedNumberStatus.winner => const Color(0xFF15803D),
      SavedNumberStatus.notWinner => const Color(0xFFB45309),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 78,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item.number,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.drawDate,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.note,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF64716D),
                    ),
                  ),
                ],
              ),
            ),
            CategoryPill(label: status.label, color: color),
            IconButton(
              tooltip: 'ลบเลข',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}
