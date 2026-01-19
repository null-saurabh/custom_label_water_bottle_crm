// dashboard/widgets/sku_health_table.dart
import 'package:flutter/material.dart';
import '../../../core/widgets/risk_indicator.dart';

class SKUHealthTable extends StatelessWidget {
  const SKUHealthTable({super.key});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('SKU')),
        DataColumn(label: Text('Labels')),
        DataColumn(label: Text('Bottles')),
        DataColumn(label: Text('Due Today')),
        DataColumn(label: Text('Due Week')),
        DataColumn(label: Text('Risk')),
      ],
      rows: List.generate(5, (i) {
        return DataRow(cells: [
          DataCell(Text('A + 500ml + A$i')),
          DataCell(Text('1200')),
          DataCell(Text('900')),
          DataCell(Text('300')),
          DataCell(Text('600')),
          const DataCell(RiskIndicator(RiskLevel.yellow)),
        ]);
      }),
    );
  }
}
