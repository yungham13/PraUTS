// lib/models/item.dart
class Item {
  final int id;
  final String name;
  final String description;

  Item({
    required this.id,
    this.name = '',
    this.description = '',
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
