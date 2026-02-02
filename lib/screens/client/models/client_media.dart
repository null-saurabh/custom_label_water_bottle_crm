import 'package:cloud_firestore/cloud_firestore.dart';

class ClientMedia {
  final List<ClientMediaImage> businessPhotos;      // cafe/exterior/etc
  final ClientMediaImage? finalizedLabelImage;      // selected label
  final List<ClientMediaImage> draftLabelImages;    // multiple label revisions
  final String? agreementPdf;                       // unused for you (keep)

  const ClientMedia({
    required this.businessPhotos,
    required this.draftLabelImages,
    this.finalizedLabelImage,
    this.agreementPdf,
  });

  Map<String, dynamic> toMap() => {
    'businessPhotos': businessPhotos.map((e) => e.toMap()).toList(),
    'finalizedLabelImage': finalizedLabelImage?.toMap(),
    'draftLabelImages': draftLabelImages.map((e) => e.toMap()).toList(),
    'agreementPdf': agreementPdf,
  };

  factory ClientMedia.fromMap(Map<String, dynamic> map) {
    List<ClientMediaImage> parseList(dynamic v) {
      if (v is! List) return const [];
      return v.map((e) {
        // ✅ old format: string URL
        if (e is String) {
          return ClientMediaImage(
            url: e,
            path: '', // unknown for old records
            name: '',
            uploadedAt: null,
          );
        }
        // ✅ new format: map
        if (e is Map) {
          return ClientMediaImage.fromMap(Map<String, dynamic>.from(e));
        }
        return ClientMediaImage(url: '', path: '', name: '');
      }).where((x) => x.url.trim().isNotEmpty).toList();
    }

    ClientMediaImage? parseOne(dynamic v) {
      if (v == null) return null;
      // ✅ old format: string URL
      if (v is String) {
        if (v.trim().isEmpty) return null;
        return ClientMediaImage(url: v, path: '', name: '');
      }
      // ✅ new format: map
      if (v is Map) {
        final img = ClientMediaImage.fromMap(Map<String, dynamic>.from(v));
        return img.url.trim().isEmpty ? null : img;
      }
      return null;
    }

    return ClientMedia(
      businessPhotos: parseList(map['businessPhotos']),
      draftLabelImages: parseList(map['draftLabelImages']),
      finalizedLabelImage: parseOne(map['finalizedLabelImage']),
      agreementPdf: map['agreementPdf'] as String?,
    );
  }

  factory ClientMedia.empty() => const ClientMedia(
    businessPhotos: [],
    draftLabelImages: [],
  );
}

class ClientMediaImage {
  final String url;
  final String path; // storage path (needed for delete)
  final String name;
  final DateTime? uploadedAt;

  const ClientMediaImage({
    required this.url,
    required this.path,
    required this.name,
    this.uploadedAt,
  });

  Map<String, dynamic> toMap() => {
    'url': url,
    'path': path,
    'name': name,
    'uploadedAt': uploadedAt == null ? null : Timestamp.fromDate(uploadedAt!),
  };

  factory ClientMediaImage.fromMap(Map<String, dynamic> m) {
    final ts = m['uploadedAt'];
    return ClientMediaImage(
      url: (m['url'] ?? '').toString(),
      path: (m['path'] ?? '').toString(),
      name: (m['name'] ?? '').toString(),
      uploadedAt: ts is Timestamp ? ts.toDate() : null,
    );
  }
}
