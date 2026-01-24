import 'package:flutter/material.dart';

class SupplierRow extends StatelessWidget {
  final VoidCallback onDetailTap;

  final String itemName;
  final String subText;
  final String inStock;
  final String orderDueMonth;
  final String orderDueWeek;
  final String currentValue;
  final String soldValue;

  const SupplierRow({super.key, required this.itemName, required this.subText, required this.inStock, required this.orderDueMonth, required this.orderDueWeek, required this.currentValue, required this.soldValue, required this.onDetailTap});



  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _itemCell(1.6),
        _textCell(orderDueWeek,1.5),
        _textCell(orderDueMonth,1),
        _textCell(orderDueMonth,1.2),
        _redText(currentValue,1.4),
        _greenText(soldValue,1.2),
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




  Widget _menu() {
    return const SizedBox(
      width: 32,
      child: Icon(Icons.arrow_forward_ios,color: Colors.grey,size: 16,),
    );
  }

  Widget _textCell(String text,double flex) {
    return Expanded(
      flex: (flex * 10).toInt(),

      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 14),
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


  Widget _redText(String text,double flex) {
    return Expanded(
      flex: (flex * 10).toInt(),


      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.red,
        ),
      ),
    );
  }
}

