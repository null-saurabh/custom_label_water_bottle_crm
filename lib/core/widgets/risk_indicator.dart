// core/widgets/risk_indicator.dart
import 'package:flutter/material.dart';

enum RiskLevel { green, yellow, red }

class RiskIndicator extends StatelessWidget {
  final RiskLevel level;

  const RiskIndicator(this.level, {super.key});

  @override
  Widget build(BuildContext context) {
    Color color = switch (level) {
      RiskLevel.green => Colors.green,
      RiskLevel.yellow => Colors.orange,
      RiskLevel.red => Colors.red,
    };
    return Icon(Icons.circle, color: color, size: 12);
  }
}
