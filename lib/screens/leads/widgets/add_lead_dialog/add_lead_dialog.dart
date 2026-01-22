// lib/features/leads/widgets/add_lead_dialog.dart

import 'package:clwb_crm/core/widgets/premium_button.dart';
import 'package:clwb_crm/screens/leads/widgets/add_lead_dialog/add_lead_controller.dart';
import 'package:clwb_crm/screens/leads/widgets/add_lead_dialog/widgets/address_section.dart';
import 'package:clwb_crm/screens/leads/widgets/add_lead_dialog/widgets/bottle_size_form.dart';
import 'package:clwb_crm/screens/leads/widgets/add_lead_dialog/widgets/business_type_chips.dart';
import 'package:clwb_crm/screens/leads/widgets/add_lead_dialog/widgets/lead_info_section.dart';
import 'package:clwb_crm/screens/leads/widgets/add_lead_dialog/widgets/monthy_sales_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AddLeadDialog extends GetView<AddLeadController> {
   const AddLeadDialog({super.key});


  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: Container(
            // margin: const EdgeInsets.symmetric(vertical: 60),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Add Lead",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2A44),
                      ),
                    ),
                    IconButton(onPressed: (){
                      Get.back();
                    }, icon: Icon(Icons.close,size: 28,))

                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFE6EDF3), thickness: 1, height: 24),
                const SizedBox(height: 16),

            Obx(() =>LeadInfoSection(
                  businessCtrl: controller.businessCtrl,
                  contactCtrl: controller.contactCtrl,
                  phoneCtrl: controller.phoneCtrl,
                  emailCtrl: controller.emailCtrl,
                  businessNameError: controller.businessError.value,
                  phoneError: controller.phoneError.value,
                )),
                const SizedBox(height: 28),

            Obx(() =>Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BusinessTypeChips(
                      selected: controller.selectedBusinessType.value,
                      onChanged: (value) {
                        controller.selectedBusinessType.value = value;
                        controller.typeError.value = null; // clear error on change
                      },
                    ),
                    if (controller.typeError.value != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6, left: 4),
                        child: Text(
                          controller.typeError.value!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                  ],
                )),

                const SizedBox(height: 20),

            Obx(() =>Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MonthlyQuantitySection(
                      value: controller.monthlyQuantity.value,
                      onChanged: (val) {
                          controller.monthlyQuantity.value = val;
                          controller.qtyError.value = null;
                      },
                    ),

                    if (controller.qtyError.value != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6, left: 4),
                        child: Text(
                          controller.qtyError.value!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                  ],
                )),

                SizedBox(height: 20),

            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BottleSizeSection(
                      selected: controller.bottleSizes,
                      onChanged: (val) {
                        controller.bottleSizes.value = val;
                        controller.bottleError.value = null;
                      },
                    ),

                    if (controller.bottleError.value != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6, left: 4),
                        child: Text(
                          controller.bottleError.value!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                  ],
                )),

                //
                SizedBox(height: 12),

                DeliveryInfoSection(
                  cityController: controller.cityCtrl,
                  stateController: controller.stateCtrl,
                  deliveryController: controller.areaCtrl,
                  notesController: controller.notesCtrl,
                ),
                const SizedBox(height: 12),

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
      ),
    );
  }
}



















//  String? monthlyQuantity; // dropdown value
//
//   final Set<String> bottleSizes = {};