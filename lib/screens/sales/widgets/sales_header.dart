import 'package:clwb_crm/core/utils/responsive.dart';
import 'package:clwb_crm/screens/sales/sales_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesHeader extends StatelessWidget {
  final SalesController c;
  const SalesHeader(this.c, {super.key});

  @override
  Widget build(BuildContext context) {
    return context.isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sales',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  _PresetDropdown(c),
                  const SizedBox(width: 12),

                  OutlinedButton.icon(
                    onPressed: () => c.openCustomDatePicker(),
                    icon: const Icon(Icons.date_range_outlined, size: 18),
                    label: const Text('Custom Range'),
                  ),
                ],
              )

            ],
          )
        : Row(
            children: [
              const Text(
                'Sales',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(width: 16),

              _PresetDropdown(c),
              const SizedBox(width: 12),

              OutlinedButton.icon(
                onPressed: () => c.openCustomDatePicker(),
                icon: const Icon(Icons.date_range_outlined, size: 18),
                label: const Text('Custom Range'),
              ),
            ],
          );
  }
}

class _PresetDropdown extends StatelessWidget {
  final SalesController c;
  const _PresetDropdown(this.c);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // 🔥 If controller is in custom mode, fallback visually
      final value = c.preset.value == SalesRangePreset.custom
          ? SalesRangePreset.thisMonth
          : c.preset.value;

      return DropdownButtonHideUnderline(
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE6EAF2)),
          ),
          child: DropdownButton<SalesRangePreset>(
            value: value,
            items: const [
              DropdownMenuItem(
                value: SalesRangePreset.thisMonth,
                child: Text('This Month'),
              ),
              DropdownMenuItem(
                value: SalesRangePreset.last30Days,
                child: Text('Last 30 Days'),
              ),
              DropdownMenuItem(
                value: SalesRangePreset.all,
                child: Text('All Time'),
              ),
            ],
            onChanged: (v) {
              if (v == null) return;
              c.setPreset(v);
            },
          ),
        ),
      );
    });
  }
}
