import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/firebase/audit_activity.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_item_model.dart';

class InventoryItemRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference get _ref => _db.collection('inventory_items');

  Stream<List<InventoryItemModel>> watchItems() {
    return _ref.snapshots().map(
          (s) => s.docs.map((d) => InventoryItemModel.fromDoc(d)).toList(),
    );
  }

  Stream<InventoryItemModel?> watchItemById(String itemId) {
    return _ref.doc(itemId).snapshots().map(
          (d) => d.exists ? InventoryItemModel.fromDoc(d) : null,
    );
  }

  Future<String> addItem(InventoryItemModel item) async {
    final doc = _ref.doc();

    await doc.set({
      ...item.copyWith(id: doc.id).toMap(),
      ...Audit.created(),
    });

    return doc.id;
  }

  Future<void> updateItem(String itemId, Map<String, dynamic> data) {
    return _ref.doc(itemId).update({
      ...data,
      ...Audit.updated(),
    });
  }

  Future<void> deactivateItem(String itemId) {
    return _ref.doc(itemId).update({
      'isActive': false,
      ...Audit.updated(),
    });
  }

  Future<void> deleteItem(String itemId) {
    return _ref.doc(itemId).delete();
  }

  Future<void> incrementStock(String itemId, int qty) {
    return _ref.doc(itemId).update({
      'stock': FieldValue.increment(qty),
      ...Audit.updated(),
    });
  }

  Future<void> decrementStock(String itemId, int qty) {
    return _ref.doc(itemId).update({
      'stock': FieldValue.increment(-qty),
      ...Audit.updated(),
    });
  }

  Future<void> applyStockDeltasTransactional({
    required Map<String, int> itemDeltas,
  }) async {
    if (itemDeltas.isEmpty) return;

    final batch = _db.batch();

    // 1️⃣ Read & validate OUTSIDE transaction (Web-safe)
    final snapshots = <String, DocumentSnapshot>{};

    for (final entry in itemDeltas.entries) {
      final itemId = entry.key.trim();
      if (itemId.isEmpty) {
        throw StateError('Invalid inventory itemId');
      }

      final snap = await _ref.doc(itemId).get();
      if (!snap.exists) {
        throw StateError('Inventory item not found: $itemId');
      }

      snapshots[itemId] = snap;
    }

    // 2️⃣ Validate stock
    for (final entry in itemDeltas.entries) {
      final itemId = entry.key;
      final delta = entry.value;

      final data = snapshots[itemId]!.data() as Map<String, dynamic>? ?? {};

      final currentStockRaw = data['stock'];
      final currentStock = (currentStockRaw is int)
          ? currentStockRaw
          : int.tryParse(currentStockRaw?.toString() ?? '') ?? 0;

      final newStock = currentStock + delta;
      if (newStock < 0) {
        final name = (data['name'] ?? itemId).toString();
        throw StateError(
          'Insufficient stock for $name (Need ${delta.abs()}, Available $currentStock)',
        );
      }
    }

    // 3️⃣ Apply updates in batch
    for (final entry in itemDeltas.entries) {
      final itemId = entry.key;
      final delta = entry.value;

      batch.update(_ref.doc(itemId), {
        'stock': FieldValue.increment(delta),
        ...Audit.updated(),
      });
    }

    await batch.commit();
  }
}
