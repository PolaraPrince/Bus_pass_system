class AuthenticatedUser {
  final String id;
  final String username;
  final String email;
  final String passwordHash;

  AuthenticatedUser({
    required this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
  });
}

class UserProfile {
  final String name;
  final String profession;
  final String email;
  final String mobile;
  final String address;
  final String duration;
  

  UserProfile({
    required this.name,
    required this.profession,
    required this.email,
    required this.mobile,
    required this.address,
    required this.duration,
  });
}
