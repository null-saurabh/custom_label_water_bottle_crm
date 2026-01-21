import 'package:flutter/material.dart';

class BottleSizeSection extends StatelessWidget {
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;

  const BottleSizeSection({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final sizes = ['250 ml', '500 ml', '1 L', 'Not sure'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Bottle Size",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2A44),
          ),
        ),
        const SizedBox(height: 8),

        Wrap(
          spacing: 24,
          runSpacing: 12,
          children: ['250 ml', '500 ml', '1 L', 'Not sure'].map((size) {
            final isSelected = selected.contains(size);

            return InkWell(
              onTap: () {
                final updated = List<String>.from(selected);

                if (isSelected) {
                  updated.remove(size);
                } else {
                  updated.add(size);
                }

                onChanged(updated);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: (_) {
                      final updated = List<String>.from(selected);

                      if (isSelected) {
                        updated.remove(size);
                      } else {
                        updated.add(size);
                      }

                      onChanged(updated);
                    },
                  ),
                  Text(size),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
