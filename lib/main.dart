import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const LuckyMoneyApp());
}

class LuckyMoneyApp extends StatelessWidget {
  const LuckyMoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF0F766E);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lucky Money',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F7F4),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Color(0xFFF6F7F4),
          foregroundColor: Color(0xFF17211F),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFFE4E8E2)),
          ),
          margin: EdgeInsets.zero,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFDCE3DE)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFDCE3DE)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: seed, width: 1.4),
          ),
        ),
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _pages = [
    HomePage(),
    LotteryCheckPage(),
    MyNumbersPage(),
    GoldPage(),
    NewsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'หน้าแรก',
          ),
          NavigationDestination(
            icon: Icon(Icons.fact_check_outlined),
            selectedIcon: Icon(Icons.fact_check),
            label: 'ตรวจหวย',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark),
            label: 'เลขของฉัน',
          ),
          NavigationDestination(
            icon: Icon(Icons.diamond_outlined),
            selectedIcon: Icon(Icons.diamond),
            label: 'ทอง',
          ),
          NavigationDestination(
            icon: Icon(Icons.feed_outlined),
            selectedIcon: Icon(Icons.feed),
            label: 'ข่าว',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
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
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const GoldSummaryCard(),
          const SizedBox(height: 12),
          const LotteryCountdownCard(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: QuickAction(
                  icon: Icons.fact_check_outlined,
                  title: 'ตรวจเลข',
                  subtitle: 'งวดล่าสุด',
                  color: const Color(0xFF0F766E),
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: QuickAction(
                  icon: Icons.add_card_outlined,
                  title: 'บันทึกเลข',
                  subtitle: 'รอตรวจอัตโนมัติ',
                  color: const Color(0xFFB45309),
                  onTap: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SectionHeader(
            title: 'ข่าวเด่นวันนี้',
            actionLabel: 'ทั้งหมด',
            onTap: () {},
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

class LotteryCheckPage extends StatefulWidget {
  const LotteryCheckPage({super.key});

  @override
  State<LotteryCheckPage> createState() => _LotteryCheckPageState();
}

class _LotteryCheckPageState extends State<LotteryCheckPage> {
  final TextEditingController _controller = TextEditingController();
  String? _message;
  bool _isWinner = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkNumber() {
    final value = _controller.text.trim();
    setState(() {
      if (value.length != 6) {
        _isWinner = false;
        _message = 'กรุณากรอกเลข 6 หลัก';
        return;
      }

      final prizes = <String>[];
      if (value == mockLotteryResult.firstPrize) {
        prizes.add('รางวัลที่ 1');
      }
      if (mockLotteryResult.frontThree.contains(value.substring(0, 3))) {
        prizes.add('เลขหน้า 3 ตัว');
      }
      if (mockLotteryResult.backThree.contains(value.substring(3))) {
        prizes.add('เลขท้าย 3 ตัว');
      }
      if (value.substring(4) == mockLotteryResult.lastTwo) {
        prizes.add('เลขท้าย 2 ตัว');
      }

      _isWinner = prizes.isNotEmpty;
      _message = prizes.isEmpty
          ? 'ไม่พบรางวัลในงวดนี้'
          : 'ถูกรางวัล: ${prizes.join(', ')}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'ตรวจหวย',
      subtitle: 'ผลสลากกินแบ่งรัฐบาล 16 มิ.ย. 2569',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'กรอกเลขสลาก',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: const Key('lottery-input'),
                    controller: _controller,
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: 'เช่น 123456',
                      prefixIcon: Icon(Icons.confirmation_number_outlined),
                    ),
                    onSubmitted: (_) => _checkNumber(),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _checkNumber,
                      icon: const Icon(Icons.search),
                      label: const Text('ตรวจรางวัล'),
                    ),
                  ),
                  if (_message != null) ...[
                    const SizedBox(height: 14),
                    ResultBanner(message: _message!, isWinner: _isWinner),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          PrizeBoard(result: mockLotteryResult),
          const SizedBox(height: 12),
          const AdSlot(label: 'Ad'),
        ],
      ),
    );
  }
}

class MyNumbersPage extends StatelessWidget {
  const MyNumbersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'เลขของฉัน',
      subtitle: 'บันทึกเลขไว้ตรวจและแจ้งเตือน',
      actions: [
        IconButton(
          tooltip: 'เพิ่มเลข',
          onPressed: () {},
          icon: const Icon(Icons.add),
        ),
      ],
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleIcon(
                    icon: Icons.alarm_on_outlined,
                    color: Color(0xFF0F766E),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ตั้งเตือนผลออกแล้ว',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'แจ้งเตือนทันทีเมื่อประกาศผลสลาก',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Switch(value: true, onChanged: (_) {}),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...mockSavedNumbers.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SavedNumberTile(item: item),
            ),
          ),
        ],
      ),
    );
  }
}

class GoldPage extends StatelessWidget {
  const GoldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
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
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
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

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
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
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
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

class AppPage extends StatelessWidget {
  const AppPage({
    required this.title,
    required this.child,
    this.subtitle,
    this.actions = const [],
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
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
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF17211F),
                          ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF64716D),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              ...actions,
            ],
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

class GoldSummaryCard extends StatelessWidget {
  const GoldSummaryCard({this.expanded = false, super.key});

  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final gold = mockGold;

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
                          color: const Color(0xFF64716D),
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

class LotteryCountdownCard extends StatelessWidget {
  const LotteryCountdownCard({super.key});

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
                    'งวดถัดไป 1 ก.ค. 2569',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'เหลือ 1 วัน 6 ชั่วโมง',
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
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: const Color(0xFF64716D)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onTap,
    super.key,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        TextButton(onPressed: onTap, child: Text(actionLabel)),
      ],
    );
  }
}

class NewsTile extends StatelessWidget {
  const NewsTile({required this.item, super.key});

  final NewsItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: item.color.withValues(alpha: 0.16),
                ),
                child: Icon(item.icon, color: item.color, size: 30),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CategoryPill(label: item.category, color: item.color),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.time,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: const Color(0xFF64716D)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF64716D),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
              'ผลรางวัลงวดล่าสุด',
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
  const SavedNumberTile({required this.item, super.key});

  final SavedLotteryNumber item;

  @override
  Widget build(BuildContext context) {
    final color = switch (item.status) {
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
            CategoryPill(label: item.statusText, color: color),
          ],
        ),
      ),
    );
  }
}

class GoldChartCard extends StatelessWidget {
  const GoldChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final values = [38, 44, 41, 48, 46, 54, 58];

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
                          color: const Color(0xFFB45309).withValues(alpha: 0.7),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(
            '$value บาท',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF92400E),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    const categories = ['ทั้งหมด', 'สลาก', 'ราคาทอง', 'สิทธิรัฐ', 'เตือนภัย'];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => ChoiceChip(
          selected: index == 0,
          label: Text(categories[index]),
          onSelected: (_) {},
        ),
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemCount: categories.length,
      ),
    );
  }
}

class AdSlot extends StatelessWidget {
  const AdSlot({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFE8EEE9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD2DBD5)),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(color: const Color(0xFF64716D)),
      ),
    );
  }
}

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
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: size * 0.5),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: const Color(0xFF64716D)),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: accent,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class ChangePill extends StatelessWidget {
  const ChangePill({required this.value, super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        value,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: const Color(0xFF15803D),
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class CategoryPill extends StatelessWidget {
  const CategoryPill({required this.label, required this.color, super.key});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class GoldSnapshot {
  const GoldSnapshot({
    required this.barBuy,
    required this.barSell,
    required this.ornamentBuy,
    required this.ornamentSell,
    required this.changeText,
    required this.updatedAt,
  });

  final String barBuy;
  final String barSell;
  final String ornamentBuy;
  final String ornamentSell;
  final String changeText;
  final String updatedAt;
}

class LotteryResult {
  const LotteryResult({
    required this.firstPrize,
    required this.frontThree,
    required this.backThree,
    required this.lastTwo,
  });

  final String firstPrize;
  final List<String> frontThree;
  final List<String> backThree;
  final String lastTwo;
}

enum SavedNumberStatus { waiting, winner, notWinner }

class SavedLotteryNumber {
  const SavedLotteryNumber({
    required this.number,
    required this.drawDate,
    required this.note,
    required this.status,
  });

  final String number;
  final String drawDate;
  final String note;
  final SavedNumberStatus status;

  String get statusText => switch (status) {
    SavedNumberStatus.waiting => 'รอผล',
    SavedNumberStatus.winner => 'ถูกรางวัล',
    SavedNumberStatus.notWinner => 'ไม่ถูก',
  };
}

class NewsItem {
  const NewsItem({
    required this.category,
    required this.title,
    required this.summary,
    required this.time,
    required this.icon,
    required this.color,
  });

  final String category;
  final String title;
  final String summary;
  final String time;
  final IconData icon;
  final Color color;
}

const mockGold = GoldSnapshot(
  barBuy: '41,000',
  barSell: '41,100',
  ornamentBuy: '40,264',
  ornamentSell: '41,600',
  changeText: '+150',
  updatedAt: 'อัปเดตล่าสุด 14:32 น.',
);

const mockLotteryResult = LotteryResult(
  firstPrize: '123456',
  frontThree: ['123', '456'],
  backThree: ['789', '012'],
  lastTwo: '89',
);

const mockSavedNumbers = [
  SavedLotteryNumber(
    number: '123456',
    drawDate: 'งวด 16 มิ.ย. 2569',
    note: 'ซื้อไว้ 1 ใบ',
    status: SavedNumberStatus.winner,
  ),
  SavedLotteryNumber(
    number: '908189',
    drawDate: 'งวด 1 ก.ค. 2569',
    note: 'รอตรวจงวดถัดไป',
    status: SavedNumberStatus.waiting,
  ),
  SavedLotteryNumber(
    number: '771234',
    drawDate: 'งวด 16 มิ.ย. 2569',
    note: 'บันทึกจากร้านประจำ',
    status: SavedNumberStatus.notWinner,
  ),
];

const mockNews = [
  NewsItem(
    category: 'ราคาทอง',
    title: 'ทองเปิดตลาดปรับขึ้น 150 บาท จับตาค่าเงินบาทช่วงบ่าย',
    summary: 'สรุปตัวเลขซื้อเข้าและขายออก พร้อมปัจจัยที่ควรติดตามวันนี้',
    time: '15 นาทีที่แล้ว',
    icon: Icons.diamond_outlined,
    color: Color(0xFFB45309),
  ),
  NewsItem(
    category: 'สลาก',
    title: 'เตรียมตรวจสลากงวด 1 ก.ค. เช็กเลขที่บันทึกไว้ล่วงหน้า',
    summary: 'ระบบจะแจ้งเตือนเมื่อผลรางวัลประกาศครบทุกประเภท',
    time: '1 ชม.ที่แล้ว',
    icon: Icons.confirmation_number_outlined,
    color: Color(0xFF0F766E),
  ),
  NewsItem(
    category: 'สิทธิรัฐ',
    title: 'เช็กปฏิทินเงินเข้าและสิทธิช่วยเหลือรอบเดือนนี้',
    summary: 'รวมวันที่ควรติดตามสำหรับผู้ถือบัตรและผู้ลงทะเบียนโครงการรัฐ',
    time: 'เช้านี้',
    icon: Icons.account_balance_wallet_outlined,
    color: Color(0xFF2563EB),
  ),
  NewsItem(
    category: 'เตือนภัย',
    title: 'ระวัง SMS ปลอมอ้างรับเงินรางวัลและขอข้อมูลบัญชี',
    summary: 'ตรวจ URL ทุกครั้งและอย่ากรอกรหัสผ่านผ่านลิงก์ที่ไม่รู้จัก',
    time: 'เมื่อวาน',
    icon: Icons.warning_amber_outlined,
    color: Color(0xFFDC2626),
  ),
  NewsItem(
    category: 'ราคาทอง',
    title: 'สรุปราคาทองย้อนหลัง 7 วัน แนวโน้มยังแกว่งในกรอบแคบ',
    summary: 'ดูกราฟย้อนหลังและตั้งเตือนเมื่อราคาเปลี่ยนเกินเป้าหมาย',
    time: 'เมื่อวาน',
    icon: Icons.show_chart,
    color: Color(0xFFB45309),
  ),
];
