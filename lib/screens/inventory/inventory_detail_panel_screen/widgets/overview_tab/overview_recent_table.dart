import 'package:clwb_crm/core/widgets/blue_action_button.dart';
import 'package:flutter/material.dart';

class OverviewRecentTable extends StatelessWidget {
  const OverviewRecentTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Text(
                'Overview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              BlueActionButton(icon: Icons.add, label: "Add Stock", onTap: (){},isPrimary: true,)

            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: _Header(),
        ),
        const Divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),

          child: const _Row(
            date: 'April 15, 2024',
            qty: '2000 Packs',
            balance: '\$2,800',
            status: 'Partial',
          ),
        ),
        const Divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),

          child: const _Row(
            date: 'Jan 30, 2024',
            qty: '1000 Packs',
            balance: '\$1,800',
            status: 'Partial',
          ),
        ),const Divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),

          child: const _Row(
            date: 'Jan 30, 2024',
            qty: '1000 Packs',
            balance: '\$1,800',
            status: 'Partial',
          ),
        ),const Divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),

          child: const _Row(
            date: 'Jan 30, 2024',
            qty: '1000 Packs',
            balance: '\$1,800',
            status: 'Partial',
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle style =
    TextStyle(color: Colors.grey.shade600, fontSize: 13);

    return Row(
      children: [
        _col('Date', style),
        _col('Quantity', style),
        _col('Pending Balance', style),
        _col('Status', style),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  final String date;
  final String qty;
  final String balance;
  final String status;

  const _Row({
    required this.date,
    required this.qty,
    required this.balance,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _cell(date),
        _cell(qty),
        _cell(balance),
        _statusChip(),
      ],
    );
  }

  Widget _statusChip() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }

  Widget _cell(String text) {
    return Expanded(
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}

Widget _col(String t, TextStyle s) =>
    Expanded(child: Text(t, style: s));
