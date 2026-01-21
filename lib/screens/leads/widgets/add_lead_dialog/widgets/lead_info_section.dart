import 'package:clwb_crm/screens/leads/widgets/add_lead_dialog/widgets/input_fields.dart';
import 'package:flutter/material.dart';

class LeadInfoSection extends StatelessWidget {
  final TextEditingController businessCtrl;
  final TextEditingController contactCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController emailCtrl;
  final String? businessNameError;
  final String? phoneError;



  const LeadInfoSection({
    super.key,
    required this.businessCtrl,
    required this.contactCtrl,
    required this.phoneCtrl,
    required this.emailCtrl, this.businessNameError,this.phoneError,
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Lead Details",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2A44),
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: InputField(
                controller: contactCtrl,
                hint: "Contact Person Name*",
                suffixIcon: const Icon(Icons.person, color: Colors.grey),
                errorText: businessNameError,
                validator: (v) =>
                v == null || v.trim().isEmpty ? "Required" : null,
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: InputField(
                controller: businessCtrl,
                hint: "Business / Brand Name",
                //   errorText: businessNameError,
                suffixIcon: const Icon(Icons.business_center_rounded, color: Colors.grey),
                //   validator: (v) =>
                //   v == null || v.trim().isEmpty ? "Required" : null,
              ),
            ),

          ],
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: InputField(
                controller: phoneCtrl,
                hint: "Mobile Number*",
                errorText: phoneError,
                keyboardType: TextInputType.phone,
                suffixIcon: const Icon(Icons.local_phone_rounded, color: Colors.grey),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return "Required";
                  if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v)) {
                    return "Invalid number";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InputField(
                controller: emailCtrl,
                hint: "Email Address",
                keyboardType: TextInputType.emailAddress,
                suffixIcon: const Icon(Icons.email, color: Colors.grey),
                validator: (v) {
                  if (v == null || v.isEmpty) return null;
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                    return "Invalid email";
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}


