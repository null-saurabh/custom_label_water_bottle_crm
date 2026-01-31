// lib/screens/orders/repos/order_expense_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/firebase/audit_activity.dart';
import 'package:clwb_crm/screens/orders/models/order_expense_model.dart';

class OrderExpenseRepository {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference get ref => _firestore.collection('order_expenses');

  Stream<List<OrderExpenseModel>> watchByOrder(String orderId) {
    return ref
        .where('orderId', isEqualTo: orderId)
        .orderBy('expenseDate', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => OrderExpenseModel.fromDoc(d)).toList());
  }

  Stream<List<OrderExpenseModel>> watchClientPayments(String clientId) {
    return ref
        .where('clientId', isEqualTo: clientId)
        .where('category', isEqualTo: 'client_payment')
        .orderBy('expenseDate', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => OrderExpenseModel.fromDoc(d)).toList());
  }

  Future<void> addExpense(OrderExpenseModel e) async {
    final doc = ref.doc();

    await doc.set({
      ...e.copyWith(id: doc.id).toMap(),
      ...Audit.created(),
    });
  }

  Future<void> updateExpense(OrderExpenseModel e) async {
    await ref.doc(e.id).update({
      ...e.toMap(),
      ...Audit.updated(),
    });
  }
}
