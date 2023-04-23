class User {
  final Map<String, dynamic> Data;
  final bool Success;
  const User({required this.Data, required this.Success});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(Data: json["Data"], Success: json["Success"]);
  }
}
