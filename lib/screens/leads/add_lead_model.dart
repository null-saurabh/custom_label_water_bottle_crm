import 'package:cloud_firestore/cloud_firestore.dart';

enum LeadStatus {
  newLead,
  contacted,
  followUp,
  qualified,
  converted,
  lost,
}

enum LeadActivityType {
  created,
  call,
  whatsapp,
  visit,
  note,
  statusChanged,
  followUp,
  other,
}

class LeadActivity {
  final String id; // can be a uuid or timestamp-based id
  final LeadActivityType type;
  final String title; // short label e.g. "Called customer"
  final String note;  // detailed note
  final DateTime at;
  final String? createdBy; // optional: user id/name later

  LeadActivity({
    required this.id,
    required this.type,
    required this.title,
    required this.note,
    required this.at,
    this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'note': note,
      'at': Timestamp.fromDate(at),
      'createdBy': createdBy,
    };
  }

  factory LeadActivity.fromMap(Map<String, dynamic> d) {
    return LeadActivity(
      id: d['id'] ?? '',
      type: LeadActivityType.values.firstWhere(
            (e) => e.name == d['type'],
        orElse: () => LeadActivityType.other,
      ),
      title: d['title'] ?? '',
      note: d['note'] ?? '',
      at: (d['at'] is Timestamp)
          ? (d['at'] as Timestamp).toDate()
          : DateTime.tryParse(d['at']?.toString() ?? '') ?? DateTime.now(),
      createdBy: d['createdBy'],
    );
  }
}

class LeadModel {
  final String id;

  // Core details
  final String businessName;
  final String contactName;
  final String phone;
  final String email;

  // Lead fields
  final String businessType;     // Restaurant/Cafe/Hotel/Resort/Banquet/Other
  final String monthlyQuantity;

  // Product interest (bottle only, but you can store details)
  final List<String> bottleSizes; // e.g. ["500ml","1L"]
  final String bottleDesign;      // "round" or "square" or "" (optional)

  // Location
  final String city;
  final String state;
  final String area;             // ✅ NEW
  final String deliveryLocation; // optional (can be address / landmark)

  // Notes
  final String notes;            // long notes
  final String followUpNotes;    // ✅ NEW (quick follow-up note)

  // Status + activity
  final LeadStatus status;
  final DateTime createdAt;
  final DateTime? lastActivityAt;

  // ✅ NEW: timeline of all activities for this lead
  final List<LeadActivity> activities;

  LeadModel({
    required this.id,
    required this.businessName,
    required this.contactName,
    required this.phone,
    required this.email,
    required this.businessType,
    required this.monthlyQuantity,
    required this.bottleSizes,
    required this.bottleDesign,
    required this.city,
    required this.state,
    required this.area,
    required this.deliveryLocation,
    required this.notes,
    required this.followUpNotes,
    required this.status,
    required this.createdAt,
    this.lastActivityAt,
    required this.activities,
  });

  /// Firestore write
  Map<String, dynamic> toMap() {
    return {
      'businessName': businessName,
      'contactName': contactName,
      'phone': phone,
      'email': email,

      'businessType': businessType,
      'monthlyQuantity': monthlyQuantity,

      'bottleSizes': bottleSizes,
      'bottleDesign': bottleDesign,

      'city': city,
      'state': state,
      'area': area, // ✅
      'deliveryLocation': deliveryLocation,

      'notes': notes,
      'followUpNotes': followUpNotes, // ✅

      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActivityAt':
      lastActivityAt != null ? Timestamp.fromDate(lastActivityAt!) : null,

      // 'activities': activities.map((a) => a.toMap()).toList(), // ✅
    };
  }

  /// Firestore read
  factory LeadModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>? ?? {};

    // Activities safe read
    final rawActivities = (d['activities'] as List?) ?? [];
    final activities = rawActivities
        .whereType<Map>()
        .map((e) => LeadActivity.fromMap(Map<String, dynamic>.from(e)))
        .toList();

    Timestamp? createdTs = d['createdAt'] as Timestamp?;
    Timestamp? lastActTs = d['lastActivityAt'] as Timestamp?;

    return LeadModel(
      id: doc.id,
      businessName: d['businessName'] ?? '',
      contactName: d['contactName'] ?? '',
      phone: d['phone'] ?? '',
      email: d['email'] ?? '',

      businessType: d['businessType'] ?? '',
      monthlyQuantity: d['monthlyQuantity'] ?? '',

      bottleSizes: List<String>.from(d['bottleSizes'] ?? const []),
      bottleDesign: d['bottleDesign'] ?? '',

      city: d['city'] ?? '',
      state: d['state'] ?? '',
      area: d['area'] ?? '', // ✅
      deliveryLocation: d['deliveryLocation'] ?? '',

      notes: d['notes'] ?? '',
      followUpNotes: d['followUpNotes'] ?? '', // ✅

      status: LeadStatus.values.firstWhere(
            (e) => e.name == d['status'],
        orElse: () => LeadStatus.newLead,
      ),

      createdAt: createdTs?.toDate() ?? DateTime.now(),
      lastActivityAt: lastActTs?.toDate(),

      activities: activities,
    );
  }

  /// Handy helper for updates (optional)
  LeadModel copyWith({
    String? businessName,
    String? contactName,
    String? phone,
    String? email,
    String? businessType,
    String? monthlyQuantity,
    List<String>? bottleSizes,
    String? bottleDesign,
    String? city,
    String? state,
    String? area,
    String? deliveryLocation,
    String? notes,
    String? followUpNotes,
    LeadStatus? status,
    DateTime? createdAt,
    DateTime? lastActivityAt,
    List<LeadActivity>? activities,
  }) {
    return LeadModel(
      id: id,
      businessName: businessName ?? this.businessName,
      contactName: contactName ?? this.contactName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      businessType: businessType ?? this.businessType,
      monthlyQuantity: monthlyQuantity ?? this.monthlyQuantity,
      bottleSizes: bottleSizes ?? this.bottleSizes,
      bottleDesign: bottleDesign ?? this.bottleDesign,
      city: city ?? this.city,
      state: state ?? this.state,
      area: area ?? this.area,
      deliveryLocation: deliveryLocation ?? this.deliveryLocation,
      notes: notes ?? this.notes,
      followUpNotes: followUpNotes ?? this.followUpNotes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      activities: activities ?? this.activities,
    );
  }
}
