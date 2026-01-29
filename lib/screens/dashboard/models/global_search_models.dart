enum GlobalSearchType { order, client, lead, inventoryItem, supplier }

class GlobalSearchResult {
  final GlobalSearchType type;
  final String id;
  final String title;
  final String subtitle;

  const GlobalSearchResult({
    required this.type,
    required this.id,
    required this.title,
    required this.subtitle,
  });
}
