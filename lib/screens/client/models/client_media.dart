class ClientMedia {
  final List<String> businessPhotos; // exterior, interior
  final String? finalizedLabelImage; // approved label
  final List<String> draftLabelImages; // revisions
  final String? agreementPdf;

  const ClientMedia({
    required this.businessPhotos,
    this.finalizedLabelImage,
    required this.draftLabelImages,
    this.agreementPdf,
  });

  /// For Firestore writes
  Map<String, dynamic> toMap() => {
    'businessPhotos': businessPhotos,
    'finalizedLabelImage': finalizedLabelImage,
    'draftLabelImages': draftLabelImages,
    'agreementPdf': agreementPdf,
  };

  /// For Firestore reads
  factory ClientMedia.fromMap(Map<String, dynamic> map) {
    return ClientMedia(
      businessPhotos: (map['businessPhotos'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          const [],
      finalizedLabelImage: map['finalizedLabelImage'] as String?,
      draftLabelImages: (map['draftLabelImages'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          const [],
      agreementPdf: map['agreementPdf'] as String?,
    );
  }

  /// Optional: empty default
  factory ClientMedia.empty() => const ClientMedia(
    businessPhotos: [],
    draftLabelImages: [],
  );
}
