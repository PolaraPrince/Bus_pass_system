class User {
  final String id;
  final String username;
  final String email;
  final String password;
  final String passId;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
     required this.passId,
  });

  DateTime? get passExpirationDate => null;
}
