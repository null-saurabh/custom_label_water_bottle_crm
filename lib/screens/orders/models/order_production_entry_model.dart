import 'package:cloud_firestore/cloud_firestore.dart';

class OrderProductionEntryModel {
  final String id;
  final String orderId;
  final int quantityProduced;
  final DateTime productionDate;
  final String? batchNumber;
  final String? machineId;
  final String? supervisorName;
  final String? qualityCheckedBy;
  final String? remarks;
  final DateTime createdAt;

  const OrderProductionEntryModel({
    required this.id,
    required this.orderId,
    required this.quantityProduced,
    required this.productionDate,
    required this.batchNumber,
    required this.machineId,
    required this.supervisorName,
    required this.qualityCheckedBy,
    required this.remarks,
    required this.createdAt,
  });

  factory OrderProductionEntryModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderProductionEntryModel(
      id: doc.id,
      orderId: data['orderId'],
      quantityProduced: data['quantityProduced'],
      productionDate: data['productionDate'].toDate(),
      batchNumber: data['batchNumber'],
      machineId: data['machineId'],
      supervisorName: data['supervisorName'],
      qualityCheckedBy: data['qualityCheckedBy'],
      remarks: data['remarks'],
      createdAt: data['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'quantityProduced': quantityProduced,
      'productionDate': productionDate,
      'batchNumber': batchNumber,
      'machineId': machineId,
      'supervisorName': supervisorName,
      'qualityCheckedBy': qualityCheckedBy,
      'remarks': remarks,
      'createdAt': createdAt,
    };
  }
}
