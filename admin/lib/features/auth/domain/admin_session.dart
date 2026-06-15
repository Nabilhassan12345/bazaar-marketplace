import 'package:firebase_auth/firebase_auth.dart';

enum AdminSessionStatus {
  loading,
  unauthenticated,
  accessDenied,
  authenticated,
}

class AdminSession {
  const AdminSession({
    required this.status,
    this.user,
  });

  final AdminSessionStatus status;
  final User? user;

  const AdminSession.loading() : this(status: AdminSessionStatus.loading);

  const AdminSession.unauthenticated()
      : this(status: AdminSessionStatus.unauthenticated);

  const AdminSession.accessDenied() : this(status: AdminSessionStatus.accessDenied);

  const AdminSession.authenticated(User user)
      : this(status: AdminSessionStatus.authenticated, user: user);
}
