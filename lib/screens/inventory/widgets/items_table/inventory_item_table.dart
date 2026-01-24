import 'package:clwb_crm/screens/inventory/widgets/items_table/widgets/row_widget.dart';
import 'package:clwb_crm/screens/inventory/widgets/items_table/widgets/table_header.dart';
import 'package:flutter/material.dart';

class InventoryItemsTable extends StatelessWidget {
  final VoidCallback onDetailTap;
  const InventoryItemsTable({super.key, required this.onDetailTap});

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
          Text("Items",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
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
                hintText: 'Search Items...',
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
              TableHeader(),
              const Divider(height: 1),

              Padding(
                padding: const EdgeInsets.symmetric(vertical:8,horizontal: 20),
                child: InventoryRow(
                  itemName: 'Round Bottle',
                  subText: '500 ML',
                  inStock: '450',
                  orderDueMonth: '600',
                  orderDueWeek: '250',
                  currentValue: '\$2,700',
                  soldValue: '\$38,200', onDetailTap: onDetailTap,
                ),
              ),
              const Divider(height: 1,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                child: InventoryRow(
                  itemName: 'Round Bottle',
                  subText: '1 Liter',
                  inStock: '450',
                  orderDueMonth: '\$9,600',
                  orderDueWeek: '\$2,250',
                  currentValue: '\$3,000',
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
