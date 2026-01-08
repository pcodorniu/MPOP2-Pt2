class User {
  final String username;
  final bool authenticated;
  final int id;
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
    return switch (json) {
      {
        'username': String username,
        'id': int id,
        'email': String email,
        'accessToken': String accessToken,
      } =>
        User(
          username: username,
          authenticated: true,
          id: id,
          email: email,
          accessToken: accessToken,
        ),
      _ => throw const FormatException('Failed to load User.'),
    };
  }
}
