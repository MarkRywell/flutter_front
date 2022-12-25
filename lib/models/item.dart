class Item {
  final int id;
  final String name;
  final String details;
  final int userId;
  final String sold;
  final String picture;
  String? soldTo;
  String? createdAt;
  String? updatedAt;

  Item({
    required this.id,
    required this.name,
    required this.details,
    required this.userId,
    required this.sold,
    required this.picture,
    this.soldTo,
    this.createdAt,
    this.updatedAt
  });

  factory Item.fromJson(Map <String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      details: json['details'],
      userId: json['userId'],
      sold: json['sold'],
      picture: json['picture'],
      soldTo: json['soldTo'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map <String, dynamic> toMap () {
    return {
      'id' : id,
      'name' : name,
      'details' : details,
      'userId' : userId,
      'sold' : sold,
      'picture' : picture,
      'soldTo' : soldTo,
      'created_at' : createdAt,
      'updated_at' : updatedAt,
    };
  }
}