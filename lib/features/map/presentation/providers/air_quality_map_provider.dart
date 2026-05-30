import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../cercador/domain/entities/search_result.dart';
import '../../../cercador/domain/usecases/cerca_qualitat_aire_usecase.dart';
import '../../../cercador/presentation/providers/search_provider.dart';

class AirQualityMapState {
  final bool isActive;
  final bool isLoading;
  final List<AirQualityStation> estacions;
  final String? error;

  const AirQualityMapState({
    this.isActive = false,
    this.isLoading = false,
    this.estacions = const [],
    this.error,
  });

  AirQualityMapState copyWith({
    bool? isActive,
    bool? isLoading,
    List<AirQualityStation>? estacions,
    String? error,
    bool clearError = false,
  }) {
    return AirQualityMapState(
      isActive: isActive ?? this.isActive,
      isLoading: isLoading ?? this.isLoading,
      estacions: estacions ?? this.estacions,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AirQualityMapNotifier extends StateNotifier<AirQualityMapState> {
  final CercaQualitatAireUsecase _usecase;

  AirQualityMapNotifier(this._usecase) : super(const AirQualityMapState());

  Future<void> carregarQualitatAire({
    required double lat,
    required double lng,
    double? radi,
  }) async {
    state = state.copyWith(isActive: true, isLoading: true, clearError: true);
    try {
      final result = await _usecase(lat: lat, lng: lng, radi: radi);
      state = state.copyWith(
        isLoading: false,
        estacions: result.estacions,
      );
    } catch (e) {
      final msg = e.toString();
      state = state.copyWith(
        isLoading: false,
        error: msg.contains('timeout')
            ? 'El servidor triga massa. Torna-ho a provar.'
            : 'No s\'han pogut obtenir les estacions de mesura.',
      );
    }
  }

  void desactivar() => state = const AirQualityMapState();
}

final airQualityMapProvider =
    StateNotifierProvider<AirQualityMapNotifier, AirQualityMapState>((ref) {
  return AirQualityMapNotifier(ref.watch(cercaQualitatAireUsecaseProvider));
});
