import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedFullInventoryDummyData() async {
  final db = FirebaseFirestore.instance;
  final now = Timestamp.now();

  /// =========================
  /// INVENTORY ITEMS
  /// =========================
  final item1Ref = db.collection('inventory_items').doc();
  final item2Ref = db.collection('inventory_items').doc();

  await item1Ref.set({
    'id': item1Ref.id,
    'category': 'bottle',
    'name': 'Round Bottle 500 ML',
    'description': 'Standard 500ml round bottle',
    'stock': 450,
    'reorderLevel': 1000,
    'isActive': true,
    'createdAt': now,
    'updatedAt': now,
  });

  await item2Ref.set({
    'id': item2Ref.id,
    'category': 'cap',
    'name': 'White Cap 28mm',
    'description': 'White plastic cap',
    'stock': 1200,
    'reorderLevel': 2000,
    'isActive': true,
    'createdAt': now,
    'updatedAt': now,
  });

  /// =========================
  /// BOTTLE CONFIG
  /// =========================
  await db.collection('bottle_configs').doc(item1Ref.id).set({
    'itemId': item1Ref.id,
    'sizeMl': 500,
    'shape': 'Round',
    'neckType': '28mm',
  });

  /// =========================
  /// CAP CONFIG
  /// =========================
  await db.collection('cap_configs').doc(item2Ref.id).set({
    'itemId': item2Ref.id,
    'size': '28mm',
    'color': 'White',
    'material': 'Plastic',
  });

  /// =========================
  /// LABEL CONFIG
  /// =========================
  await db.collection('label_configs').doc().set({
    'itemId': item1Ref.id,
    'widthMm': 90,
    'heightMm': 50,
    'material': 'BOPP',
    'isClientSpecific': false,
  });

  /// =========================
  /// PACKAGING CONFIG
  /// =========================
  await db.collection('packaging_configs').doc().set({
    'itemId': item1Ref.id,
    'type': 'Box',
    'capacity': 24,
  });

  /// =========================
  /// SUPPLIERS
  /// =========================
  final supplier1Ref = db.collection('suppliers').doc();
  final supplier2Ref = db.collection('suppliers').doc();

  await supplier1Ref.set({
    'id': supplier1Ref.id,
    'name': 'AquaPure Pvt Ltd',
    'contactPerson': 'Rakesh',
    'phone': '9876543210',
    'email': 'sales@aquapure.com',
    'address': 'Delhi',
    'isActive': true,
    'createdAt': now,
    'updatedAt': now,
  });

  await supplier2Ref.set({
    'id': supplier2Ref.id,
    'name': 'CapWorks India',
    'contactPerson': 'Anil',
    'phone': '9123456789',
    'email': 'contact@capworks.com',
    'address': 'Mumbai',
    'isActive': true,
    'createdAt': now,
    'updatedAt': now,
  });

  /// =========================
  /// SUPPLIER ↔ ITEM MAPPING
  /// =========================
  await db.collection('supplier_items').doc().set({
    'id': db.collection('supplier_items').doc().id,
    'supplierId': supplier1Ref.id,
    'itemId': item1Ref.id,
    'supplierSku': 'AQ-BOT-500',
    'costPerUnit': 14.0,
    'createdAt': now,
  });

  await db.collection('supplier_items').doc().set({
    'id': db.collection('supplier_items').doc().id,
    'supplierId': supplier2Ref.id,
    'itemId': item2Ref.id,
    'supplierSku': 'CW-CAP-28',
    'costPerUnit': 1.8,
    'createdAt': now,
  });

  /// =========================
  /// INVENTORY STOCK ENTRIES
  /// =========================
  final stock1Ref = db.collection('inventory_stocks').doc();
  final stock2Ref = db.collection('inventory_stocks').doc();

  await stock1Ref.set({
    'id': stock1Ref.id,
    'itemId': item1Ref.id,
    'supplierId': supplier1Ref.id,
    'orderedQuantity': 1000,
    'receivedQuantity': 800,
    'ratePerUnit': 14.0,
    'totalAmount': 14000,
    'paidAmount': 10000,
    'dueAmount': 4000,
    'status': 'partial',
    'createdAt': now,
    'updatedAt': now,
  });

  await stock2Ref.set({
    'id': stock2Ref.id,
    'itemId': item2Ref.id,
    'supplierId': supplier2Ref.id,
    'orderedQuantity': 3000,
    'receivedQuantity': 3000,
    'ratePerUnit': 1.8,
    'totalAmount': 5400,
    'paidAmount': 5400,
    'dueAmount': 0,
    'status': 'received',
    'createdAt': now,
    'updatedAt': now,
  });

  /// =========================
  /// INVENTORY ACTIVITIES
  /// =========================
  await db
      .collection('inventory_items')
      .doc(item1Ref.id)
      .collection('activities')
      .doc()
      .set({
    'id': '',
    'title': 'Stock Added',
    'description': '1000 bottles purchased from AquaPure',
    'stockDelta': 1000,
    'amount': 14000,
    'createdAt': now,
  });

  await db
      .collection('inventory_items')
      .doc(item2Ref.id)
      .collection('activities')
      .doc()
      .set({
    'id': '',
    'title': 'Stock Added',
    'description': '3000 caps purchased from CapWorks',
    'stockDelta': 3000,
    'amount': 5400,
    'createdAt': now,
  });

  // print('✅ Full inventory dummy data seeded successfully');
}
