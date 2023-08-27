class User {
  final String id;
  final String username;
  final String email;
  final String passwordHash; // Store the hashed password instead of plaintext.

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
  });
}
