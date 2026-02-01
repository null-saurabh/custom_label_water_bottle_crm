import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottleSizeSection extends StatelessWidget {
  final RxList<String> selected; // ✅ RxList
  const BottleSizeSection({
    super.key,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    const sizes = ['250 ml', '500 ml', '1 L', 'Not sure'];

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

        Obx(() {
          return Wrap(
            spacing: 24,
            runSpacing: 12,
            children: sizes.map((size) {
              final isSelected = selected.contains(size);

              void toggle() {
                // special rule: "Not sure" should be exclusive (optional)
                if (size == 'Not sure') {
                  if (isSelected) {
                    selected.remove(size);
                  } else {
                    selected.assignAll(['Not sure']);
                  }
                  return;
                }

                // if selecting a real size, remove "Not sure"
                selected.remove('Not sure');

                if (isSelected) {
                  selected.remove(size);
                } else {
                  selected.add(size);
                }
              }

              return InkWell(
                onTap: toggle,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: isSelected,
                      onChanged: (_) => toggle(),
                    ),
                    Text(size),
                  ],
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}
