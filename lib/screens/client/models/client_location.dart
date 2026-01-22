class ClientLocation {
  final String locationId;
  final String address;
  final String googleMapsLink;
  final String city;
  final String state;
  final bool isPrimary;

  const ClientLocation({
    required this.locationId,
    required this.address,
    required this.googleMapsLink,
    required this.city,
    required this.state,
    required this.isPrimary,
  });

  /// For Firestore writes
  Map<String, dynamic> toMap() => {
    'locationId': locationId,
    'address': address,
    'googleMapsLink': googleMapsLink,
    'city': city,
    'state': state,
    'isPrimary': isPrimary,
  };

  /// For Firestore reads
  factory ClientLocation.fromMap(Map<String, dynamic> map) {
    return ClientLocation(
      locationId: (map['locationId'] ?? '') as String,
      address: (map['address'] ?? '') as String,
      googleMapsLink: (map['googleMapsLink'] ?? '') as String,
      city: (map['city'] ?? '') as String,
      state: (map['state'] ?? '') as String,
      isPrimary: (map['isPrimary'] ?? false) as bool,
    );
  }
}
