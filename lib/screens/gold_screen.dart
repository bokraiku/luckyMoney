import 'package:flutter/material.dart';

import '../app/app_backgrounds.dart';
import '../data/mock_data.dart';
import '../widgets/app_page.dart';
import '../widgets/common_widgets.dart';
import '../widgets/gold_widgets.dart';
import '../widgets/news_widgets.dart';

class GoldScreen extends StatelessWidget {
  const GoldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      backgroundImage: AppBackgrounds.gold,
      title: 'ราคาทอง',
      subtitle: 'อัปเดตล่าสุด 14:32 น.',
      actions: [
        IconButton(
          tooltip: 'ตั้งเตือนราคา',
          onPressed: () {},
          icon: const Icon(Icons.add_alert_outlined),
        ),
      ],
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          const GoldSummaryCard(expanded: true),
          const SizedBox(height: 12),
          const GoldChartCard(),
          const SizedBox(height: 12),
          const GoldCalculatorCard(),
          const SizedBox(height: 12),
          SectionHeader(title: 'ข่าวทอง', actionLabel: 'ดูเพิ่ม', onTap: () {}),
          const SizedBox(height: 8),
          ...mockNews
              .where((item) => item.category == 'ราคาทอง')
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: NewsTile(item: item),
                ),
              ),
        ],
      ),
    );
  }
}
