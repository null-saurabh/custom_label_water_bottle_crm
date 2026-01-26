import 'package:flutter/material.dart';

class PanelHeader extends StatelessWidget {
  final String orderNumber;
  final VoidCallback onClose;

  const PanelHeader({
    super.key,
    required this.orderNumber,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.arrow_back),
        const SizedBox(width: 12),
        Text(
          orderNumber,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: onClose,
        ),
      ],
    );
  }
}
