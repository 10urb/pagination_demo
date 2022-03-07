class UserModel {
  String name;
  String email;
  String imageUrl;
  UserModel({
    required this.name,
    required this.email,
    required this.imageUrl,
  });
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map["name"]["first"] + " " + map["name"]["last"],
      email: map["email"],
      imageUrl: map["picture"]["large"],
    );
  }
}
