import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/screens/client/models/client_location.dart';
import 'package:clwb_crm/screens/client/models/client_media.dart';
import 'package:clwb_crm/screens/client/models/client_product_sku.dart';


class ClientModel {
  final String id;

  // Identity
  final String businessName;
  final String businessType;
  final String gstNumber;
  final String brandTier;

  // Contact
  final String contactName;
  final String contactRole;
  final String phone;
  final String email;

  // Status
  final bool isActive;
  final bool isPriority;

  // Financial
  final String paymentMode;
  final int creditDays;
  final double outstandingAmount;

  // Relations
  final List<ClientLocation> locations;
  final List<ClientProductSKU> products;
  final ClientMedia media;

  // Tracking
  final DateTime? lastOrderDate;
  final DateTime? nextDeliveryDate;
  final DateTime? contractEndDate;
  final DateTime createdAt;

  // Activity preview (IMPORTANT)
  final DateTime? lastActivityAt;
  final String? lastActivitySummary;

  // Optional stats
  final int? totalOrders;
  final int? dueOrdersCount;
  final int? deliveredOrdersCount;

  const ClientModel({
    required this.id,
    required this.businessName,
    required this.businessType,
    required this.gstNumber,
    required this.brandTier,
    required this.contactName,
    required this.contactRole,
    required this.phone,
    required this.email,
    required this.isActive,
    required this.isPriority,
    required this.paymentMode,
    required this.creditDays,
    required this.outstandingAmount,
    required this.locations,
    required this.products,
    required this.media,
    this.lastOrderDate,
    this.nextDeliveryDate,
    this.contractEndDate,
    required this.createdAt,
    this.lastActivityAt,
    this.lastActivitySummary,
    this.totalOrders,
    this.dueOrdersCount,
    this.deliveredOrdersCount,
  });

  factory ClientModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    DateTime? _ts(dynamic v) => v is Timestamp ? v.toDate() : null;

    return ClientModel(
      id: doc.id,
      businessName: data['businessName'] ?? '',
      businessType: data['businessType'] ?? '',
      gstNumber: data['gstNumber'] ?? '',
      brandTier: data['brandTier'] ?? '',

      contactName: data['contactName'] ?? '',
      contactRole: data['contactRole'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',

      isActive: data['isActive'] ?? true,
      isPriority: data['isPriority'] ?? false,

      paymentMode: data['paymentMode'] ?? '',
      creditDays: data['creditDays'] ?? 0,
      outstandingAmount: (data['outstandingAmount'] ?? 0).toDouble(),

      locations: ((data['locations'] ?? []) as List)
          .map((e) => ClientLocation.fromMap(Map<String, dynamic>.from(e)))
          .toList(),

      products: ((data['products'] ?? []) as List)
          .map((e) => ClientProductSKU.fromMap(Map<String, dynamic>.from(e)))
          .toList(),

      media: ClientMedia.fromMap(Map<String, dynamic>.from(data['media'] ?? {})),

      lastOrderDate: _ts(data['lastOrderDate']),
      nextDeliveryDate: _ts(data['nextDeliveryDate']),
      contractEndDate: _ts(data['contractEndDate']),
      createdAt: _ts(data['createdAt']) ?? DateTime.now(),

      lastActivityAt: _ts(data['lastActivityAt']),
      lastActivitySummary: data['lastActivitySummary'],

      totalOrders: data['totalOrders'],
      dueOrdersCount: data['dueOrdersCount'],
      deliveredOrdersCount: data['deliveredOrdersCount'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      // identity
      'businessName': businessName,
      'businessType': businessType,
      'gstNumber': gstNumber,
      'brandTier': brandTier,

      // contact
      'contactName': contactName,
      'contactRole': contactRole,
      'phone': phone,
      'email': email,

      // status
      'isActive': isActive,
      'isPriority': isPriority,

      // financial
      'paymentMode': paymentMode,
      'creditDays': creditDays,
      'outstandingAmount': outstandingAmount,

      // relations
      'locations': locations.map((e) => e.toMap()).toList(),
      'products': products.map((e) => e.toMap()).toList(),
      'media': media.toMap(),

      // tracking
      'lastOrderDate':
      lastOrderDate == null ? null : Timestamp.fromDate(lastOrderDate!),
      'nextDeliveryDate':
      nextDeliveryDate == null ? null : Timestamp.fromDate(nextDeliveryDate!),
      'contractEndDate':
      contractEndDate == null ? null : Timestamp.fromDate(contractEndDate!),
      'createdAt': Timestamp.fromDate(createdAt),

      // activity preview (denormalized)
      'lastActivityAt':
      lastActivityAt == null ? null : Timestamp.fromDate(lastActivityAt!),
      'lastActivitySummary': lastActivitySummary,

      // optional stats
      'totalOrders': totalOrders,
      'dueOrdersCount': dueOrdersCount,
      'deliveredOrdersCount': deliveredOrdersCount,
    };
  }
  factory ClientModel.fromJson(
      Map<String, dynamic> json, {
        String? id,
      }) {
    DateTime? _dt(dynamic v) {
      if (v is Timestamp) return v.toDate();
      if (v is String) return DateTime.tryParse(v);
      return null;
    }

    return ClientModel(
      id: id ?? (json['id'] ?? '') as String,

      businessName: json['businessName'] ?? '',
      businessType: json['businessType'] ?? '',
      gstNumber: json['gstNumber'] ?? '',
      brandTier: json['brandTier'] ?? '',

      contactName: json['contactName'] ?? '',
      contactRole: json['contactRole'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',

      isActive: json['isActive'] ?? true,
      isPriority: json['isPriority'] ?? false,

      paymentMode: json['paymentMode'] ?? '',
      creditDays: json['creditDays'] ?? 0,
      outstandingAmount: (json['outstandingAmount'] ?? 0).toDouble(),

      locations: ((json['locations'] ?? []) as List)
          .map((e) => ClientLocation.fromMap(Map<String, dynamic>.from(e)))
          .toList(),

      products: ((json['products'] ?? []) as List)
          .map((e) => ClientProductSKU.fromMap(Map<String, dynamic>.from(e)))
          .toList(),

      media: ClientMedia.fromMap(
        Map<String, dynamic>.from(json['media'] ?? {}),
      ),

      lastOrderDate: _dt(json['lastOrderDate']),
      nextDeliveryDate: _dt(json['nextDeliveryDate']),
      contractEndDate: _dt(json['contractEndDate']),
      createdAt: _dt(json['createdAt']) ?? DateTime.now(),

      lastActivityAt: _dt(json['lastActivityAt']),
      lastActivitySummary: json['lastActivitySummary'],

      totalOrders: json['totalOrders'],
      dueOrdersCount: json['dueOrdersCount'],
      deliveredOrdersCount: json['deliveredOrdersCount'],
    );
  }

}


enum ClientActivityType {
  created,
  order,
  note,
  call,
  email,
  other,

}

class ClientActivity {
  final String id;
  final ClientActivityType type;
  final String title;
  final String note;
  final String userName;
  final DateTime at;

  ClientActivity({
    required this.id,
    required this.type,
    required this.title,
    required this.note,
    required this.userName,
    required this.at,
  });

  factory ClientActivity.fromDoc(Map<String, dynamic> data, String id) {
    return ClientActivity(
      id: id,
      type: ClientActivityType.values.firstWhere(
            (e) => e.name == data['type'],
        orElse: () => ClientActivityType.note,
      ),
      title: data['title'] ?? '',
      note: data['note'] ?? '',
      userName: data['userName'] ?? '',
      at: (data['at'] as Timestamp).toDate(),
    );
  }

  factory ClientActivity.fromMap(Map<String, dynamic> d) {
    return ClientActivity(
      id: d['id'] ?? '',
      type: ClientActivityType.values.firstWhere(
            (e) => e.name == d['type'],
        orElse: () => ClientActivityType.other,
      ),
      title: d['title'] ?? '',
      note: d['note'] ?? '',
      userName: d['userName'] ?? '',
      at: (d['at'] is Timestamp)
          ? (d['at'] as Timestamp).toDate()
          : DateTime.tryParse(d['at']?.toString() ?? '') ?? DateTime.now(),

    );
  }
}

