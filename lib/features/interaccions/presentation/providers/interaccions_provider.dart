import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/dio_provider.dart';
import '../../data/repositories/interaccions_repository_impl.dart';
import '../../../publicacions/domain/models/publicacio_detall.dart';
import '../../../auth/domain/auth_provider.dart';
import '../../../preferits/presentation/providers/preferits_provider.dart';
import '../../domain/models/comentari.dart';
import '../../domain/models/usuari_like.dart';

// --- Repositori ---

final interaccionsRepositoryProvider = Provider<InteraccionsRepositoryImpl>((ref) {
  final usuariId = ref.watch(currentUserIdProvider);
  return InteraccionsRepositoryImpl(ref.watch(dioProvider), usuariId);
});

// --- Detall de publicació ---

final publicacioDetallProvider =
    FutureProvider.family<PublicacioDetall, String>((ref, publicacioId) {
  return ref.watch(interaccionsRepositoryProvider).fetchPublicacioDetall(publicacioId);
});

// --- Enviar Comentari ---

// Comentari al qual s'està responent (null = comentari nou de primer nivell).
// Escopat per publicacioId per suportar múltiples posts oberts.
final replyTargetProvider = StateProvider.family<Comentari?, String>((ref, _) => null);

class EnviarComentariNotifier extends StateNotifier<AsyncValue<void>> {
  final InteraccionsRepositoryImpl _repository;

  EnviarComentariNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> enviar(
    String publicacioId,
    String text, {
    String? comentariPareId,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.enviarComentari(
        publicacioId,
        text,
        comentariPareId: comentariPareId,
      );
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final enviarComentariProvider =
    StateNotifierProvider<EnviarComentariNotifier, AsyncValue<void>>((ref) {
  return EnviarComentariNotifier(ref.watch(interaccionsRepositoryProvider));
});

// --- Me Gusta (Like) ---
// El notifier s'inicialitza amb valors per defecte i accepta initialize()
// quan la publicació es carrega des del backend.

class LikeState {
  final bool isLiked;
  final int likesCount;
  final bool initialized;
  final String? error;

  const LikeState({
    required this.isLiked,
    required this.likesCount,
    this.initialized = false,
    this.error,
  });

  LikeState copyWith({
    bool? isLiked,
    int? likesCount,
    bool? initialized,
    String? error,
    bool clearError = false,
  }) {
    return LikeState(
      isLiked: isLiked ?? this.isLiked,
      likesCount: likesCount ?? this.likesCount,
      initialized: initialized ?? this.initialized,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class LikePostNotifier extends StateNotifier<LikeState> {
  final InteraccionsRepositoryImpl _repository;
  final String _publicacioId;

  LikePostNotifier(this._repository, this._publicacioId)
      : super(const LikeState(isLiked: false, likesCount: 0));

  /// Inicialització suau: només s'aplica una vegada (ús: targeta del feed).
  /// Evita sobreescriure actualitzacions optimistes en curs.
  void initialize(int likesCount, bool isLiked) {
    if (state.initialized) return;
    state = state.copyWith(
      likesCount: likesCount,
      isLiked: isLiked,
      initialized: true,
    );
  }

  /// Sincronització forçada des del backend (ús: pantalla de detall del post).
  /// El detall és la font de veritat: sempre sobreescriu, fins i tot si el feed
  /// ja havia inicialitzat l'estat amb un valor incorrecte d'isLikedByMe.
  void syncFromBackend(int likesCount, bool isLiked) {
    // Preservem una actualització optimista en curs: si l'usuari acaba de
    // fer toggle i la crida API encara no ha acabat, no revertim el comptador.
    if (state.initialized && state.likesCount != likesCount) return;
    state = state.copyWith(
      likesCount: likesCount,
      isLiked: isLiked,
      initialized: true,
    );
  }

  Future<void> toggle() async {
    final previous = state;
    state = state.copyWith(
      isLiked: !state.isLiked,
      likesCount: state.isLiked ? state.likesCount - 1 : state.likesCount + 1,
      clearError: true,
    );
    try {
      await _repository.toggleMeGusta(_publicacioId);
    } catch (e) {
      state = previous.copyWith(error: e.toString());
    }
  }

  void clearError() => state = state.copyWith(clearError: true);
}

final likePostProvider =
    StateNotifierProvider.family<LikePostNotifier, LikeState, String>(
  (ref, publicacioId) => LikePostNotifier(
    ref.watch(interaccionsRepositoryProvider),
    publicacioId,
  ),
);

// --- Guardar publicació ---

class BookmarkState {
  final bool isGuardat;
  final bool initialized;
  final String? error;

  const BookmarkState({
    required this.isGuardat,
    this.initialized = false,
    this.error,
  });

  BookmarkState copyWith({
    bool? isGuardat,
    bool? initialized,
    String? error,
    bool clearError = false,
  }) {
    return BookmarkState(
      isGuardat: isGuardat ?? this.isGuardat,
      initialized: initialized ?? this.initialized,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class BookmarkPostNotifier extends StateNotifier<BookmarkState> {
  final InteraccionsRepositoryImpl _repository;
  final String _publicacioId;
  final Ref _ref;

  BookmarkPostNotifier(this._repository, this._publicacioId, this._ref)
      : super(const BookmarkState(isGuardat: false));

  void initialize(bool isGuardat) {
    if (state.initialized) return;
    state = state.copyWith(isGuardat: isGuardat, initialized: true);
  }

  Future<void> fetchGuardada() async {
    try {
      final guardada = await _repository.checkPublicacioGuardada(_publicacioId);
      state = state.copyWith(isGuardat: guardada, initialized: true);
    } catch (_) {
      // Si falla, mantenim l'estat actual sense bloquejar la UI
    }
  }

  Future<void> toggle() async {
    try {
      final guardada = await _repository.toggleGuardarPublicacio(_publicacioId);
      state = state.copyWith(isGuardat: guardada, clearError: true);
      _ref.invalidate(preferitsProvider);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearError() => state = state.copyWith(clearError: true);
}

final bookmarkPostProvider =
    StateNotifierProvider.family<BookmarkPostNotifier, BookmarkState, String>(
  (ref, publicacioId) => BookmarkPostNotifier(
    ref.watch(interaccionsRepositoryProvider),
    publicacioId,
    ref,
  ),
);

// --- Delta de comentaris afegits localment ---
// Suma al commentsCount real del backend. Evita problemes d'inicialització.

final comentarisAdicionalsProvider =
    StateProvider.family<int, String>((ref, _) => 0);

// --- Llista d'usuaris que han donat m'agrada ---

final meGustaListProvider =
    FutureProvider.family.autoDispose<List<UsuariLike>, String>(
  (ref, publicacioId) =>
      ref.watch(interaccionsRepositoryProvider).fetchMeGustaList(publicacioId),
);

