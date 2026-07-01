import 'package:flutter/material.dart';

import '../app/app_backgrounds.dart';
import '../data/mock_data.dart';
import '../widgets/app_page.dart';
import '../widgets/common_widgets.dart';
import '../widgets/news_widgets.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      backgroundImage: AppBackgrounds.news,
      title: 'ข่าวเงิน',
      subtitle: 'ข่าวสั้นที่เกี่ยวกับเงินในกระเป๋า',
      actions: [
        IconButton(
          tooltip: 'ค้นหา',
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
      ],
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          const CategoryChips(),
          const SizedBox(height: 12),
          for (var index = 0; index < mockNews.length; index++) ...[
            NewsTile(item: mockNews[index]),
            if (index == 2)
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: AdSlot(label: 'Sponsored'),
              )
            else
              const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
