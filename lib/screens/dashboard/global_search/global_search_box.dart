import 'package:clwb_crm/screens/dashboard/models/global_search_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'global_search_controller.dart';

class GlobalSearchBox extends StatefulWidget {
  const GlobalSearchBox({super.key});

  @override
  State<GlobalSearchBox> createState() => _GlobalSearchBoxState();
}

class _GlobalSearchBoxState extends State<GlobalSearchBox> {
  final c = Get.find<GlobalSearchController>();
  final focusNode = FocusNode();
  final textCtrl = TextEditingController();
  OverlayEntry? _overlay;

  @override
  void initState() {
    super.initState();

    ever<String>(c.query, (v) {
      if (textCtrl.text != v) textCtrl.text = v;
      if (v.isEmpty) {
        _removeOverlay();
      }
    });

    ever<bool>(c.isOpen, (open) {
      if (open) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    });
  }

  @override
  void dispose() {
    _removeOverlay();
    focusNode.dispose();
    textCtrl.dispose();
    super.dispose();
  }

  void _showOverlay() {
    if (_overlay != null) return;

    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final size = box.size;
    final offset = box.localToGlobal(Offset.zero);

    _overlay = OverlayEntry(
      builder: (_) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 8,
        width: size.width,
        child: Material(
          color: Colors.transparent,
          child: _SearchDropdown(),
        ),
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_overlay!);
  }

  void _removeOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (e) {
        if (!c.isOpen.value) return;
        if (e is! RawKeyDownEvent) return;

        if (e.logicalKey == LogicalKeyboardKey.arrowDown) {
          c.moveDown();
        } else if (e.logicalKey == LogicalKeyboardKey.arrowUp) {
          c.moveUp();
        } else if (e.logicalKey == LogicalKeyboardKey.enter) {
          c.submitFocused();
        } else if (e.logicalKey == LogicalKeyboardKey.escape) {
          c.close();
        }
      },
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: TextField(
          controller: textCtrl,
          focusNode: focusNode,
          onChanged: (v) => c.query.value = v,
          onTap: () {
            if (c.query.value.trim().isNotEmpty) c.open();
          },
          decoration: InputDecoration(
            hintText:
            'Search orders, clients, leads, inventory, suppliers',
            prefixIcon: const Icon(Icons.search),
            border: InputBorder.none,
            contentPadding:
            const EdgeInsets.symmetric(vertical: 12),
            suffixIcon: Obx(() {
              if (c.query.value.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  c.clear();
                  textCtrl.clear();
                  focusNode.requestFocus();
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}





class _SearchDropdown extends StatelessWidget {
  final c = Get.find<GlobalSearchController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (c.results.isEmpty) return const SizedBox.shrink();

      // ✅ FORCE dependency tracking
      final focusedIndex = c.focusedIndex.value;

      return ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 360),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE6EAF2)),
            boxShadow: const [
              BoxShadow(
                blurRadius: 18,
                offset: Offset(0, 8),
                color: Color(0x22000000),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: ListView.builder(
              controller: c.scrollCtrl,
              padding: const EdgeInsets.symmetric(vertical: 8),
              shrinkWrap: true, // ✅ NOW allowed
              itemCount: c.results.length,
              itemBuilder: (_, i) {
                final r = c.results[i];
                final focused = focusedIndex == i;

                return MouseRegion(
                  onEnter: (_) => c.focusedIndex.value = i,
                  child: _ResultTile(
                    result: r,
                    focused: focused,
                    onTap: () => c.onSelect(r),
                  ),
                );
              },
            ),
          ),
        ),
      );



    });

  }
}



class _ResultTile extends StatelessWidget {
  final GlobalSearchResult result;
  final bool focused;
  final VoidCallback onTap;

  const _ResultTile({
    required this.result,
    required this.focused,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = _accent(result.type);

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: focused ? const Color(0xFFF1F5FF) : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(_icon(result.type), size: 18, color: accent),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (result.subtitle.trim().isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      result.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Color _accent(GlobalSearchType t) {
    switch (t) {
      case GlobalSearchType.order:
        return const Color(0xFF059669); // Emerald-600
      case GlobalSearchType.inventoryItem:
        return const Color(0xFFF59E0B);
      case GlobalSearchType.lead:
        return const Color(0xFFF97316);
      case GlobalSearchType.client:
        return const Color(0xFF7C3AED);//Color(0xFF16A34A);
      case GlobalSearchType.supplier:
        return const Color(0xFF0EA5E9);
    }
  }

  IconData _icon(GlobalSearchType t) {
    switch (t) {
      case GlobalSearchType.order:
        return Icons.receipt_long_outlined;
      case GlobalSearchType.inventoryItem:
        return Icons.inventory_2_outlined;
      case GlobalSearchType.lead:
        return Icons.person_outline;
      case GlobalSearchType.client:
        return Icons.people_outline;
      case GlobalSearchType.supplier:
        return Icons.local_shipping_outlined;
    }
  }

}




