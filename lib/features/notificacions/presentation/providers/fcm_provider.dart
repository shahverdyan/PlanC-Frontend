import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/dio_provider.dart';
import '../../../auth/domain/auth_provider.dart';
import '../../data/repositories/fcm_repository.dart';

final fcmRepositoryProvider = Provider<FcmRepository>((ref) {
  return FcmRepository(ref.read(dioProvider));
});

enum FcmStatus { idle, loading, permissionDenied, registered, error }

class FcmState {
  final FcmStatus status;
  final String? errorMessage;

  const FcmState({this.status = FcmStatus.idle, this.errorMessage});

  FcmState copyWith({FcmStatus? status, String? errorMessage}) {
    return FcmState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class FcmNotifier extends StateNotifier<FcmState> {
  final FcmRepository _repository;
  final String? _userId;
  StreamSubscription<String>? _tokenRefreshSubscription;

  FcmNotifier(this._repository, this._userId) : super(const FcmState()) {
    _tokenRefreshSubscription = FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      if (_userId == null) return;
      try {
        await _repository.sendTokenToBackend(_userId, newToken);
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _tokenRefreshSubscription?.cancel();
    super.dispose();
  }

  Future<void> requestAndRegister() async {
    if (state.status == FcmStatus.loading || state.status == FcmStatus.registered) return;

    state = state.copyWith(status: FcmStatus.loading);

    try {
      final authStatus = await _repository.requestPermission();

      if (authStatus != AuthorizationStatus.authorized &&
          authStatus != AuthorizationStatus.provisional) {
        state = state.copyWith(status: FcmStatus.permissionDenied);
        return;
      }

      if (_userId == null) {
        state = state.copyWith(
          status: FcmStatus.error,
          errorMessage: 'Usuari no autenticat',
        );
        return;
      }

      final token = await _repository.getToken();

      if (token == null) {
        state = state.copyWith(
          status: FcmStatus.error,
          errorMessage: 'No s\'ha pogut obtenir el token FCM',
        );
        return;
      }

      await _repository.sendTokenToBackend(_userId, token);
      state = state.copyWith(status: FcmStatus.registered);
    } catch (e) {
      state = state.copyWith(
        status: FcmStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}

final fcmProvider = StateNotifierProvider<FcmNotifier, FcmState>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  final repository = ref.read(fcmRepositoryProvider);
  return FcmNotifier(repository, userId);
});
