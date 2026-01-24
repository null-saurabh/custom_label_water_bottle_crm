import 'package:cloud_firestore/cloud_firestore.dart';

class CapConfig {
  final String itemId;

  final String size;     // 28mm / 30mm
  final String color;    // White / Blue / Black
  final String material; // Plastic / Bio / Metal

  CapConfig({
    required this.itemId,
    required this.size,
    required this.color,
    required this.material,
  });

  factory CapConfig.fromMap(Map<String, dynamic> d) {
    return CapConfig(
      itemId: (d['itemId'] ?? '').toString(),
      size: (d['size'] ?? '').toString(),
      color: (d['color'] ?? '').toString(),
      material: (d['material'] ?? '').toString(),
    );
  }

  factory CapConfig.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return CapConfig.fromMap({
      ...data,
      'itemId': data['itemId'] ?? doc.id,
    });
  }


  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'size': size,
      'color': color,
      'material': material,
    };
  }

  CapConfig copyWith({
    String? itemId,
    String? size,
    String? color,
    String? material,
  }) {
    return CapConfig(
      itemId: itemId ?? this.itemId,
      size: size ?? this.size,
      color: color ?? this.color,
      material: material ?? this.material,
    );
  }
}
