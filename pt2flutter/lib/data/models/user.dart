class User {
  final String username;
  final bool authenticated;
  final String id;
  final String email;
  final String accessToken;
  User({
    required this.username,
    required this.authenticated,
    required this.id,
    required this.email,
    required this.accessToken,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    return User(
      username: user['email'] as String,
      authenticated: true,
      id: user['id'] as String,
      email: user['email'] as String,
      accessToken: json['access_token'] as String,
    );
  }
}
