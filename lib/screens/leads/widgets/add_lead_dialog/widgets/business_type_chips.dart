import 'package:flutter/material.dart';

class BusinessTypeChips extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onChanged;

  const BusinessTypeChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const _items = [
    "Restaurant",
    "Café",
    "Hotel / Resort",
    "Banquet Hall",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _items.map((item) {
        final isSelected = selected == item;

        return InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => onChanged(item),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF3558C9)
                  : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF3558C9)
                    : const Color(0xFFE2E8F0),
              ),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color:
                  const Color(0xFF3558C9).withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                )
              ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  item,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color:
                    isSelected ? Colors.white : const Color(0xFF1F2A44),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
