// lib/features/leads/widgets/_add_lead_form.dart

import 'package:clwb_crm/screens/leads/leads_controller.dart';
import 'package:clwb_crm/screens/leads/widgets/add_lead_dialog/add_lead_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddLeadForm extends GetView<LeadsController> {
  const AddLeadForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(child: _NameField()),
            SizedBox(width: 16),
            Expanded(child: _PhoneField()),
          ],
        ),
        const SizedBox(height: 16),

        // BUSINESS TYPE (NO MANUAL TYPE)
        const _BusinessTypeSelector(),

        const SizedBox(height: 16),
        Row(
          children: const [
            Expanded(child: _InterestSizeField()),
            SizedBox(width: 16),
            Expanded(child: _MonthlyQtyField()),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: const [
            Expanded(child: _StateField()),
            SizedBox(width: 16),
            Expanded(child: _CityField()),
          ],
        ),
        const SizedBox(height: 16),

        // LOCATION / AREA (ONLY ONCE)
        const _LocationField(),
      ],
    );
  }
}






// lib/features/leads/widgets/_lead_fields.dart

class _NameField extends StatelessWidget {
  const _NameField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Name *',
        hintText: 'Enter name',
        prefixIcon: Icon(Icons.person_outline),
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        labelText: 'Phone Number *',
        hintText: '+91 XXXXX XXXXX',
        prefixIcon: Icon(Icons.phone_outlined),
      ),
    );
  }
}

class _MonthlyQtyField extends StatelessWidget {
  const _MonthlyQtyField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Approx. Monthly Quantity',
      ),
    );
  }
}



// lib/features/leads/widgets/_business_type_selector.dart

class _BusinessTypeSelector extends GetView<AddLeadController> {
  const _BusinessTypeSelector();

  @override
  Widget build(BuildContext context) {
    final types = ['Restaurant', 'Cafe', 'Hotel / Resort', 'Banquet Hall'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Business Type',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: types.map((t) {
            return Obx(
                  () => ChoiceChip(
                label: Text(t),
                selected: controller.selectedBusinessType.value == t,
                onSelected: (_) =>
                controller.selectedBusinessType.value = t,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}


// lib/features/leads/widgets/_interest_fields.dart

class _InterestSizeField extends StatelessWidget {
  const _InterestSizeField();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Bottle Size Interest',
      ),
      items: const [
        DropdownMenuItem(value: '500ml', child: Text('500 ml')),
        DropdownMenuItem(value: '1L', child: Text('1 Liter')),
      ],
      onChanged: (_) {},
    );
  }
}

class _StateField extends StatelessWidget {
  const _StateField();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'State (optional)',
      ),
      items: const [],
      onChanged: (_) {},
    );
  }
}

class _CityField extends StatelessWidget {
  const _CityField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'City (optional)',
      ),
    );
  }
}

class _LocationField extends StatelessWidget {
  const _LocationField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Location / Area (optional)',
        prefixIcon: Icon(Icons.location_on_outlined),
      ),
    );
  }
}

