import 'package:clwb_crm/core/utils/pack_type.dart';

class ClientPackPricing {
  final String clientId;
  final PackType packType;
  final double pricePerPack;
  final int minimumOrderPacks;
  final bool isRecurring;
  final String frequency; // daily, weekly, monthly

  ClientPackPricing({
    required this.clientId,
    required this.packType,
    required this.pricePerPack,
    required this.minimumOrderPacks,
    required this.isRecurring,
    required this.frequency,
  });

  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'packType': packType.name,
      'pricePerPack': pricePerPack,
      'minimumOrderPacks': minimumOrderPacks,
      'isRecurring': isRecurring,
      'frequency': frequency,
    };
  }

  factory ClientPackPricing.fromJson(Map<String, dynamic> json) {
    return ClientPackPricing(
      clientId: json['clientId'],
      packType: PackType.values.firstWhere(
            (e) => e.name == json['packType'],
      ),
      pricePerPack: json['pricePerPack'].toDouble(),
      minimumOrderPacks: json['minimumOrderPacks'],
      isRecurring: json['isRecurring'],
      frequency: json['frequency'],
    );
  }
}
