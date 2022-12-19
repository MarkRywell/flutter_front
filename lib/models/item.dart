class Item {
  final int id;
  final String name;
  final String details;
  final int userId;
  final String sold;
  String? createdAt;
  String? updatedAt;

  Item({
    required this.id,
    required this.name,
    required this.details,
    required this.userId,
    required this.sold,
    this.createdAt,
    this.updatedAt
  });
}