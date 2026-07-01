import 'package:flutter/material.dart';

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
