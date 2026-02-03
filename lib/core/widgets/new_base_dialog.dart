import 'package:clwb_crm/core/widgets/premium_button.dart';
import 'package:flutter/material.dart';

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
        child: SingleChildScrollView(
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior.onDrag,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER (scrolls)
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

                /// BODY + FOOTER scroll together
                child,

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
      ),
    );
  }
}
