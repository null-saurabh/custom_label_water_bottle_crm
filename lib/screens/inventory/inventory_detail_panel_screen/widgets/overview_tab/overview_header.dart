import 'package:clwb_crm/screens/inventory/dialogs/edit_item_dialog.dart';
import 'package:clwb_crm/screens/inventory/model/bottle_config.dart';
import 'package:clwb_crm/screens/inventory/model/cap_config.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_item_detail.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_item_model.dart';
import 'package:clwb_crm/screens/inventory/model/label_config.dart';
import 'package:clwb_crm/screens/inventory/model/package_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OverviewHeader extends StatelessWidget {
  final InventoryItemDetail detail;

  const OverviewHeader({
    super.key,
    required this.detail,

  });

  @override
  Widget build(BuildContext context) {
    final item = detail.item;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 120,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.blue.shade50,
          ),
          child: const Icon(
            Icons.local_drink,
            size: 48,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // const SizedBox(width: 6),
                  IconButton(
                    onPressed: () {
                      Get.dialog(
                        EditItemDialog(detail: detail),
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 12),
              _spec('Item ID', item.id),
              _spec('Category', item.category.name),
              _CategorySpecs(detail: detail),
            ],
          ),
        ),
      ],
    );
  }


}


Widget _spec(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            '$label:',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    ),
  );
}


class _CategorySpecs extends StatelessWidget {
  final InventoryItemDetail detail;

  const _CategorySpecs({required this.detail});

  @override
  Widget build(BuildContext context) {
    switch (detail.item.category) {
      case InventoryCategory.bottle:
        final b = detail.bottle;
        return b == null
            ? _MissingConfig()
            : _BottleSpecs(b);

      case InventoryCategory.cap:
        final c = detail.cap;
        return c == null
            ? _MissingConfig()
            : _CapSpecs(c);

      case InventoryCategory.label:
        final l = detail.label;
        return l == null
            ? _MissingConfig()
            : _LabelSpecs(l);

      case InventoryCategory.packaging:
        final p = detail.packaging;
        return p == null
            ? _MissingConfig()
            : _PackagingSpecs(p);
    }
  }
}


class _MissingConfig extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text(
      'Configuration not available',
      style: TextStyle(color: Colors.red),
    );
  }
}



class _BottleSpecs extends StatelessWidget {
  final BottleConfig c;
  const _BottleSpecs(this.c);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _spec('Size', '${c.sizeMl} ML'),
        _spec('Pack Size', '${c.packSize} Bottles / Pack'),
        _spec('Shape', c.shape),
        _spec('Neck Type', c.neckType),
      ],
    );
  }
}

class _CapSpecs extends StatelessWidget {
  final CapConfig c;
  const _CapSpecs(this.c);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _spec('Size', c.size),
        _spec('Color', c.color),
        _spec('Material', c.material),
      ],
    );
  }
}
class _LabelSpecs extends StatelessWidget {
  final LabelConfig c;
  const _LabelSpecs(this.c);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _spec('Width', '${c.widthMm} mm'),
        _spec('Height', '${c.heightMm} mm'),
        _spec('Material', c.material),
        _spec('Client Specific', c.isClientSpecific ? 'Yes' : 'No'),
      ],
    );
  }
}

class _PackagingSpecs extends StatelessWidget {
  final PackagingConfig c;
  const _PackagingSpecs(this.c);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _spec('Type', c.type),
        _spec('Capacity', '${c.capacity} Bottles'),
      ],
    );
  }
}

