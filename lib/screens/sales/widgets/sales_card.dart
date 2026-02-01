import 'package:flutter/material.dart';

class SalesCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final double maxHeight;

  const SalesCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.maxHeight = 500,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE6EAF2)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // 🔥 IMPORTANT
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              /// 🔥 THIS IS THE MAGIC
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: maxHeight,
                ),
                child: child,
              ),
            ],
          ),
        );
      },
    );
  }
}
