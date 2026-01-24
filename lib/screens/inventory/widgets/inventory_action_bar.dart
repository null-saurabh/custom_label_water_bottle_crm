import 'package:clwb_crm/core/theme/constants.dart';
import 'package:flutter/material.dart';

class InventoryActionBar extends StatelessWidget {
  const InventoryActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ActionButton(
          icon: Icons.inventory_2_outlined,
          label: 'Add Stock',
          isPrimary: true,
          onTap: () {},
        ),
        const SizedBox(width: 12),
        _ActionButton(
          icon: Icons.add_box_outlined,
          label: 'Add Item',
          onTap: () {},
        ),

        const SizedBox(width: 12),
        _ActionButton(
          icon: Icons.factory_outlined,
          label: 'Add Supplier',
          onTap: () {},
        ),

      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(

          gradient: isPrimary?AppGradients.primary:AppGradients.softBlue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isPrimary ? Colors.white : Colors.black87,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isPrimary ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: isPrimary ? Colors.white : Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}
