class User {
  final int? id;
  final String email;
  final String user;
  final String password;
  final String? token;
  final String? tokenDuration;

  const User(
      {this.id,
      required this.email,
      required this.user,
      required this.password,
      this.token,
      this.tokenDuration});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'] as int,
        email: json['email'] as String,
        user: json['user'] as String,
        password: json['password'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'user': user,
      'password': password,
    };
  }
}
