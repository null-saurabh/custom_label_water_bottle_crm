import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final double? width;
  final double? height;

  const StatCard({super.key,
    required this.child,
    this.gradient, this.width, this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 280,
      height: height ?? 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? Colors.white : null,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
