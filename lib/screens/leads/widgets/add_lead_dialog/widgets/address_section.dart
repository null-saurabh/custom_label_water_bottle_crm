import 'package:clwb_crm/screens/leads/widgets/add_lead_dialog/widgets/input_fields.dart';
import 'package:flutter/material.dart';

class DeliveryInfoSection extends StatelessWidget {
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController deliveryController;
  final TextEditingController notesController;

  const DeliveryInfoSection({super.key,
    required this.cityController,
    required this.stateController,
    required this.deliveryController,
    required this.notesController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: InputField(
                hint: "City",
                controller: cityController,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InputField(
                hint: "State",
                controller: stateController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        /// Expected delivery location with helper INSIDE field


        InputField(
          hint: "Area",
          controller: deliveryController,
        ),


        const SizedBox(height: 16),
        InputField(
          hint: "Notes",
          controller: notesController,
        ),



      ],
    );
  }
}
