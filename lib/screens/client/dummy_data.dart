import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/screens/client/models/client_location.dart';
import 'package:clwb_crm/screens/client/models/client_media.dart';
import 'package:clwb_crm/screens/client/models/client_model.dart';

class ClientsDummyData {
  static final List<ClientModel> list = [
    ClientModel(
      id: 'client_001',

      businessName: 'Cafe Snowtrail',
      businessType: 'Cafe',
      gstNumber: '07AABCS1234F1ZP',
      brandTier: 'Gold',

      contactName: 'Rohit Mehra',
      contactRole: 'Owner',
      phone: '+91 98765 43210',
      email: 'snowtrail.cafe@gmail.com',
      notes: 'High footfall cafe, prefers premium packaging',

      isActive: true,
      isPriority: true,

      paymentMode: 'Credit',
      creditDays: 15,
      outstandingAmount: 6600.0,

      locations: [
        ClientLocation(
          locationId: 'loc_001',
          address: '12, Mall Road, Near Bus Stand',
          googleMapsLink: 'https://maps.google.com/?q=mall+road+manali',
          city: 'Manali',
          area: 'Mall Road',
          isPrimary: true,
        ),
        ClientLocation(
          locationId: 'loc_002',
          address: 'Snowtrail Cafe, Solang Valley',
          googleMapsLink: 'https://maps.google.com/?q=solang+valley',
          city: 'Manali',
          area: 'Solang Valley',
          isPrimary: false,
        ),
      ],

      products: [],

      media: ClientMedia(
        businessPhotos: ['https://placehold.co/200x200/png'],
        draftLabelImages: [],
      ),

      lastOrderDate: DateTime(2026, 1, 22),
      nextDeliveryDate: DateTime(2026, 1, 28),
      contractEndDate: DateTime(2026, 12, 31),
      createdAt: DateTime(2025, 11, 12),

      lastActivityAt: DateTime(2026, 1, 25),
      lastActivitySummary: 'Order #ORD-1021 moved to production',

      totalOrders: 18,
      dueOrdersCount: 2,
      deliveredOrdersCount: 16,

      labelSmallItemId: 'label_snowtrail_small',
      labelLargeItemId: 'label_snowtrail_large',
    ),

    ClientModel(
      id: 'client_002',

      businessName: 'Hotel Royal Heights',
      businessType: 'Hotel',
      gstNumber: '06AAHCR9981Q1ZX',
      brandTier: 'Platinum',

      contactName: 'Anita Kapoor',
      contactRole: 'Procurement Manager',
      phone: '+91 98111 22334',
      email: 'procurement@royalheights.com',
      notes: 'Monthly recurring bulk orders',

      isActive: true,
      isPriority: false,

      paymentMode: 'NEFT',
      creditDays: 30,
      outstandingAmount: 0.0,

      locations: [
        ClientLocation(
          locationId: 'loc_003',
          address: 'Sector 42, Golf Course Road',
          googleMapsLink: 'https://maps.google.com/?q=golf+course+road',
          city: 'Gurgaon',
          area: 'Golf Course Road',
          isPrimary: true,
        ),
      ],

      products: [],
      media: ClientMedia(
        businessPhotos: ['https://placehold.co/200x200/png'],
        draftLabelImages: [],
      ),

      lastOrderDate: DateTime(2026, 1, 18),
      nextDeliveryDate: DateTime(2026, 2, 5),
      contractEndDate: DateTime(2027, 6, 30),
      createdAt: DateTime(2025, 10, 5),

      lastActivityAt: DateTime(2026, 1, 18),
      lastActivitySummary: 'Order #ORD-1022 delivered',

      totalOrders: 42,
      dueOrdersCount: 0,
      deliveredOrdersCount: 42,

      labelSmallItemId: 'label_royal_small',
      labelLargeItemId: 'label_royal_large',
    ),

    ClientModel(
      id: 'client_003',

      businessName: 'Olive Bistro',
      businessType: 'Restaurant',
      gstNumber: '09AABCO7788M1ZB',
      brandTier: 'Silver',

      contactName: 'Suresh Patel',
      contactRole: 'Manager',
      phone: '+91 98222 33445',
      email: 'olivebistro@gmail.com',
      notes: 'Seasonal spikes in summer months',

      isActive: true,
      isPriority: false,

      paymentMode: 'UPI',
      creditDays: 0,
      outstandingAmount: 4000.0,

      locations: [
        ClientLocation(
          locationId: 'loc_004',
          address: 'MG Road, Near Metro Station',
          googleMapsLink: 'https://maps.google.com/?q=mg+road',
          city: 'Pune',
          area: 'MG Road',
          isPrimary: true,
        ),
      ],

      products: [],

      media: ClientMedia(
        businessPhotos: ['https://placehold.co/200x200/png'],
        draftLabelImages: [],
      ),

      lastOrderDate: DateTime(2026, 1, 19),
      nextDeliveryDate: DateTime(2026, 1, 27),
      contractEndDate: null,
      createdAt: DateTime(2025, 8, 22),

      lastActivityAt: DateTime(2026, 1, 24),
      lastActivitySummary: 'Payment partially received',

      totalOrders: 9,
      dueOrdersCount: 1,
      deliveredOrdersCount: 8,

      labelSmallItemId: 'label_olive_small',
      labelLargeItemId: 'label_olive_large',
    ),

    ClientModel(
      id: 'client_004',

      businessName: 'ZenFit Gym',
      businessType: 'Gym',
      gstNumber: '08AAZFG2211R1ZT',
      brandTier: 'Bronze',

      contactName: 'Rahul Khanna',
      contactRole: 'Operations Head',
      phone: '+91 97654 11223',
      email: 'ops@zenfitgym.com',
      notes: 'Branded bottles for in-house resale',

      isActive: true,
      isPriority: true,

      paymentMode: 'Cash',
      creditDays: 7,
      outstandingAmount: 4500.0,

      locations: [
        ClientLocation(
          locationId: 'loc_005',
          address: 'Phase 2, Industrial Area',
          googleMapsLink: 'https://maps.google.com/?q=industrial+area',
          city: 'Chandigarh',
          area: 'Phase 2',
          isPrimary: true,
        ),
      ],

      products: [],

      media: ClientMedia(
        businessPhotos: ['https://placehold.co/200x200/png'],
        draftLabelImages: [],
      ),

      lastOrderDate: DateTime(2026, 1, 15),
      nextDeliveryDate: DateTime(2026, 1, 28),
      contractEndDate: null,
      createdAt: DateTime(2025, 9, 14),

      lastActivityAt: DateTime(2026, 1, 25),
      lastActivitySummary: 'Delivery delayed due to logistics',

      totalOrders: 12,
      dueOrdersCount: 2,
      deliveredOrdersCount: 10,

      labelSmallItemId: 'label_zenfit_small',
      labelLargeItemId: 'label_zenfit_large',
    ),
  ];
}



class ClientsSeedService {
  static final _db = FirebaseFirestore.instance;

  static Future<void> uploadDummyClients() async {
    final batch = _db.batch();
    final col = _db.collection('clients');

    for (final c in ClientsDummyData.list) {
      final docRef = col.doc(c.id); // repeatable seeds
      batch.set(docRef, c.toMap(), SetOptions(merge: true));
    }

    await batch.commit();
  }
}
