import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/models/order_delivery_entry_model.dart';

class DashboardRepository {
  final FirebaseFirestore _db;
  DashboardRepository(this._db);

  CollectionReference get _orders => _db.collection('orders');
  CollectionReference get _deliveries => _db.collection('order_delivery_entries');

  // Orders due between dates (uses nextDeliveryDate)
  Stream<List<OrderModel>> watchOrdersDueBetween({
    required DateTime start,
    required DateTime end,
    int limit = 300,
  }) {
    return _orders
        .where('isActive', isEqualTo: true)
        .where('nextDeliveryDate',
        isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('nextDeliveryDate',
        isLessThan: Timestamp.fromDate(end))
        .orderBy('nextDeliveryDate')
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => OrderModel.fromDoc(d)).toList());
  }

  // Orders created between (for weekly "new orders" count)
  Stream<List<OrderModel>> watchOrdersCreatedBetween({
    required DateTime start,
    required DateTime end,
    int limit = 600,
  }) {
    return _orders
        .where('isActive', isEqualTo: true)
        .where('createdAt',
        isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('createdAt', isLessThan: Timestamp.fromDate(end))
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => OrderModel.fromDoc(d)).toList());
  }

  // Recurring orders
  Stream<List<OrderModel>> watchRecurringOrders({int limit = 80}) {
    return _orders
        .where('isActive', isEqualTo: true)
        .where('isRecurring', isEqualTo: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => OrderModel.fromDoc(d)).toList());
  }

  // Delivery entries in range (for delivered-per-day chart + completed-today flag)
  Stream<List<OrderDeliveryEntryModel>> watchDeliveriesBetween({
    required DateTime start,
    required DateTime end,
    int limit = 1200,
  }) {
    return _deliveries
        .where('deliveryDate',
        isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('deliveryDate', isLessThan: Timestamp.fromDate(end))
        .orderBy('deliveryDate', descending: false)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => OrderDeliveryEntryModel.fromDoc(d)).toList());
  }
}
