// lib/features/leads/widgets/_add_lead_actions.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddLeadActions extends StatelessWidget {
  const AddLeadActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Add Lead'),
        ),
      ],
    );
  }
}
