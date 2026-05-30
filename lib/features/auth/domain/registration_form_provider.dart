import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistrationFormState {
  final String email;
  final String password;
  final String username;
  final String nom;
  final String cognoms;

  const RegistrationFormState({
    this.email = '',
    this.password = '',
    this.username = '',
    this.nom = '',
    this.cognoms = '',
  });

  RegistrationFormState copyWith({
    String? email,
    String? password,
    String? username,
    String? nom,
    String? cognoms,
  }) {
    return RegistrationFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      username: username ?? this.username,
      nom: nom ?? this.nom,
      cognoms: cognoms ?? this.cognoms,
    );
  }
}

class RegistrationFormNotifier
    extends StateNotifier<RegistrationFormState> {
  RegistrationFormNotifier() : super(const RegistrationFormState());

  void setEmail(String v)    => state = state.copyWith(email: v);
  void setPassword(String v) => state = state.copyWith(password: v);
  void setUsername(String v) => state = state.copyWith(username: v);
  void setNom(String v)      => state = state.copyWith(nom: v);
  void setCognoms(String v)  => state = state.copyWith(cognoms: v);
  void reset()               => state = const RegistrationFormState();
}

final registrationFormProvider =
    StateNotifierProvider<RegistrationFormNotifier, RegistrationFormState>(
  (ref) => RegistrationFormNotifier(),
);
