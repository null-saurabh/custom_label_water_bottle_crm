class InventoryWarning {
  final String displayName; // Bottle shape OR Brand name
  final String sizeCode;    // S / L
  final bool isBottle;    // S / L
  final int due;
  final int stock;

  InventoryWarning({
    required this.isBottle,
    required this.displayName,
    required this.sizeCode,
    required this.due,
    required this.stock,
  });

  int get shortfall => (due - stock) > 0 ? (due - stock) : 0;
}
