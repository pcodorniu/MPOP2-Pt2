class Profile {
  final String username;
  final int id;
  final String email;

  Profile({required this.username, required this.id, required this.email});
  factory Profile.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'id': int id, 'email': String email, 'username': String username} =>
        Profile(username: username, id: id, email: email),
      _ => throw const FormatException('Failed to load Profile.'),
    };
  }
}
