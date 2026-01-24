import 'package:flutter/material.dart';

class InventoryStatCards extends StatelessWidget {
  const InventoryStatCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children:  [
        _StatCard(
          icon: Icons.inventory_2_outlined,
          value: '5',
          label: 'Total Items',
        ),
        SizedBox(width: 16),
        _StatCard(
          icon: Icons.factory_outlined,
          value: '4',
          label: 'Suppliers',
        ),
        SizedBox(width: 16),
        _StatCard(
          icon: Icons.schedule_outlined,
          value: '\$3,200',
          label: 'Orders Due This Week',
        ),
        SizedBox(width: 16),
        _StatCard(
          icon: Icons.account_balance_wallet_outlined,
          value: '\$45,550',
          label: 'Total Stock Value',
          bgColor: Colors.green.shade50,
        ),
        SizedBox(width: 16),
        _StatCard(
          icon: Icons.trending_up_outlined,
          value: '\$45,550',
          label: 'Total Stock Value', bgColor: Colors.purple.shade50,


        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? bgColor;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {


    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: bgColor ?? Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Icon(icon, size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
