class User {

  final int id;
  final String name;
  final String contactNo;
  String? picture;
  final String email;
  final String address;

  User({
    required this.id,
    required this.name,
    required this.contactNo,
    this.picture,
    required this.email,
    required this.address
  });

  factory User.fromMapObject(Map <String, Object?> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      contactNo: json['contactNo'] as String,
      picture: json['picture'] as String,
      email: json['email'] as String,
      address: json['id'] as String,
    );
  }

  Map <String, dynamic> toMap() {
    return {
      'id' : id,
      'name' : name,
      'contactNo' : contactNo,
      'picture' : picture,
      'email' : email,
      'address' : address
    };
  }

}