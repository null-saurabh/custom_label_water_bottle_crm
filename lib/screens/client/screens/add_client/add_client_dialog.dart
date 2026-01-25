import 'package:clwb_crm/core/widgets/premium_button.dart';
import 'package:clwb_crm/screens/client/screens/add_client/add_client_controller.dart';
import 'package:clwb_crm/screens/leads/widgets/add_lead_dialog/widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddClientDialog extends GetView<AddClientController> {
  const AddClientDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AddClientController());

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 40,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 40,
                offset: const Offset(0, 24),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Client',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              // const SizedBox(height: 10),
              const Divider(color: Color(0xFFE6EDF3), thickness: 1, height: 24),


              const SizedBox(height: 20),
              Flexible(child: SingleChildScrollView(
                child: Column(
                  children: [
                    _BasicInfoSection(),

                    const SizedBox(height: 20),
                    _ContactInfoSection(),

                    const SizedBox(height: 20),
                    _LocationSection(),

                  ],
                ),
              )),

              const SizedBox(height: 32),


              const Divider(color: Color(0xFFE6EDF3), thickness: 1, height: 24),

              Obx(() =>PremiumButton(
                text: 'Submit',
                onTap: (){controller.submit();},
                isLoading: controller.isSubmitting.value,
              )),

              const Divider(color: Color(0xFFE6EDF3), thickness: 1, height: 24),



            ],
          ),
        ),
      ),
    );
  }
}




class _BasicInfoSection extends GetView<AddClientController> {
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Business Info',
      child: Column(
        children: [
          InputField(
            controller: controller.businessCtrl,
            hint: "Business Name*",
            suffixIcon: const Icon(Icons.person, color: Colors.grey),
            errorText: controller.businessError.value,
        validator: (v) =>
        v == null || v.trim().isEmpty ? "Required" : null,

          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            initialValue: controller.businessType.value.isEmpty
                ? null
                : controller.businessType.value,
            hint: const Text("Business Type",style: TextStyle(
              color: Color(0xFF1E3A5F),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),),
            items: const [
              DropdownMenuItem(value: 'Hotel', child: Text('Hotel')),
              DropdownMenuItem(value: 'Restaurant', child: Text('Restaurant')),
              DropdownMenuItem(value: 'Cafe', child: Text('Cafe')),
              DropdownMenuItem(value: 'Retail', child: Text('Retail')),
            ],
            onChanged: (v) => controller.businessType.value = v ?? '',
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

          const SizedBox(height: 12),
          InputField(
            controller: controller.gstCtrl,
            hint: "GST Number",

          ),
        ],
      ),
    );
  }
}




class _ContactInfoSection extends GetView<AddClientController> {
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Contact Info',
      child: Column(
        children: [
          InputField(
            controller: controller.contactPersonCtrl,
            hint: "Contact Name",
          ),
          const SizedBox(height: 12),
          InputField(
            controller: controller.contactPersonRoleCtrl,
            hint: "Contact Role",

          ),
          const SizedBox(height: 12),
          InputField(
            controller: controller.phoneCtrl,
            hint: "Mobile Number*",
            errorText: controller.phoneError.value,
            keyboardType: TextInputType.phone,
            suffixIcon: const Icon(Icons.local_phone_rounded, color: Colors.grey),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return "Required";
              if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v)) {
                return "Invalid number";
              }
              return null;
            },),
          const SizedBox(height: 12),
          InputField(
            controller: controller.emailCtrl,
            hint: "Email",

          ),
        ],
      ),
    );
  }
}




class _LocationSection extends GetView<AddClientController> {
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Location',
      child: Column(
        children: [
          InputField(
            controller: controller.areaCtrl,
            hint: "Area",
          ),
          const SizedBox(height: 12),

          InputField(
            controller: controller.cityCtrl,
            hint: "City",
          ),
          const SizedBox(height: 12),
          InputField(
            controller: controller.addressCtrl,
            hint: "Full Delivery Address",
          ),

        ],
      ),
    );
  }
}




class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
