enum UserRole {
  user,
  moderator,
  admin;

  String get value => name;

  static UserRole fromValue(String value) => switch (value) {
        'moderator' => UserRole.moderator,
        'admin' => UserRole.admin,
        _ => UserRole.user,
      };
}
