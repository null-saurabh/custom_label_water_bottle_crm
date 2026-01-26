import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDeliveryEntryModel {
  final String id;
  final String orderId;
  final int quantityDelivered;
  final DateTime deliveryDate;
  final String? vehicleNumber;
  final String? driverName;
  final String? deliveryChallanNumber;
  final String? receivedByClient;
  final String? remarks;
  final DateTime createdAt;

  const OrderDeliveryEntryModel({
    required this.id,
    required this.orderId,
    required this.quantityDelivered,
    required this.deliveryDate,
    required this.vehicleNumber,
    required this.driverName,
    required this.deliveryChallanNumber,
    required this.receivedByClient,
    required this.remarks,
    required this.createdAt,
  });

  factory OrderDeliveryEntryModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderDeliveryEntryModel(
      id: doc.id,
      orderId: data['orderId'],
      quantityDelivered: data['quantityDelivered'],
      deliveryDate: data['deliveryDate'].toDate(),
      vehicleNumber: data['vehicleNumber'],
      driverName: data['driverName'],
      deliveryChallanNumber: data['deliveryChallanNumber'],
      receivedByClient: data['receivedByClient'],
      remarks: data['remarks'],
      createdAt: data['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'quantityDelivered': quantityDelivered,
      'deliveryDate': deliveryDate,
      'vehicleNumber': vehicleNumber,
      'driverName': driverName,
      'deliveryChallanNumber': deliveryChallanNumber,
      'receivedByClient': receivedByClient,
      'remarks': remarks,
      'createdAt': createdAt,
    };
  }
}
