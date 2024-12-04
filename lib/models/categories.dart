class Category {
  final String id;
  final String name;
  final String description;
  String? thumbnail; // URL of the image stored in Firebase

  Category({
    required this.id,
    required this.name,
    required this.description,
    this.thumbnail,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'thumbnail': thumbnail,
    };
  }

  // Convert from Map (Firestore Document) to Category object
  factory Category.fromMap(Map<String, dynamic> map, String id) {
    return Category(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      thumbnail: map['thumbnail'] as String?,
    );
  }
}
