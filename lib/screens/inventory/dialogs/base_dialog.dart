import 'package:clwb_crm/core/widgets/premium_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';




class BaseDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? footer; // 👈 NEW (optional)

  const BaseDialog({
    super.key,
    required this.title,
    required this.child,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 40,
                offset: const Offset(0, 24),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const Divider(height: 24),

              /// BODY
              Flexible(
                child: SingleChildScrollView(child: child),
              ),

              const SizedBox(height: 24),

              /// FOOTER (custom or default)
              footer ??
                  PremiumButton(
                    text: 'Submit',
                    onTap: () {},
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
class Field extends StatelessWidget {
  final String label;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  const Field({
    super.key,
    required this.label,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        maxLines: maxLines,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class Dropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final ValueChanged<String?>? onChanged;

  const Dropdown({
    super.key,
    required this.label,
    required this.items,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}




class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}



