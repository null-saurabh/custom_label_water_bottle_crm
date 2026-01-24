import 'package:flutter/material.dart';

class OverviewStockCards extends StatelessWidget {
  const OverviewStockCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            _ValueCard(
              title: 'Current Stock Value',
              value: '\$2,700',
              sub: '(10,800 Bottles)',
            ),
            SizedBox(width: 16),
            _ValueCard(
              title: 'Sold Stock Value',
              value: '\$38,200',
              sub: '(2,400 Bottles)',
              editable: true,
            ),
          ],
        ),
        SizedBox(height: 16,),
        Row(
          children: const [
            _ValueCard(
              title: 'Recurring Orders',
              value: '211',
              sub: '(10,800 Bottles)',
            ),
            SizedBox(width: 16),
            _ValueCard(
              title: 'Payment Due',
              value: '\$38,200',
              sub: 'of 2000',
              editable: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _ValueCard extends StatelessWidget {
  final String title;
  final String value;
  final String sub;
  final bool editable;

  const _ValueCard({
    required this.title,
    required this.value,
    required this.sub,
    this.editable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey.shade50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title,
                    style: TextStyle(color: Colors.grey.shade600)),
                if (editable) ...[
                  const Spacer(),
                  const Icon(Icons.edit, size: 16),
                ]
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(sub, style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}
