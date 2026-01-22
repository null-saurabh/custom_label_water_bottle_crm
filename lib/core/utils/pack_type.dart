enum PackType {
  pack500ml24,
  pack1L12,
}

extension PackTypeX on PackType {
  String get label {
    switch (this) {
      case PackType.pack500ml24:
        return '500ml (24 Pack)';
      case PackType.pack1L12:
        return '1L (12 Pack)';
    }
  }

  int get bottlesPerPack {
    switch (this) {
      case PackType.pack500ml24:
        return 24;
      case PackType.pack1L12:
        return 12;
    }
  }
}
