class Room {
  final String id;
  final String name;
  final String description;
  final List<String> tags;
  final int maxPeople;
  final int numPeople;
  final String type;
  final String hostPhotoUrl;

  Room({
    required this.id,
    required this.name,
    required this.description,
    required this.tags,
    required this.maxPeople,
    required this.numPeople,
    required this.type,
    required this.hostPhotoUrl,
  });
}
