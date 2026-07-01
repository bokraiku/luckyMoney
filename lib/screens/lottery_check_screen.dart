import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/app_backgrounds.dart';
import '../models/lottery_result.dart';
import '../providers/app_providers.dart';
import '../widgets/app_page.dart';
import '../widgets/common_widgets.dart';
import '../widgets/lottery_widgets.dart';

class LotteryCheckScreen extends ConsumerStatefulWidget {
  const LotteryCheckScreen({super.key});

  @override
  ConsumerState<LotteryCheckScreen> createState() => _LotteryCheckScreenState();
}

class _LotteryCheckScreenState extends ConsumerState<LotteryCheckScreen> {
  final TextEditingController _controller = TextEditingController();
  LotteryCheckResult? _checkResult;
  int _selectedDrawIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkNumber(LotteryResult result) {
    final value = _controller.text.trim();
    setState(() {
      _checkResult = value.length == 6
          ? result.check(value)
          : const LotteryCheckResult(number: '', hits: []);
    });
  }

  Future<void> _saveNumber(LotteryResult result) async {
    final value = _controller.text.trim();
    if (value.length != 6) {
      return;
    }

    await ref
        .read(savedNumbersControllerProvider.notifier)
        .addNumber(
          number: value,
          drawDate: result.drawDate,
          note: 'บันทึกจากหน้าตรวจหวย',
        );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('บันทึกเลขแล้ว')));
  }

  @override
  Widget build(BuildContext context) {
    final draws = ref.watch(lotteryResultsProvider);

    return AppPage(
      backgroundImage: AppBackgrounds.lottery,
      title: 'ตรวจหวย',
      subtitle: 'เลือกงวด กรอกเลข แล้วบันทึกไว้ตรวจซ้ำได้',
      child: draws.when(
        data: (results) {
          final safeIndex = _selectedDrawIndex.clamp(0, results.length - 1);
          final selectedResult = results[safeIndex];
          final isValidNumber = _controller.text.trim().length == 6;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ตรวจรางวัล',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        value: safeIndex,
                        decoration: const InputDecoration(
                          labelText: 'งวดที่ต้องการตรวจ',
                          prefixIcon: Icon(Icons.event_outlined),
                        ),
                        items: [
                          for (var i = 0; i < results.length; i++)
                            DropdownMenuItem(
                              value: i,
                              child: Text(results[i].drawDate),
                            ),
                        ],
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedDrawIndex = value;
                            _checkResult = null;
                          });
                        },
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
                        onChanged: (_) => setState(() => _checkResult = null),
                        onSubmitted: (_) => _checkNumber(selectedResult),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () => _checkNumber(selectedResult),
                              icon: const Icon(Icons.search),
                              label: const Text('ตรวจรางวัล'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton.filledTonal(
                            tooltip: 'บันทึกเลข',
                            onPressed: isValidNumber
                                ? () => _saveNumber(selectedResult)
                                : null,
                            icon: const Icon(Icons.bookmark_add_outlined),
                          ),
                        ],
                      ),
                      if (_checkResult != null) ...[
                        const SizedBox(height: 14),
                        ResultBanner(
                          message: _checkResult!.number.isEmpty
                              ? 'กรุณากรอกเลข 6 หลัก'
                              : _checkResult!.message,
                          isWinner: _checkResult!.isWinner,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              PrizeBoard(result: selectedResult),
              const SizedBox(height: 12),
              const AdSlot(label: 'Ad'),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
      ),
    );
  }
}
