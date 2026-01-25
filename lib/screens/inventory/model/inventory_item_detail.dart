import 'package:clwb_crm/screens/inventory/model/bottle_config.dart';
import 'package:clwb_crm/screens/inventory/model/cap_config.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_item_model.dart';
import 'package:clwb_crm/screens/inventory/model/label_config.dart';
import 'package:clwb_crm/screens/inventory/model/package_config.dart';

class InventoryItemDetail {
  final InventoryItemModel item;
  final BottleConfig? bottle;
  final CapConfig? cap;
  final LabelConfig? label;
  final PackagingConfig? packaging;

  InventoryItemDetail({
    required this.item,
    this.bottle,
    this.cap,
    this.label,
    this.packaging,
  });
}
