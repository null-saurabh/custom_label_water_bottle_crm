import 'package:flutter/material.dart';

class SalesEmptyState extends StatelessWidget {
  final String text;
  const SalesEmptyState(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text, style: const TextStyle(color: Color(0xFF6B7280))),
    );
  }
}
