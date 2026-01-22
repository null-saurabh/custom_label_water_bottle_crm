// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/client_model.dart';
//



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/screens/client/models/client_location.dart';
import 'package:clwb_crm/screens/client/models/client_media.dart';
import '../models/client_model.dart';

class ClientRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference get _ref => _db.collection('clients');
  CollectionReference get ref => _db.collection('clients');

  Future<String> addClient(ClientModel client) async {
    final doc = await _ref.add(client.toJson());
    return doc.id;
  }

  Stream<List<ClientModel>> watchClients() {
    return _ref
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (s) => s.docs.map((d) => ClientModel.fromJson(d.data() as Map<String, dynamic>, id: d.id)).toList(),
    );
  }

  Future<void> updateClient({
    required String clientId,
    required Map<String, dynamic> data,
  }) async {
    await _ref.doc(clientId).update({
      ...data,
      'lastActivityAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteClient(String clientId) async {
    final ref = _ref.doc(clientId);

    final activities = await ref.collection('activities').get();
    for (final doc in activities.docs) {
      await doc.reference.delete();
    }

    await ref.delete();
  }



  // Future<void> seedDemoClients() async {
  //   final db = FirebaseFirestore.instance;
  //   final now = DateTime.now();

    // -------------------------------
    // 1️⃣ DEFINE DEMO DATA (SEPARATED)
    // -------------------------------
    //
    // final demoData = [
    //   {
    //     'client': ClientModel(
    //       id: '',
    //       businessName: 'Himalayan Brew House',
    //       businessType: 'Brewery',
    //       gstNumber: 'GSTIN111HIM',
    //       brandTier: 'Premium',
    //       contactName: 'Karan Thakur',
    //       contactRole: 'Founder',
    //       phone: '9811112233',
    //       email: 'karan@himalayanbrew.com',
    //       isActive: true,
    //       isPriority: true,
    //       paymentMode: 'Credit',
    //       creditDays: 21,
    //       outstandingAmount: 18400.0,
    //       locations: [
    //         ClientLocation(
    //           locationId: 'loc4',
    //           address: 'Log Hut Area, Old Manali',
    //           googleMapsLink: 'https://maps.google.com/?q=Old+Manali',
    //           city: 'Deoghar',
    //           area: 'Station',
    //           isPrimary: true,
    //         ),
    //       ],
    //       products: [],
    //       media: ClientMedia.empty(),
    //       lastOrderDate: now.subtract(const Duration(days: 2)),
    //       nextDeliveryDate: now.add(const Duration(days: 3)),
    //       contractEndDate: now.add(const Duration(days: 300)),
    //       createdAt: now.subtract(const Duration(days: 60)),
    //       totalOrders: 14,
    //       dueOrdersCount: 1,
    //       deliveredOrdersCount: 13,
    //       lastActivityAt: now.subtract(const Duration(days: 2)),
    //       lastActivitySummary: 'Order placed',
    //     ),
    //     'activities': [
    //       ClientActivity(
    //         id: 'a1',
    //         type: ClientActivityType.created,
    //         title: 'Client created',
    //         note: 'Himalayan Brew House onboarded into CRM',
    //         userName: 'Admin',
    //         at: now.subtract(const Duration(days: 60)),
    //       ),
    //       ClientActivity(
    //         id: 'a2',
    //         type: ClientActivityType.call,
    //         title: 'Intro call',
    //         note: 'Discussed branding & pack options',
    //         userName: 'Saurabh',
    //         at: now.subtract(const Duration(days: 59)),
    //       ),
    //       ClientActivity(
    //         id: 'a3',
    //         type: ClientActivityType.order,
    //         title: 'Order placed',
    //         note: 'Order #HB1021 for 1L Premium bottles',
    //         userName: 'System',
    //         at: now.subtract(const Duration(days: 2)),
    //       ),
    //     ],
    //   },
    //
    //   {
    //     'client': ClientModel(
    //       id: '',
    //       businessName: 'Cafe Snowtrail',
    //       businessType: 'Cafe',
    //       gstNumber: 'GSTIN222CAF',
    //       brandTier: 'Standard',
    //       contactName: 'Meera Joshi',
    //       contactRole: 'Owner',
    //       phone: '9988776655',
    //       email: 'meera@snowtrailcafe.com',
    //       isActive: true,
    //       isPriority: false,
    //       paymentMode: 'UPI',
    //       creditDays: 0,
    //       outstandingAmount: 0.0,
    //       locations: [
    //         ClientLocation(
    //           locationId: 'loc5',
    //           address: 'Vashisht Road',
    //           googleMapsLink: 'https://maps.google.com/?q=Vashisht',
    //           city: 'Deoghar',
    //           area: 'Mandir',
    //           isPrimary: true,
    //         ),
    //       ],
    //       products: [],
    //       media: ClientMedia.empty(),
    //       lastOrderDate: now.subtract(const Duration(days: 7)),
    //       nextDeliveryDate: null,
    //       contractEndDate: null,
    //       createdAt: now.subtract(const Duration(days: 25)),
    //       totalOrders: 4,
    //       dueOrdersCount: 0,
    //       deliveredOrdersCount: 4,
    //       lastActivityAt: now.subtract(const Duration(days: 7)),
    //       lastActivitySummary: 'Order placed',
    //     ),
    //     'activities': [
    //       ClientActivity(
    //         id: 'a4',
    //         type: ClientActivityType.created,
    //         title: 'Client created',
    //         note: 'Cafe Snowtrail added to CRM',
    //         userName: 'Admin',
    //         at: now.subtract(const Duration(days: 25)),
    //       ),
    //       ClientActivity(
    //         id: 'a5',
    //         type: ClientActivityType.email,
    //         title: 'Pricing email sent',
    //         note: 'Shared updated price list PDF',
    //         userName: 'Saurabh',
    //         at: now.subtract(const Duration(days: 24)),
    //       ),
    //       ClientActivity(
    //         id: 'a6',
    //         type: ClientActivityType.order,
    //         title: 'Order placed',
    //         note: 'Order #CS204 for 500ml bottles',
    //         userName: 'System',
    //         at: now.subtract(const Duration(days: 7)),
    //       ),
    //     ],
    //   },
    //
    //   {
    //     'client': ClientModel(
    //       id: '',
    //       businessName: 'Valley View Lodge',
    //       businessType: 'Lodge',
    //       gstNumber: 'GSTIN333VAL',
    //       brandTier: 'Enterprise',
    //       contactName: 'Amit Kapoor',
    //       contactRole: 'Operations Manager',
    //       phone: '9090909090',
    //       email: 'amit@valleyviewlodge.com',
    //       isActive: false,
    //       isPriority: false,
    //       paymentMode: 'Credit',
    //       creditDays: 60,
    //       outstandingAmount: 67200.0,
    //       locations: [
    //         ClientLocation(
    //           locationId: 'loc6',
    //           address: 'Hadimba Road',
    //           googleMapsLink: 'https://maps.google.com/?q=Hadimba+Road',
    //           city: 'Deoghar',
    //           area: 'Parking',
    //           isPrimary: true,
    //         ),
    //       ],
    //       products: [],
    //       media: ClientMedia.empty(),
    //       lastOrderDate: now.subtract(const Duration(days: 32)),
    //       nextDeliveryDate: null,
    //       contractEndDate: now.add(const Duration(days: 120)),
    //       createdAt: now.subtract(const Duration(days: 90)),
    //       totalOrders: 18,
    //       dueOrdersCount: 3,
    //       deliveredOrdersCount: 15,
    //       lastActivityAt: now.subtract(const Duration(days: 10)),
    //       lastActivitySummary: 'Internal note added',
    //     ),
    //     'activities': [
    //       ClientActivity(
    //         id: 'a7',
    //         type: ClientActivityType.created,
    //         title: 'Client created',
    //         note: 'Valley View Lodge onboarded',
    //         userName: 'Admin',
    //         at: now.subtract(const Duration(days: 90)),
    //       ),
    //       ClientActivity(
    //         id: 'a8',
    //         type: ClientActivityType.call,
    //         title: 'Payment follow-up call',
    //         note: 'Discussed overdue invoices',
    //         userName: 'Saurabh',
    //         at: now.subtract(const Duration(days: 15)),
    //       ),
    //       ClientActivity(
    //         id: 'a9',
    //         type: ClientActivityType.note,
    //         title: 'Internal note added',
    //         note: 'Client requested temporary hold on new orders',
    //         userName: 'Saurabh',
    //         at: now.subtract(const Duration(days: 10)),
    //       ),
    //     ],
    //   },
    // ];
    //
    // // -------------------------------
    // // 2️⃣ WRITE TO FIRESTORE
    // // -------------------------------
    //
    // for (final entry in demoData) {
    //   final client = entry['client'] as ClientModel;
    //   final activities = entry['activities'] as List<ClientActivity>;
    //
    //   // add client
    //   final docRef =
    //   await db.collection('clients').add(client.toJson());
    //
    //   // add activities
    //   for (final a in activities) {
    //     await docRef
    //         .collection('activities')
    //         .doc(a.id)
    //         .set({
    //       'type': a.type.name,
    //       'title': a.title,
    //       'note': a.note,
    //       'userName': a.userName,
    //       'at': Timestamp.fromDate(a.at),
    //     });
    //   }
    // }
  // }
}





// class ClientRepository {
//   final _db = FirebaseFirestore.instance;
//
//   CollectionReference get _ref => _db.collection('clients');
//
//   CollectionReference<Map<String, dynamic>> get ref =>
//       _db.collection('clients');
//
//   Future<String> addClient(ClientModel client) async {
//     final doc = await _ref.add(client.toJson());
//     return doc.id;
//   }
//
//   Stream<List<ClientModel>> watchClients() {
//     return _ref
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map(
//           (s) => s.docs.map((d) => ClientModel.fromJson(d.data() as Map<String, dynamic>,id:  d.id)).toList(),
//     );
//   }
//
//   Future<void> updateClient({
//     required String clientId,
//     required Map<String, dynamic> data,
//   }) async {
//     await _ref.doc(clientId).update({
//       ...data,
//       'lastActivityAt': FieldValue.serverTimestamp(),
//     });
//   }
//
//   Future<void> deleteClient(String clientId) async {
//     final ref = _ref.doc(clientId);
//
//     final activities = await ref.collection('activities').get();
//     for (final doc in activities.docs) {
//       await doc.reference.delete();
//     }
//
//     await ref.delete();
//   }
//
//
//
//
//
//
// }
