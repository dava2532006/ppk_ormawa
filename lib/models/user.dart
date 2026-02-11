enum UserRole { guest, user, admin }

class User {
  final String name;
  final String email;
  final UserRole role;
  final String? avatar;

  User({
    required this.name,
    required this.email,
    required this.role,
    this.avatar,
  });
}
