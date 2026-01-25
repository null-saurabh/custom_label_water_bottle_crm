import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const DatePickerField({
    super.key,
    required this.label,
    required this.onChanged,
    this.value,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    final text = value == null
        ? ''
        : DateFormat('dd MMM yyyy').format(value!);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: value ?? DateTime.now(),
            firstDate: firstDate ?? DateTime(2020),
            lastDate: lastDate ?? DateTime(2100),
          );

          if (picked != null) {
            onChanged(picked);
          }
        },
        child: IgnorePointer(
          child: TextField(
            controller: TextEditingController(text: text),
            decoration: InputDecoration(
              labelText: label,
              suffixIcon: const Icon(Icons.calendar_today),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
