import 'package:clwb_crm/screens/orders/models/order_production_entry_model.dart';
import 'package:flutter/material.dart';

class ProductionTimeline extends StatelessWidget {
  final List<OrderProductionEntryModel> entries;

  const ProductionTimeline({
    super.key,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Text(
        'No production entries yet',
        style: TextStyle(color: Colors.grey),
      );
    }

    return Column(
      children: entries.map((e) {
        return ListTile(
          leading: const Icon(Icons.factory),
          title: Text('${e.quantityProducedToday} bottles produced',style: TextStyle(fontSize: 12)),
          subtitle: Text(
            '${e.productionDate.toLocal().toString().split(' ').first}'
                '${e.notes.isNotEmpty ? " • ${e.notes}" : ""}',
          ),
          // trailing: Text('Total: ${e.cumulativeProduced}'),
        );
      }).toList(),
    );
  }
}
