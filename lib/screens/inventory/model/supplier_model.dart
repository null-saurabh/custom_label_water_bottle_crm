import 'package:cloud_firestore/cloud_firestore.dart';

class SupplierModel {
  final String id;

  final String name;
  final String? contactPerson;
  final String? phone;
  final String? email;
  final String? address;

  final bool isActive;

  final DateTime createdAt;
  final DateTime updatedAt;

  SupplierModel({
    required this.id,
    required this.name,
    this.contactPerson,
    this.phone,
    this.email,
    this.address,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SupplierModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return SupplierModel(
      id: doc.id,
      name: data['name'],
      contactPerson: data['contactPerson'],
      phone: data['phone'],
      email: data['email'],
      address: data['address'],
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'contactPerson': contactPerson,
      'phone': phone,
      'email': email,
      'address': address,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }


  SupplierModel copyWith({
    String? id,
    String? name,
    String? contactPerson,
    String? phone,
    String? email,
    String? address,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SupplierModel(
      id: id ?? this.id,
      name: name ?? this.name,
      contactPerson: contactPerson ?? this.contactPerson,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }


}
