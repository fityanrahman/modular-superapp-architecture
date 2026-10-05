import 'dart:async';

import 'auth_session.dart';

abstract interface class AuthService {
  AuthSession? get currentSession;

  Stream<AuthSession?> get sessionChanges;

  Future<AuthSession> signIn({
    required String userId,
    required String password,
  });

  Future<void> signOut();
}

class InMemoryAuthService implements AuthService {
  InMemoryAuthService({AuthSession? initialSession})
    : _current = initialSession;

  final StreamController<AuthSession?> _controller =
      StreamController<AuthSession?>.broadcast();

  AuthSession? _current;

  @override
  AuthSession? get currentSession => _current;

  @override
  Stream<AuthSession?> get sessionChanges => _controller.stream;

  @override
  Future<AuthSession> signIn({
    required String userId,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final session = AuthSession(
      userId: userId,
      displayName: userId,
      token: 'token-$userId',
    );
    _current = session;
    _controller.add(session);
    return session;
  }

  @override
  Future<void> signOut() async {
    _current = null;
    _controller.add(null);
  }
}
