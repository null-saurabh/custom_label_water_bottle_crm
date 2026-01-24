import 'package:clwb_crm/screens/inventory/widgets/supplier_table/widgets/supplier_header.dart';
import 'package:clwb_crm/screens/inventory/widgets/supplier_table/widgets/supplier_row.dart';
import 'package:flutter/material.dart';

class InventorySupplierTable extends StatelessWidget {
  final VoidCallback onDetailTap;
  const InventorySupplierTable({super.key, required this.onDetailTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Manufacturers",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
          SizedBox(height: 16,),
          Container(
            height: 44,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.grey.shade400)
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Manufacturers...',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon:  Icon(Icons.search,color: Colors.grey.shade400,),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          SizedBox(height: 16,),
          Container(
            decoration:BoxDecoration(
              // borderRadius: BorderRadius.circular(1),
              // border: Border.all(color: Colors.grey.shade400)
            ),
            child: Column(
              children: [
                SupplierHeader(),
                const Divider(height: 1),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical:8,horizontal: 20),
                  child: SupplierRow(
                    itemName: 'AquaPure Pvt. Ltd.',
                    subText: 'Bottles & Caps',
                    inStock: '450',
                    orderDueMonth: '52',
                    orderDueWeek: 'Bottles & Caps',
                    currentValue: '\$2,100',
                    soldValue: '\$38,200', onDetailTap: onDetailTap
                  ),
                ),
                const Divider(height: 1,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                  child: SupplierRow(
                    itemName: 'Design Print Solution',
                    subText: 'Labels',
                    inStock: '450',
                    orderDueMonth: '52',
                    orderDueWeek: 'BoPP Levels',
                    currentValue: '\$2,000',
                    soldValue: '\$25,500', onDetailTap: onDetailTap,
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
