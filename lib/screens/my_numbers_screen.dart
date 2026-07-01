import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/app_backgrounds.dart';
import '../models/lottery_result.dart';
import '../providers/app_providers.dart';
import '../widgets/app_page.dart';
import '../widgets/common_widgets.dart';
import '../widgets/lottery_widgets.dart';

class MyNumbersScreen extends ConsumerWidget {
  const MyNumbersScreen({super.key});

  Future<void> _showAddDialog(
    BuildContext context,
    WidgetRef ref,
    LotteryResult latestResult,
  ) async {
    final numberController = TextEditingController();
    final noteController = TextEditingController();

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('เพิ่มเลขของฉัน'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                key: const Key('saved-number-input'),
                controller: numberController,
                maxLength: 6,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                decoration: const InputDecoration(
                  counterText: '',
                  labelText: 'เลขสลาก 6 หลัก',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: 'หมายเหตุ',
                  hintText: 'เช่น ซื้อไว้ 2 ใบ',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('ยกเลิก'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('บันทึก'),
            ),
          ],
        );
      },
    );

    if (shouldSave == true && numberController.text.trim().length == 6) {
      await ref
          .read(savedNumbersControllerProvider.notifier)
          .addNumber(
            number: numberController.text.trim(),
            drawDate: latestResult.drawDate,
            note: noteController.text,
          );
    }

    numberController.dispose();
    noteController.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedNumbers = ref.watch(savedNumbersControllerProvider);
    final latestResult = ref.watch(latestLotteryResultProvider);

    return AppPage(
      backgroundImage: AppBackgrounds.numbers,
      title: 'เลขของฉัน',
      subtitle: 'บันทึกเลขไว้ตรวจและแจ้งเตือน',
      actions: [
        latestResult.maybeWhen(
          data: (result) => IconButton(
            tooltip: 'เพิ่มเลข',
            onPressed: () => _showAddDialog(context, ref, result),
            icon: const Icon(Icons.add),
          ),
          orElse: () => const SizedBox.shrink(),
        ),
      ],
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
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
                          'พร้อมตรวจเลขที่บันทึก',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'เลขใหม่จะผูกกับงวดล่าสุดโดยอัตโนมัติ',
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
          latestResult.when(
            data: (result) => savedNumbers.when(
              data: (numbers) {
                if (numbers.isEmpty) {
                  return const _EmptyNumbersCard();
                }

                return Column(
                  children: [
                    for (final item in numbers)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SavedNumberTile(
                          item: item,
                          status: item.statusFor(result),
                          onDelete: () => ref
                              .read(savedNumbersControllerProvider.notifier)
                              .deleteNumber(item.id),
                        ),
                      ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text(error.toString()),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text(error.toString()),
          ),
        ],
      ),
    );
  }
}

class _EmptyNumbersCard extends StatelessWidget {
  const _EmptyNumbersCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text('ยังไม่มีเลขที่บันทึก'),
      ),
    );
  }
}
