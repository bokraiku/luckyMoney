import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/app_backgrounds.dart';
import '../data/mock_data.dart';
import '../providers/app_providers.dart';
import '../widgets/app_page.dart';
import '../widgets/common_widgets.dart';
import '../widgets/gold_widgets.dart';
import '../widgets/lottery_widgets.dart';
import '../widgets/news_widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({required this.onSelectTab, super.key});

  final ValueChanged<int> onSelectTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestResult = ref.watch(latestLotteryResultProvider);

    return AppPage(
      backgroundImage: AppBackgrounds.home,
      title: 'Lucky Money',
      subtitle: 'ตรวจหวย ราคาทอง ข่าวเงิน',
      actions: [
        IconButton(
          tooltip: 'แจ้งเตือน',
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
        ),
      ],
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          const GoldSummaryCard(),
          const SizedBox(height: 12),
          latestResult.when(
            data: (result) => LotteryCountdownCard(drawDate: result.drawDate),
            loading: () => const _LoadingCard(),
            error: (error, _) => _ErrorCard(message: error.toString()),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: QuickAction(
                  icon: Icons.fact_check_outlined,
                  title: 'ตรวจเลข',
                  subtitle: 'เลือกงวดและตรวจรางวัล',
                  color: const Color(0xFF0F766E),
                  onTap: () => onSelectTab(1),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: QuickAction(
                  icon: Icons.add_card_outlined,
                  title: 'บันทึกเลข',
                  subtitle: 'เก็บไว้ตรวจอัตโนมัติ',
                  color: const Color(0xFFB45309),
                  onTap: () => onSelectTab(2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SectionHeader(
            title: 'ข่าวเด่นวันนี้',
            actionLabel: 'ทั้งหมด',
            onTap: () => onSelectTab(4),
          ),
          const SizedBox(height: 8),
          ...mockNews
              .take(3)
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: NewsTile(item: item),
                ),
              ),
          const AdSlot(label: 'Sponsored'),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(16), child: Text(message)),
    );
  }
}
