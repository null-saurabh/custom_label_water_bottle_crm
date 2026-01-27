import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedDummyOrders() async {
  final db = FirebaseFirestore.instance;
  final now = Timestamp.now();

  // Pick existing IDs from your DB
  final itemSnap = await db.collection('inventory_items').limit(1).get();
  final clientSnap = await db.collection('clients').limit(1).get();

  if (itemSnap.docs.isEmpty || clientSnap.docs.isEmpty) {
    // print('❌ Need at least 1 item and 1 client');
    return;
  }

  final itemId = itemSnap.docs.first.id;
  final clientId = clientSnap.docs.first.id;

  await db.collection('orders').add({
    'clientId': clientId,
    'itemId': itemId,
    'quantityPacks': 100,
    'bottlesPerPack': 24,
    'totalBottles': 2400,
    'ratePerPack': 120,
    'totalAmount': 12000,
    'deliveredBottles': 1200,
    'status': 'partial',
    'deliveryDate': Timestamp.fromDate(
      DateTime.now().add(const Duration(days: 3)),
    ),
    'createdAt': now,
  });

  await db.collection('orders').add({
    'clientId': clientId,
    'itemId': itemId,
    'quantityPacks': 50,
    'bottlesPerPack': 24,
    'totalBottles': 1200,
    'ratePerPack': 130,
    'totalAmount': 6500,
    'deliveredBottles': 1200,
    'status': 'delivered',
    'deliveryDate': Timestamp.fromDate(
      DateTime.now().subtract(const Duration(days: 2)),
    ),
    'createdAt': now,
  });

  // print('✅ Dummy orders seeded');
}
