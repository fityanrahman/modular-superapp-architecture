class AuthSession {
  const AuthSession({
    required this.userId,
    required this.displayName,
    required this.token,
  });

  final String userId;
  final String displayName;
  final String token;

  bool get isAuthenticated => token.isNotEmpty;
}
