import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plan_c_frontend/core/providers/dio_provider.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/publicacions/data/repositories/publicacio_repository.dart';
import 'package:plan_c_frontend/features/publicacions/domain/models/post.dart';

// --- Repositori ---

final publicacioRepositoryProvider = Provider<PublicacioRepository>((ref) {
  final usuariId = ref.watch(currentUserIdProvider);
  return PublicacioRepository(ref.watch(dioProvider), usuariId);
});

// --- Feed de publicacions ---

final publicacioFeedProvider = FutureProvider<List<Post>>((ref) {
  return ref.watch(publicacioRepositoryProvider).fetchFeed();
});

// --- Crear publicació ---

class CreatePublicacioState {
  final bool isLoading;
  final String? error;
  final bool success;

  const CreatePublicacioState({
    this.isLoading = false,
    this.error,
    this.success = false,
  });

  CreatePublicacioState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool? success,
  }) {
    return CreatePublicacioState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      success: success ?? this.success,
    );
  }
}

class CreatePublicacioNotifier extends StateNotifier<CreatePublicacioState> {
  final PublicacioRepository _repository;
  final Ref _ref;

  CreatePublicacioNotifier(this._repository, this._ref)
      : super(const CreatePublicacioState());

  Future<void> create({
    required String textDescripcio,
    required String activitatId,
    XFile? imatge,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.createPublicacio(
        textDescripcio: textDescripcio,
        activitatId: activitatId,
        imatge: imatge,
      );
      // Invalida el feed perquè es recarregui amb la nova publicació
      _ref.invalidate(publicacioFeedProvider);
      state = state.copyWith(isLoading: false, success: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void reset() => state = const CreatePublicacioState();
}

final createPublicacioProvider =
    StateNotifierProvider.autoDispose<CreatePublicacioNotifier, CreatePublicacioState>(
  (ref) => CreatePublicacioNotifier(
    ref.watch(publicacioRepositoryProvider),
    ref,
  ),
);
