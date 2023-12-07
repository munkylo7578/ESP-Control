class User {
  final Map<String, dynamic> data;
  final bool success;
  final String? message;

  const User({
    required this.data,
    required this.success,
    required this.message,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      data: json['Data'] ?? {},
      success: json['Success'],
      message: json['Message'],
    );
  }
}
