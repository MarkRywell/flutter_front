class Item {
  final int id;
  final String name;
  final String details;
  final int userId;
  final String sold;
  final String picture;
  String? createdAt;
  String? updatedAt;

  Item({
    required this.id,
    required this.name,
    required this.details,
    required this.userId,
    required this.sold,
    required this.picture,
    this.createdAt,
    this.updatedAt
  });

  Map <String, dynamic> toMap () {
    return {
      'id' : id,
      'name' : name,
      'details' : details,
      'userId' : userId,
      'sold' : sold,
      'picture' : picture,
      'created_at' : createdAt,
      'updated_at' : updatedAt,
    };
  }
}