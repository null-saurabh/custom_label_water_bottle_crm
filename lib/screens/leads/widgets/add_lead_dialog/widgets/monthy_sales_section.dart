import 'package:flutter/material.dart';

class MonthlyQuantitySection extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const MonthlyQuantitySection({super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      '100 packs',
      '5x00 packs',
      '1,000 packs',
      '5,000 packs',
      '10,000+ packs',
      'Not sure',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Monthly Water Sale",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2A44),
          ),
        ),
        const SizedBox(height: 12),

        DropdownButtonFormField<String>(
          initialValue: value.isEmpty ? null : value,
          hint: const Text("Approx Monthly Quantity*",style: TextStyle(
            fontFamily: 'Playfair Display', // Setting this to empty or null uses the system default
            color: Color(0xFF1E3A5F),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),),

          items: items
              .map(
                (e) => DropdownMenuItem(
              value: e,
              child: Text(e,style: TextStyle(
                fontFamily: 'Playfair Display', // Setting this to empty or null uses the system default
                color: Color(0xFF1E3A5F),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),),
            ),
          )
              .toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE2E6EF)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE2E6EF)),
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
