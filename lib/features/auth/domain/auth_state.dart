enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  successful,
  awaitingEmailVerification,
  error,
}

class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final String? userId;
  final String? email;

  AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.userId,
    this.email,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    String? userId,
    String? email,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      userId: userId ?? this.userId,
      email: email ?? this.email,
    );
  }
}