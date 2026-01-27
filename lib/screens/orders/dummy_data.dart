// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:clwb_crm/screens/orders/models/order_model.dart';
//
//
//
//
//
//
// class OrdersDummyData {
//   static final List<OrderModel> list = [
//     // -------------------------
//     // 1) High priority, in production, partial payment
//     // -------------------------
//     OrderModel(
//       id: 'ord_001',
//       orderNumber: '#ORD-1021',
//
//       clientId: 'cafe_001',
//       clientNameSnapshot: 'Cafe Snowtrail',
//
//       itemId: 'bottle_500_round',
//       itemNameSnapshot: 'Round Bottle 500ml',
//       bottleSize: '500ml',
//       packSize: 24,
//
//       labelItemId: 'label_snowtrail',
//       labelNameSnapshot: 'Snowtrail Label',
//       capItemId: 'cap_28_white',
//       capNameSnapshot: 'White Cap 28mm',
//       packagingItemId: 'pack_carton_24',
//       packagingNameSnapshot: '24 Bottle Carton',
//
//       orderedQuantity: 1200,
//       producedQuantity: 450,
//       deliveredQuantity: 0,
//       remainingQuantity: 750,
//
//       ratePerBottle: 8.0,
//       totalAmount: 9600.0,
//       paidAmount: 3000.0,
//       dueAmount: 6600.0,
//
//       orderStatus: 'in_production',
//       productionStatus: 'printing_labels',
//       deliveryStatus: 'pending',
//
//       expectedProductionStartDate: DateTime(2026, 1, 25),
//       expectedDeliveryDate: DateTime(2026, 1, 30),
//       nextDeliveryDate: DateTime(2026, 2, 2),
//
//       isRecurring: false,
//       recurringIntervalDays: null,
//       lastRecurringGeneratedAt: null,
//       nextRecurringDate: null,
//       recurringParentOrderId: null,
//
//       notes: 'Urgent order for weekend event',
//       isPriority: true,
//
//       createdBy: 'admin',
//       createdAt: DateTime(2026, 1, 22),
//       updatedAt: DateTime(2026, 1, 25),
//       isActive: true,
//     ),
//
//     // -------------------------
//     // 2) Completed + fully paid
//     // -------------------------
//     OrderModel(
//       id: 'ord_002',
//       orderNumber: '#ORD-1022',
//
//       clientId: 'hotel_royal',
//       clientNameSnapshot: 'Hotel Royal Heights',
//
//       itemId: 'bottle_1000_square',
//       itemNameSnapshot: 'Square Bottle 1L',
//       bottleSize: '1L',
//       packSize: 12,
//
//       labelItemId: 'label_royal',
//       labelNameSnapshot: 'Royal Heights Label',
//       capItemId: 'cap_30_black',
//       capNameSnapshot: 'Black Cap 30mm',
//       packagingItemId: 'pack_shrink',
//       packagingNameSnapshot: 'Shrink Wrap',
//
//       orderedQuantity: 600,
//       producedQuantity: 600,
//       deliveredQuantity: 600,
//       remainingQuantity: 0,
//
//       ratePerBottle: 14.0,
//       totalAmount: 8400.0,
//       paidAmount: 8400.0,
//       dueAmount: 0.0,
//
//       orderStatus: 'completed',
//       productionStatus: 'completed',
//       deliveryStatus: 'delivered',
//
//       expectedProductionStartDate: DateTime(2026, 1, 10),
//       expectedDeliveryDate: DateTime(2026, 1, 18),
//       nextDeliveryDate: null,
//
//       isRecurring: false,
//       recurringIntervalDays: null,
//       lastRecurringGeneratedAt: null,
//       nextRecurringDate: null,
//       recurringParentOrderId: null,
//
//       notes: 'Delivered ahead of schedule',
//       isPriority: false,
//
//       createdBy: 'sales_1',
//       createdAt: DateTime(2026, 1, 8),
//       updatedAt: DateTime(2026, 1, 18),
//       isActive: true,
//     ),
//
//     // -------------------------
//     // 3) Ready but not delivered
//     // -------------------------
//     OrderModel(
//       id: 'ord_003',
//       orderNumber: '#ORD-1023',
//
//       clientId: 'res_olive',
//       clientNameSnapshot: 'Olive Bistro',
//
//       itemId: 'bottle_500_round',
//       itemNameSnapshot: 'Round Bottle 500ml',
//       bottleSize: '500ml',
//       packSize: 24,
//
//       labelItemId: 'label_olive',
//       labelNameSnapshot: 'Olive Bistro Label',
//       capItemId: 'cap_28_blue',
//       capNameSnapshot: 'Blue Cap 28mm',
//       packagingItemId: null,
//       packagingNameSnapshot: null,
//
//       orderedQuantity: 800,
//       producedQuantity: 800,
//       deliveredQuantity: 0,
//       remainingQuantity: 800,
//
//       ratePerBottle: 7.5,
//       totalAmount: 6000.0,
//       paidAmount: 2000.0,
//       dueAmount: 4000.0,
//
//       orderStatus: 'ready',
//       productionStatus: 'completed',
//       deliveryStatus: 'pending',
//
//       expectedProductionStartDate: DateTime(2026, 1, 20),
//       expectedDeliveryDate: DateTime(2026, 1, 26),
//       nextDeliveryDate: DateTime(2026, 1, 27),
//
//       isRecurring: false,
//       recurringIntervalDays: null,
//       lastRecurringGeneratedAt: null,
//       nextRecurringDate: null,
//       recurringParentOrderId: null,
//
//       notes: 'Client will pick up from warehouse',
//       isPriority: false,
//
//       createdBy: 'admin',
//       createdAt: DateTime(2026, 1, 19),
//       updatedAt: DateTime(2026, 1, 25),
//       isActive: true,
//     ),
//
//     // -------------------------
//     // 4) Overdue + partial delivery
//     // -------------------------
//     OrderModel(
//       id: 'ord_004',
//       orderNumber: '#ORD-1024',
//
//       clientId: 'gym_zenfit',
//       clientNameSnapshot: 'ZenFit Gym',
//
//       itemId: 'bottle_750_round',
//       itemNameSnapshot: 'Round Bottle 750ml',
//       bottleSize: '750ml',
//       packSize: 20,
//
//       labelItemId: 'label_zenfit',
//       labelNameSnapshot: 'ZenFit Label',
//       capItemId: 'cap_28_black',
//       capNameSnapshot: 'Black Cap 28mm',
//       packagingItemId: 'pack_carton_20',
//       packagingNameSnapshot: '20 Bottle Carton',
//
//       orderedQuantity: 1000,
//       producedQuantity: 1000,
//       deliveredQuantity: 600,
//       remainingQuantity: 400,
//
//       ratePerBottle: 9.5,
//       totalAmount: 9500.0,
//       paidAmount: 5000.0,
//       dueAmount: 4500.0,
//
//       orderStatus: 'partial',
//       productionStatus: 'completed',
//       deliveryStatus: 'partial',
//
//       expectedProductionStartDate: DateTime(2026, 1, 5),
//       expectedDeliveryDate: DateTime(2026, 1, 15),
//       nextDeliveryDate: DateTime(2026, 1, 28),
//
//       isRecurring: false,
//       recurringIntervalDays: null,
//       lastRecurringGeneratedAt: null,
//       nextRecurringDate: null,
//       recurringParentOrderId: null,
//
//       notes: 'Truck breakdown caused delay',
//       isPriority: true,
//
//       createdBy: 'ops_1',
//       createdAt: DateTime(2026, 1, 3),
//       updatedAt: DateTime(2026, 1, 25),
//       isActive: true,
//     ),
//
//     // -------------------------
//     // 5) Recurring parent order
//     // -------------------------
//     OrderModel(
//       id: 'ord_005',
//       orderNumber: '#ORD-1025',
//
//       clientId: 'hotel_sapphire',
//       clientNameSnapshot: 'Hotel Sapphire',
//
//       itemId: 'bottle_1000_round',
//       itemNameSnapshot: 'Round Bottle 1L',
//       bottleSize: '1L',
//       packSize: 12,
//
//       labelItemId: 'label_sapphire',
//       labelNameSnapshot: 'Sapphire Label',
//       capItemId: 'cap_30_white',
//       capNameSnapshot: 'White Cap 30mm',
//       packagingItemId: 'pack_shrink',
//       packagingNameSnapshot: 'Shrink Wrap',
//
//       orderedQuantity: 1500,
//       producedQuantity: 0,
//       deliveredQuantity: 0,
//       remainingQuantity: 1500,
//
//       ratePerBottle: 13.0,
//       totalAmount: 19500.0,
//       paidAmount: 0.0,
//       dueAmount: 19500.0,
//
//       orderStatus: 'pending',
//       productionStatus: 'not_started',
//       deliveryStatus: 'pending',
//
//       expectedProductionStartDate: DateTime(2026, 2, 1),
//       expectedDeliveryDate: DateTime(2026, 2, 8),
//       nextDeliveryDate: DateTime(2026, 2, 8),
//
//       isRecurring: true,
//       recurringIntervalDays: 30,
//       lastRecurringGeneratedAt: DateTime(2026, 1, 10),
//       nextRecurringDate: DateTime(2026, 2, 10),
//       recurringParentOrderId: null,
//
//       notes: 'Monthly hotel water supply',
//       isPriority: false,
//
//       createdBy: 'sales_2',
//       createdAt: DateTime(2026, 1, 10),
//       updatedAt: DateTime(2026, 1, 10),
//       isActive: true,
//     ),
//
//     // -------------------------
//     // 6) Recurring child order
//     // -------------------------
//     OrderModel(
//       id: 'ord_006',
//       orderNumber: '#ORD-1026',
//
//       clientId: 'hotel_sapphire',
//       clientNameSnapshot: 'Hotel Sapphire',
//
//       itemId: 'bottle_1000_round',
//       itemNameSnapshot: 'Round Bottle 1L',
//       bottleSize: '1L',
//       packSize: 12,
//
//       labelItemId: 'label_sapphire',
//       labelNameSnapshot: 'Sapphire Label',
//       capItemId: 'cap_30_white',
//       capNameSnapshot: 'White Cap 30mm',
//       packagingItemId: 'pack_shrink',
//       packagingNameSnapshot: 'Shrink Wrap',
//
//       orderedQuantity: 1500,
//       producedQuantity: 300,
//       deliveredQuantity: 0,
//       remainingQuantity: 1200,
//
//       ratePerBottle: 13.0,
//       totalAmount: 19500.0,
//       paidAmount: 5000.0,
//       dueAmount: 14500.0,
//
//       orderStatus: 'in_production',
//       productionStatus: 'bottling',
//       deliveryStatus: 'pending',
//
//       expectedProductionStartDate: DateTime(2026, 2, 5),
//       expectedDeliveryDate: DateTime(2026, 2, 12),
//       nextDeliveryDate: DateTime(2026, 2, 14),
//
//       isRecurring: true,
//       recurringIntervalDays: 30,
//       lastRecurringGeneratedAt: DateTime(2026, 2, 10),
//       nextRecurringDate: DateTime(2026, 3, 12),
//       recurringParentOrderId: 'ord_005',
//
//       notes: 'Auto-generated recurring order',
//       isPriority: false,
//
//       createdBy: 'system',
//       createdAt: DateTime(2026, 2, 10),
//       updatedAt: DateTime(2026, 2, 12),
//       isActive: true,
//     ),
//   ];
// }
//
//
// class OrdersSeedService {
//   static final _db = FirebaseFirestore.instance;
//
//   static Future<void> uploadDummyOrders() async {
//     final batch = _db.batch();
//     final col = _db.collection('orders');
//
//     for (final order in OrdersDummyData.list) {
//       final docRef = col.doc(order.id); // keep same ID for repeatable seeds
//       batch.set(docRef, order.toMap(), SetOptions(merge: true));
//     }
//
//     await batch.commit();
//   }
// }
