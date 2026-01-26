import 'package:clwb_crm/core/widgets/premium_button.dart';
import 'package:flutter/material.dart';

class OrdersFiltersRow extends StatelessWidget {
  const OrdersFiltersRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FilterDropdown(
          label: 'All Clients',
          items: const ['All Clients', 'Cafe Snowtrail', 'Elite Dine'],
        ),
        const SizedBox(width: 12),
        _FilterDropdown(
          label: 'All Delivery Dates',
          items: const [
            'All Delivery Dates',
            'Today',
            'Tomorrow',
            'Next 7 Days',
          ],
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: PremiumButton(text: "+  Add Order", onTap: (){}),
        )

      ],
    );
  }
}

class _FilterDropdown extends StatefulWidget {
  final String label;
  final List<String> items;

  const _FilterDropdown({
    required this.label,
    required this.items,
  });

  @override
  State<_FilterDropdown> createState() => _FilterDropdownState();
}

class _FilterDropdownState extends State<_FilterDropdown> {
  late String selected;

  @override
  void initState() {
    super.initState();
    selected = widget.items.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selected,
          items: widget.items
              .map(
                (e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
          )
              .toList(),
          onChanged: (v) {
            if (v == null) return;
            setState(() => selected = v);
          },
        ),
      ),
    );
  }
}
