import 'package:cloud_firestore/cloud_firestore.dart';

/// =======================
/// Lead Pipeline (Primary)
/// =======================
enum LeadStage {
  newInquiry,
  attemptingContact,
  contacted,
  qualified,

  sampleRequested,
  sampleSent,
  sampleFeedbackAwaited,
  requirementsClarifying,

  priceShared,
  negotiation,
  decisionPending,

  meetingScheduled,
  visitScheduled,
  followUpRequired,

  callMeLater,
  interestedNotReady,

  lostPrice,
  lostNoRequirement,
  lostNoResponse,
  lostCompetitor,

  convertedToClient,
}

enum LeadTemperature { hot, warm, cold }

enum LeadSource {
  walkIn,
  referral,
  instagram,
  website,
  coldCall,
  whatsappInbound,
  existingClientRef,
  distributor,
  other,
}

/// =======================
/// Product Interest (Sales-language, NO SKU/stock links)
/// =======================
class ProductInterest {
  final String bottleSize; // "250 ml" / "500 ml" / "1 L" / "Not sure"
  final String material; // "PET" / "Glass" / "Steel" / "Not sure"
  final String capType; // "Flip" / "Sipper" / "Normal" / "Not sure"
  final String labelType; // "Sticker" / "Screen Print" / "Sleeve" / "Not sure"
  final String packaging; // "Carton" / "Shrink" / "Loose" / "Not sure"
  final String notes;

  const ProductInterest({
    required this.bottleSize,
    required this.material,
    required this.capType,
    required this.labelType,
    required this.packaging,
    required this.notes,
  });

  factory ProductInterest.empty({String bottleSize = 'Not sure'}) {
    return ProductInterest(
      bottleSize: bottleSize,
      material: 'Not sure',
      capType: 'Not sure',
      labelType: 'Not sure',
      packaging: 'Not sure',
      notes: '',
    );
  }

  Map<String, dynamic> toMap() => {
    'bottleSize': bottleSize,
    'material': material,
    'capType': capType,
    'labelType': labelType,
    'packaging': packaging,
    'notes': notes,
  };

  factory ProductInterest.fromMap(Map<String, dynamic> m) => ProductInterest(
    bottleSize: (m['bottleSize'] ?? 'Not sure').toString(),
    material: (m['material'] ?? 'Not sure').toString(),
    capType: (m['capType'] ?? 'Not sure').toString(),
    labelType: (m['labelType'] ?? 'Not sure').toString(),
    packaging: (m['packaging'] ?? 'Not sure').toString(),
    notes: (m['notes'] ?? '').toString(),
  );
}

/// =======================
/// Lead Contact (Messy reality)
/// =======================
class LeadContact {
  final String name;
  final String role; // owner/manager/procurement/other
  final String phone;
  final String whatsapp;
  final String email;
  final bool isPrimary;

  const LeadContact({
    required this.name,
    required this.role,
    required this.phone,
    required this.whatsapp,
    required this.email,
    required this.isPrimary,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'role': role,
    'phone': phone,
    'whatsapp': whatsapp,
    'email': email,
    'isPrimary': isPrimary,
  };

  factory LeadContact.fromMap(Map<String, dynamic> m) => LeadContact(
    name: (m['name'] ?? '').toString(),
    role: (m['role'] ?? 'other').toString(),
    phone: (m['phone'] ?? '').toString(),
    whatsapp: (m['whatsapp'] ?? '').toString(),
    email: (m['email'] ?? '').toString(),
    isPrimary: (m['isPrimary'] ?? false) == true,
  );
}

/// =======================
/// Lead Model (Pipeline + Next Action)
/// =======================
class LeadModel {
  final String id;

  // identity
  final String businessName;
  final String businessType; // "Restaurant/Café/Office/Brand/Other"

  // primary contact (quick access)
  final String primaryContactName;
  final String primaryPhone;
  final String primaryWhatsApp;
  final String primaryEmail;

  // optional multiple contacts
  final List<LeadContact> contacts;

  // pipeline
  final LeadStage stage;
  final LeadTemperature temperature;

  // next action
  final DateTime? nextFollowUpAt;
  final String nextFollowUpNote;

  // timestamps
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? lastActivityAt;
  final DateTime? lastContactedAt;

  // sales ownership
  final String assignedToUserId;
  final String assignedToUserName;

  // context
  final LeadSource source;
  final String sourceDetail;

  // sales interest
  final List<ProductInterest> interests; // reference-only
  final String expectedMonthlyVolume; // "0-500" / "500-2000" / "Not sure"
  final String priceSensitivity; // "High/Medium/Low/Not sure"

  // location
  final String city;
  final String state;
  final String area;

  // notes/tags
  final String notes;
  final List<String> tags;

  // terminal fields
  final String? convertedClientId;
  final DateTime? convertedAt;

  const LeadModel({
    required this.id,
    required this.businessName,
    required this.businessType,
    required this.primaryContactName,
    required this.primaryPhone,
    required this.primaryWhatsApp,
    required this.primaryEmail,
    required this.contacts,
    required this.stage,
    required this.temperature,
    required this.nextFollowUpAt,
    required this.nextFollowUpNote,
    required this.createdAt,
    required this.updatedAt,
    required this.lastActivityAt,
    required this.lastContactedAt,
    required this.assignedToUserId,
    required this.assignedToUserName,
    required this.source,
    required this.sourceDetail,
    required this.interests,
    required this.expectedMonthlyVolume,
    required this.priceSensitivity,
    required this.city,
    required this.state,
    required this.area,
    required this.notes,
    required this.tags,
    required this.convertedClientId,
    required this.convertedAt,
  });

  bool get isConverted => convertedClientId != null || stage == LeadStage.convertedToClient;
  bool get isLost =>
      stage == LeadStage.lostPrice ||
          stage == LeadStage.lostNoRequirement ||
          stage == LeadStage.lostNoResponse ||
          stage == LeadStage.lostCompetitor;

  Map<String, dynamic> toMap() => {
    'businessName': businessName,
    'businessType': businessType,
    'primaryContactName': primaryContactName,
    'primaryPhone': primaryPhone,
    'primaryWhatsApp': primaryWhatsApp,
    'primaryEmail': primaryEmail,
    'contacts': contacts.map((c) => c.toMap()).toList(),

    'stage': stage.name,
    'temperature': temperature.name,

    'nextFollowUpAt': nextFollowUpAt == null ? null : Timestamp.fromDate(nextFollowUpAt!),
    'nextFollowUpNote': nextFollowUpNote,

    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
    'lastActivityAt': lastActivityAt == null ? null : Timestamp.fromDate(lastActivityAt!),
    'lastContactedAt': lastContactedAt == null ? null : Timestamp.fromDate(lastContactedAt!),

    'assignedToUserId': assignedToUserId,
    'assignedToUserName': assignedToUserName,

    'source': source.name,
    'sourceDetail': sourceDetail,

    'interests': interests.map((i) => i.toMap()).toList(),
    'expectedMonthlyVolume': expectedMonthlyVolume,
    'priceSensitivity': priceSensitivity,

    'city': city,
    'state': state,
    'area': area,

    'notes': notes,
    'tags': tags,

    'convertedClientId': convertedClientId,
    'convertedAt': convertedAt == null ? null : Timestamp.fromDate(convertedAt!),
  };

  factory LeadModel.fromDoc(DocumentSnapshot doc) {
    final m = (doc.data() as Map<String, dynamic>? ?? {});
    DateTime? ts(dynamic v) => v is Timestamp ? v.toDate() : null;

    final interestsRaw = (m['interests'] as List? ?? [])
        .whereType<Map>()
        .map((x) => ProductInterest.fromMap(Map<String, dynamic>.from(x)))
        .toList();

    final contactsRaw = (m['contacts'] as List? ?? [])
        .whereType<Map>()
        .map((x) => LeadContact.fromMap(Map<String, dynamic>.from(x)))
        .toList();

    return LeadModel(
      id: doc.id,
      businessName: (m['businessName'] ?? '').toString(),
      businessType: (m['businessType'] ?? '').toString(),

      primaryContactName: (m['primaryContactName'] ?? '').toString(),
      primaryPhone: (m['primaryPhone'] ?? '').toString(),
      primaryWhatsApp: (m['primaryWhatsApp'] ?? '').toString(),
      primaryEmail: (m['primaryEmail'] ?? '').toString(),

      contacts: contactsRaw,

      stage: LeadStage.values.firstWhere(
            (e) => e.name == (m['stage'] ?? 'newInquiry'),
        orElse: () => LeadStage.newInquiry,
      ),
      temperature: LeadTemperature.values.firstWhere(
            (e) => e.name == (m['temperature'] ?? 'warm'),
        orElse: () => LeadTemperature.warm,
      ),

      nextFollowUpAt: ts(m['nextFollowUpAt']),
      nextFollowUpNote: (m['nextFollowUpNote'] ?? '').toString(),

      createdAt: ts(m['createdAt']) ?? DateTime.now(),
      updatedAt: ts(m['updatedAt']),
      lastActivityAt: ts(m['lastActivityAt']),
      lastContactedAt: ts(m['lastContactedAt']),

      assignedToUserId: (m['assignedToUserId'] ?? '').toString(),
      assignedToUserName: (m['assignedToUserName'] ?? '').toString(),

      source: LeadSource.values.firstWhere(
            (e) => e.name == (m['source'] ?? 'other'),
        orElse: () => LeadSource.other,
      ),
      sourceDetail: (m['sourceDetail'] ?? '').toString(),

      interests: interestsRaw,
      expectedMonthlyVolume: (m['expectedMonthlyVolume'] ?? 'Not sure').toString(),
      priceSensitivity: (m['priceSensitivity'] ?? 'Not sure').toString(),

      city: (m['city'] ?? '').toString(),
      state: (m['state'] ?? '').toString(),
      area: (m['area'] ?? '').toString(),

      notes: (m['notes'] ?? '').toString(),
      tags: (m['tags'] as List? ?? []).map((e) => e.toString()).toList(),

      convertedClientId: (m['convertedClientId'] as String?),
      convertedAt: ts(m['convertedAt']),
    );
  }

  LeadModel copyWith({
    String? businessName,
    String? businessType,
    String? primaryContactName,
    String? primaryPhone,
    String? primaryWhatsApp,
    String? primaryEmail,
    List<LeadContact>? contacts,
    LeadStage? stage,
    LeadTemperature? temperature,
    DateTime? nextFollowUpAt,
    String? nextFollowUpNote,
    DateTime? updatedAt,
    DateTime? lastActivityAt,
    DateTime? lastContactedAt,
    String? assignedToUserId,
    String? assignedToUserName,
    LeadSource? source,
    String? sourceDetail,
    List<ProductInterest>? interests,
    String? expectedMonthlyVolume,
    String? priceSensitivity,
    String? city,
    String? state,
    String? area,
    String? notes,
    List<String>? tags,
    String? convertedClientId,
    DateTime? convertedAt,
  }) {
    return LeadModel(
      id: id,
      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
      primaryContactName: primaryContactName ?? this.primaryContactName,
      primaryPhone: primaryPhone ?? this.primaryPhone,
      primaryWhatsApp: primaryWhatsApp ?? this.primaryWhatsApp,
      primaryEmail: primaryEmail ?? this.primaryEmail,
      contacts: contacts ?? this.contacts,
      stage: stage ?? this.stage,
      temperature: temperature ?? this.temperature,
      nextFollowUpAt: nextFollowUpAt ?? this.nextFollowUpAt,
      nextFollowUpNote: nextFollowUpNote ?? this.nextFollowUpNote,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      lastContactedAt: lastContactedAt ?? this.lastContactedAt,
      assignedToUserId: assignedToUserId ?? this.assignedToUserId,
      assignedToUserName: assignedToUserName ?? this.assignedToUserName,
      source: source ?? this.source,
      sourceDetail: sourceDetail ?? this.sourceDetail,
      interests: interests ?? this.interests,
      expectedMonthlyVolume: expectedMonthlyVolume ?? this.expectedMonthlyVolume,
      priceSensitivity: priceSensitivity ?? this.priceSensitivity,
      city: city ?? this.city,
      state: state ?? this.state,
      area: area ?? this.area,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      convertedClientId: convertedClientId ?? this.convertedClientId,
      convertedAt: convertedAt ?? this.convertedAt,
    );
  }
}

/// =======================
/// Activity Timeline
/// =======================
enum LeadActivityType {
  created,

  callMade,
  callReceived,
  whatsappSent,
  whatsappReceived,
  emailSent,
  emailReceived,

  meetingScheduled,
  meetingCompleted,
  visitScheduled,
  visitCompleted,

  sampleRequested,
  sampleDispatched,
  sampleDelivered,
  sampleFeedbackReceived,

  priceShared,
  quotationSent,
  negotiationUpdate,

  followUpScheduled,
  followUpCompleted,

  internalNote,

  statusChanged,
  assignedChanged,
}

class LeadActivity {
  final String id;
  final LeadActivityType type;
  final String title;
  final String note;
  final String userId;
  final String userName;
  final DateTime at;

  /// Optional structured info: { "phone": "...", "courier": "...", "meetingAt": Timestamp ... }
  final Map<String, dynamic> meta;

  const LeadActivity({
    required this.id,
    required this.type,
    required this.title,
    required this.note,
    required this.userId,
    required this.userName,
    required this.at,
    required this.meta,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type.name,
    'title': title,
    'note': note,
    'userId': userId,
    'userName': userName,
    'at': Timestamp.fromDate(at),
    'meta': meta,
  };

  factory LeadActivity.fromMap(Map<String, dynamic> m) {
    DateTime ts(dynamic v) => v is Timestamp ? v.toDate() : DateTime.now();
    return LeadActivity(
      id: (m['id'] ?? '').toString(),
      type: LeadActivityType.values.firstWhere(
            (e) => e.name == (m['type'] ?? 'internalNote'),
        orElse: () => LeadActivityType.internalNote,
      ),
      title: (m['title'] ?? '').toString(),
      note: (m['note'] ?? '').toString(),
      userId: (m['userId'] ?? '').toString(),
      userName: (m['userName'] ?? '').toString(),
      at: ts(m['at']),
      meta: Map<String, dynamic>.from(m['meta'] ?? {}),
    );
  }
}
