import 'package:flutter/material.dart';

import '../models/gold_snapshot.dart';
import '../models/lottery_result.dart';
import '../models/news_item.dart';
import '../models/saved_lottery_number.dart';

const mockGold = GoldSnapshot(
  barBuy: '41,000',
  barSell: '41,100',
  ornamentBuy: '40,264',
  ornamentSell: '41,600',
  changeText: '+150',
  updatedAt: 'อัปเดตล่าสุด 14:32 น.',
);

const mockLotteryResults = [
  LotteryResult(
    drawDate: 'งวด 1 ก.ค. 2569',
    firstPrize: '123456',
    frontThree: ['123', '456'],
    backThree: ['789', '012'],
    lastTwo: '89',
  ),
  LotteryResult(
    drawDate: 'งวด 16 มิ.ย. 2569',
    firstPrize: '908189',
    frontThree: ['771', '034'],
    backThree: ['111', '234'],
    lastTwo: '56',
  ),
];

List<SavedLotteryNumber> seedSavedNumbers() {
  final now = DateTime.now();

  return [
    SavedLotteryNumber(
      id: 'seed-1',
      number: '123456',
      drawDate: mockLotteryResults.first.drawDate,
      note: 'ซื้อไว้ 1 ใบ',
      createdAt: now.subtract(const Duration(days: 2)),
    ),
    SavedLotteryNumber(
      id: 'seed-2',
      number: '908189',
      drawDate: mockLotteryResults.first.drawDate,
      note: 'รอตรวจงวดถัดไป',
      createdAt: now.subtract(const Duration(days: 1)),
    ),
    SavedLotteryNumber(
      id: 'seed-3',
      number: '771234',
      drawDate: mockLotteryResults.last.drawDate,
      note: 'บันทึกจากร้านประจำ',
      createdAt: now.subtract(const Duration(days: 12)),
    ),
  ];
}

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
