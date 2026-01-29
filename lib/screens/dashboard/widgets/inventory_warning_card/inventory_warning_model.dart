import 'package:clwb_crm/screens/inventory/model/inventory_item_model.dart';

class DashboardInventoryWarningRowModel {
  final String displayName;
  // final String sizeCode;
  final int due;
  final int stock;
  final int shortfall;
  final int reOrderValue;
  final InventoryCategory category;

  DashboardInventoryWarningRowModel({
    required this.displayName,
    required this.category,
    required this.due,
    required this.stock,
    required this.reOrderValue,
    required this.shortfall,
  });
}
