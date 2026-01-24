import 'package:flutter/material.dart';

class InventoryDetailPanelHeader extends StatelessWidget {
  final VoidCallback onClose;

  const InventoryDetailPanelHeader({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onClose,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Round Bottle 500 ML',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
