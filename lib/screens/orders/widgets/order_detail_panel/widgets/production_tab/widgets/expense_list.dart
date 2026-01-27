import 'package:clwb_crm/screens/orders/models/order_expense_model.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  final List<OrderExpenseModel> expenses;

  const ExpenseList({
    super.key,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const Text(
        'No expenses added yet',
        style: TextStyle(color: Colors.grey),
      );
    }

    return Column(
      children: expenses.map((e) {
        return ListTile(
          leading: const Icon(Icons.currency_rupee),
          title: Text(e.category),
          subtitle: Text(
            '${e.vendorName} • ${e.expenseDate.toLocal().toString().split(' ').first}'
                '${e.description.isNotEmpty ? " • ${e.description}" : ""}',
          ),
          trailing: Text('₹${e.amount.toStringAsFixed(2)}'),
        );
      }).toList(),
    );
  }
}
