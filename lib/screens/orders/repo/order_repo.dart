import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/screens/inventory/model/bottle_config.dart';
import 'package:clwb_crm/screens/orders/models/order_activity_model.dart';
import 'package:clwb_crm/screens/orders/models/order_delivery_entry_model.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/models/order_production_entry_model.dart';

class OrdersRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ===========================
  // COLLECTION REFS
  // ===========================

  CollectionReference get _ordersRef =>
      _firestore.collection('orders');

  CollectionReference _productionRef(String orderId) =>
      _ordersRef.doc(orderId).collection('production_entries');

  CollectionReference _deliveryRef(String orderId) =>
      _ordersRef.doc(orderId).collection('delivery_entries');

  CollectionReference _activitiesRef(String orderId) =>
      _ordersRef.doc(orderId).collection('activities');

  // ===========================
  // ORDER CRUD
  // ===========================
  Future<OrderModel> createOrder(OrderModel order) async {
    final docRef = _ordersRef.doc();

    final orderWithId = order.copyWith(
      id: docRef.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await docRef.set(orderWithId.toMap());

    return orderWithId;
  }


  // Future<String> createOrder(OrderModel order) async {
  //   final docRef = _ordersRef.doc();
  //   await docRef.set(order.toMap());
  //   return docRef.id;
  // }

  Future<void> updateOrder(String orderId, Map<String, dynamic> data) async {
    // print("inupf");
    await _ordersRef.doc(orderId).update(data);
    // print("inupf22");


  }

  Future<void> softDeleteOrder(String orderId) async {
    await _ordersRef.doc(orderId).update({
      'isActive': false,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String> generateNextOrderNumber() async {
    final ref = _firestore.doc('meta/order_counter');

    return _firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);

      int last = 100;
      if (snap.exists) {
        last = snap.data()!['lastOrder'] ?? 100;
      }

      final next = last + 1;

      tx.set(ref, {'lastOrder': next}, SetOptions(merge: true));

      return '#ORD-$next';
    });
  }


  Future<OrderModel?> getOrderById(String orderId) async {
    final doc = await _ordersRef.doc(orderId).get();
    if (!doc.exists) return null;
    return OrderModel.fromDoc(doc);
  }

  // ===========================
  // ORDER STREAMS
  // ===========================

  // Stream<List<OrderModel>> watchAllOrders() {
  //   return _ordersRef
  //       .where('isActive', isEqualTo: true)
  //       .orderBy('createdAt', descending: true)
  //       .snapshots()
  //       .map((snap) => snap.docs.map((d) => OrderModel.fromDoc(d)).toList());
  // }

  Stream<List<OrderModel>> watchAllOrders() {
    return _ordersRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => OrderModel.fromDoc(d)).toList());
  }



  Stream<OrderModel?> watchOrderById(String orderId) {
    return _ordersRef.doc(orderId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return OrderModel.fromDoc(doc);
    });
  }

  Future<BottleConfig?> getBottleConfig(String itemId) async {
    final snap = await _firestore
        .collection('bottle_configs')
        .doc(itemId)
        .get();

    if (!snap.exists) return null;

    return BottleConfig.fromMap(snap.data()!);
  }


  // ===========================
  // PRODUCTION ENTRIES
  // ===========================

  Future<String> addProductionEntry(
      OrderProductionEntryModel entry,
      ) async {
    final docRef = _productionRef(entry.orderId).doc();
    await docRef.set(entry.toMap());
    return docRef.id;
  }

  Stream<List<OrderProductionEntryModel>> watchProductionEntries(
      String orderId,
      ) {
    return _productionRef(orderId)
        .orderBy('productionDate', descending: false)
        .snapshots()
        .map((snap) =>
        snap.docs.map((d) => OrderProductionEntryModel.fromDoc(d)).toList());
  }

  // ===========================
  // DELIVERY ENTRIES
  // ===========================

  Future<String> addDeliveryEntry(
      OrderDeliveryEntryModel entry,
      ) async {
    final docRef = _deliveryRef(entry.orderId).doc();
    await docRef.set(entry.toMap());
    return docRef.id;
  }

  Stream<List<OrderDeliveryEntryModel>> watchDeliveryEntries(
      String orderId,
      ) {
    return _deliveryRef(orderId)
        .orderBy('deliveryDate', descending: false)
        .snapshots()
        .map((snap) =>
        snap.docs.map((d) => OrderDeliveryEntryModel.fromDoc(d)).toList());
  }

  // ===========================
  // ACTIVITIES
  // ===========================

  Future<void> addActivity(
      String orderId,
      OrderActivityModel activity,
      ) async {
    final docRef = _activitiesRef(orderId).doc();
    await docRef.set(activity.toMap());
  }

  Stream<List<OrderActivityModel>> watchActivities(String orderId) {
    return _activitiesRef(orderId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) =>
        snap.docs.map((d) => OrderActivityModel.fromDoc(d)).toList());
  }

  // ===========================
  // TRANSACTIONAL UPDATES
  // ===========================

  Future<void> runOrderTransaction(
      String orderId, {
        OrderProductionEntryModel? productionEntry,
        OrderDeliveryEntryModel? deliveryEntry,
        Map<String, dynamic>? orderUpdateData,
        OrderActivityModel? activity,
      }) async {
    final orderRef = _ordersRef.doc(orderId);

    await _firestore.runTransaction((tx) async {
      final orderSnap = await tx.get(orderRef);
      if (!orderSnap.exists) {
        throw Exception('Order not found');
      }

      if (orderUpdateData != null) {
        tx.update(orderRef, orderUpdateData);
      }

      if (productionEntry != null) {
        final prodRef = _productionRef(orderId).doc();
        tx.set(prodRef, productionEntry.toMap());
      }

      if (deliveryEntry != null) {
        final delRef = _deliveryRef(orderId).doc();
        tx.set(delRef, deliveryEntry.toMap());
      }

      if (activity != null) {
        final actRef = _activitiesRef(orderId).doc();
        tx.set(actRef, activity.toMap());
      }
    });
  }
}
