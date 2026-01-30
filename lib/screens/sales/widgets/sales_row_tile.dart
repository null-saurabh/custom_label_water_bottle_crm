import 'package:flutter/material.dart';

class SalesRowTile extends StatelessWidget {
  final String left;
  final String right;
  const SalesRowTile(this.left, this.right, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(child: Text(left, overflow: TextOverflow.ellipsis)),
          Text(right, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
