class User {
  final Map<String, dynamic> Data;
  final bool Success;
  final String? Message;
  const User(
      {required this.Data, required this.Success, required this.Message});

  factory User.fromJson(Map<String, dynamic> json) {
    if (!json["Success"]) {
      return User(Data: {}, Success: false, Message: json["Message"]);
    }
    return User(
        Data: json["Data"], Success: json["Success"], Message: json["Message"]);
  }
}
