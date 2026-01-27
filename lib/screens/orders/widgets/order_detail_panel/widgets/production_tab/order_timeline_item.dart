import 'package:flutter/material.dart';

enum OrderTimelineType {
  production,
  delivery,
  expense,
}

class OrderTimelineItem {
  final OrderTimelineType type;
  final DateTime date;
  final String title;
  final String subtitle;
  final String trailing;
  final IconData icon;

  OrderTimelineItem({
    required this.type,
    required this.date,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.icon,
  });
}
