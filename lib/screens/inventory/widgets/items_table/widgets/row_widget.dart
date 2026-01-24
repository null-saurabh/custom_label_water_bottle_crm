import 'package:flutter/material.dart';

class InventoryRow extends StatelessWidget {
  final VoidCallback onDetailTap;
  final String itemName;
  final String subText;
  final String inStock;
  final String orderDueMonth;
  final String orderDueWeek;
  final String currentValue;
  final String soldValue;

  const   InventoryRow({super.key, required this.itemName, required this.subText, required this.inStock, required this.orderDueMonth, required this.orderDueWeek, required this.currentValue, required this.soldValue, required this.onDetailTap});



  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _itemCell(2),
        _stockBadge(1),
        _textCell(orderDueWeek,1.2),
        _textCell(orderDueMonth,1.4),
        _greenText(currentValue,1.4),
        _textCell(soldValue,1.4),
    SizedBox(
    width: 32,
    child: IconButton(onPressed: onDetailTap,
    icon: Icon(Icons.arrow_forward_ios,color: Colors.grey,size: 16,)),
    ),
      ],
    );
  }

  Widget _itemCell(double flex) {
    return Expanded(
      flex: (flex * 10).toInt(),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(itemName, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(
            subText,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }



  Widget _stockBadge(double flex) {
    return Expanded(
      flex: (flex * 10).toInt(),

      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            inStock,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }


  Widget _textCell(String text,double flex) {
    return Expanded(
      flex: (flex * 10).toInt(),

      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _greenText(String text,double flex) {
    return Expanded(
      flex: (flex * 10).toInt(),


      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.green,
        ),
      ),
    );
  }
}

