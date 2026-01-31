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
  final String notes;

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


  final String? labelSmallItemId;   // 🔥
  final String? labelLargeItemId;   // 🔥


  const ClientModel( {
    required this.id,
    required this.businessName,
    required this.businessType,
    required this.gstNumber,
    required this.brandTier,
    required this.contactName,
    required this.contactRole,
    required this.phone,
    required this.email,
    required this.notes,
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
    this.labelLargeItemId,
    this.labelSmallItemId,
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
      notes: data['notes'] ?? '',

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
      labelLargeItemId: data['labelLargeItemId'], // 🔥
      labelSmallItemId: data['labelSmallItemId'], // 🔥

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
      'notes': notes,

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
      'labelLargeItemId': labelLargeItemId, // 🔥
      'labelSmallItemId': labelSmallItemId, // 🔥
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
      labelLargeItemId: json['labelLargeItemId'] ?? '',
      labelSmallItemId: json['labelSmallItemId'] ?? '',
      businessType: json['businessType'] ?? '',
      gstNumber: json['gstNumber'] ?? '',
      brandTier: json['brandTier'] ?? '',

      contactName: json['contactName'] ?? '',
      contactRole: json['contactRole'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      notes: json['notes'] ?? '',

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

  Map<String, dynamic> toMap() {
    return {
      'businessName': businessName,
      'businessType': businessType,
      'gstNumber': gstNumber,
      'brandTier': brandTier,

      'contactName': contactName,
      'contactRole': contactRole,
      'phone': phone,
      'email': email,
      'notes': notes,

      'isActive': isActive,
      'isPriority': isPriority,

      'paymentMode': paymentMode,
      'creditDays': creditDays,
      'outstandingAmount': outstandingAmount,

      'locations': locations.map((l) {
        return {
          'locationId': l.locationId,
          'address': l.address,
          'googleMapsLink': l.googleMapsLink,
          'city': l.city,
          'area': l.area,
          'isPrimary': l.isPrimary,
        };
      }).toList(),

      'products': [],

      'media': {
        'logoUrl': media.businessPhotos,
        'brandImages': media.finalizedLabelImage,
        'visitingCardUrl': media.draftLabelImages,
      },

      'lastOrderDate': lastOrderDate,
      'nextDeliveryDate': nextDeliveryDate,
      'contractEndDate': contractEndDate,
      'createdAt': createdAt,

      'lastActivityAt': lastActivityAt,
      'lastActivitySummary': lastActivitySummary,

      'totalOrders': totalOrders,
      'dueOrdersCount': dueOrdersCount,
      'deliveredOrdersCount': deliveredOrdersCount,

      'labelSmallItemId': labelSmallItemId,
      'labelLargeItemId': labelLargeItemId,
    };
  }


  ClientModel copyWith({
    String? id,

    String? businessName,
    String? businessType,
    String? gstNumber,
    String? brandTier,

    String? contactName,
    String? contactRole,
    String? phone,
    String? email,
    String? notes,

    bool? isActive,
    bool? isPriority,

    String? paymentMode,
    int? creditDays,
    double? outstandingAmount,

    List<ClientLocation>? locations,
    List<ClientProductSKU>? products,
    ClientMedia? media,

    DateTime? lastOrderDate,
    DateTime? nextDeliveryDate,
    DateTime? contractEndDate,
    DateTime? createdAt,

    DateTime? lastActivityAt,
    String? lastActivitySummary,

    int? totalOrders,
    int? dueOrdersCount,
    int? deliveredOrdersCount,

    String? labelSmallItemId,
    String? labelLargeItemId,
  }) {
    return ClientModel(
      id: id ?? this.id,

      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
      gstNumber: gstNumber ?? this.gstNumber,
      brandTier: brandTier ?? this.brandTier,

      contactName: contactName ?? this.contactName,
      contactRole: contactRole ?? this.contactRole,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      notes: notes ?? this.notes,

      isActive: isActive ?? this.isActive,
      isPriority: isPriority ?? this.isPriority,

      paymentMode: paymentMode ?? this.paymentMode,
      creditDays: creditDays ?? this.creditDays,
      outstandingAmount:
      outstandingAmount ?? this.outstandingAmount,

      locations: locations ?? this.locations,
      products: products ?? this.products,
      media: media ?? this.media,

      lastOrderDate: lastOrderDate ?? this.lastOrderDate,
      nextDeliveryDate:
      nextDeliveryDate ?? this.nextDeliveryDate,
      contractEndDate:
      contractEndDate ?? this.contractEndDate,
      createdAt: createdAt ?? this.createdAt,

      lastActivityAt:
      lastActivityAt ?? this.lastActivityAt,
      lastActivitySummary:
      lastActivitySummary ?? this.lastActivitySummary,

      totalOrders: totalOrders ?? this.totalOrders,
      dueOrdersCount:
      dueOrdersCount ?? this.dueOrdersCount,
      deliveredOrdersCount:
      deliveredOrdersCount ??
          this.deliveredOrdersCount,

      labelSmallItemId:
      labelSmallItemId ?? this.labelSmallItemId,
      labelLargeItemId:
      labelLargeItemId ?? this.labelLargeItemId,
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
    DateTime _dt(dynamic v) {
      if (v is Timestamp) return v.toDate();
      if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
      return DateTime.now();
    }

    // If you later add audit to client activities,
    // createdByName/email/uid will exist. This keeps it backward-compatible.
    final createdBy = (data['createdByName'] ??
        data['createdByEmail'] ??
        data['createdByUid'] ??
        data['userName'] ??
        'system')
        .toString();

    return ClientActivity(
      id: id,
      type: ClientActivityType.values.firstWhere(
            (e) => e.name == data['type'],
        orElse: () => ClientActivityType.note,
      ),
      title: (data['title'] ?? '').toString(),
      note: (data['note'] ?? '').toString(),
      userName: createdBy,
      at: _dt(data['at']),
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

  factory ClientActivity.fromOrderActivityDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final typeStr = (data['type'] ?? '').toString();

    ClientActivityType mapped;
    if (typeStr == 'order_created' || typeStr == 'created') mapped = ClientActivityType.created;
    else if (typeStr.contains('delivery')) mapped = ClientActivityType.order;
    else if (typeStr.contains('payment')) mapped = ClientActivityType.other;
    else if (typeStr.contains('production')) mapped = ClientActivityType.order;
    else mapped = ClientActivityType.other;

    return ClientActivity(
      id: doc.id,
      type: mapped,
      title: (data['title'] ?? '').toString(),
      note: (data['description'] ?? '').toString(),
      userName: (data['createdByName'] ??
          data['createdByEmail'] ??
          data['createdByUid'] ??
          data['createdBy'] ??
          'system')
          .toString(),
      at: (data['activityDate'] is Timestamp)
          ? (data['activityDate'] as Timestamp).toDate()
          : DateTime.tryParse(data['activityDate']?.toString() ?? '') ?? DateTime.now(),

    );
  }


}

