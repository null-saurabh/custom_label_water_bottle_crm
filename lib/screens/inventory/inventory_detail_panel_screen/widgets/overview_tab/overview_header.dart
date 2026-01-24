import 'package:flutter/material.dart';

class OverviewHeader extends StatelessWidget {
  const OverviewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 120,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.blue.shade50,
          ),
          child: const Icon(
            Icons.local_drink,
            size: 48,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Round Bottle 500 ML',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12),
              _Spec(label: 'Item ID', value: 'BOT-500-RND'),
              _Spec(label: 'Type', value: 'Bottle'),
              _Spec(label: 'Size', value: '500 ML'),
              _Spec(label: 'Pack Size', value: '24 Bottles / Pack'),
              _Spec(label: 'Shape', value: 'Round'),
              _Spec(label: 'Neck Type', value: '28mm'),
            ],
          ),
        ),
      ],
    );
  }
}

class _Spec extends StatelessWidget {
  final String label;
  final String value;

  const _Spec({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              '$label:',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
