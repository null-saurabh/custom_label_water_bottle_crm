// inventory/models/bottle_inventory.dart
class BottleInventory {
  final String size;
  final String shape;
  final int available;
  final int reserved;
  final int minimum;

  BottleInventory({
    required this.size,
    required this.shape,
    required this.available,
    required this.reserved,
    required this.minimum,
  });
}
