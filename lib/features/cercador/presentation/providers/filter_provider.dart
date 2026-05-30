import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterState {
  final String? dataInici;
  final String? dataFi;
  final bool? gratuit;
  final double? preuMax;
  final double? radiKm;
  final List<String> categories;
  final bool activarQualitatAire;
  final int? aqiMax;

  const FilterState({
    this.dataInici,
    this.dataFi,
    this.gratuit,
    this.preuMax,
    this.radiKm,
    this.categories = const [],
    this.activarQualitatAire = false,
    this.aqiMax,
  });

  bool get teFiltresActius =>
      dataInici != null ||
      dataFi != null ||
      gratuit != null ||
      preuMax != null ||
      radiKm != null ||
      categories.isNotEmpty ||
      activarQualitatAire;

  FilterState copyWith({
    String? dataInici,
    String? dataFi,
    bool? gratuit,
    double? preuMax,
    double? radiKm,
    List<String>? categories,
    bool? activarQualitatAire,
    int? aqiMax,
    bool clearDates = false,
    bool clearGratuit = false,
    bool clearPreuMax = false,
    bool clearRadiKm = false,
    bool clearAqiMax = false,
  }) {
    return FilterState(
      dataInici: clearDates ? null : dataInici ?? this.dataInici,
      dataFi: clearDates ? null : dataFi ?? this.dataFi,
      gratuit: clearGratuit ? null : gratuit ?? this.gratuit,
      preuMax: clearPreuMax ? null : preuMax ?? this.preuMax,
      radiKm: clearRadiKm ? null : radiKm ?? this.radiKm,
      categories: categories ?? this.categories,
      activarQualitatAire: activarQualitatAire ?? this.activarQualitatAire,
      aqiMax: clearAqiMax ? null : aqiMax ?? this.aqiMax,
    );
  }

  FilterState netejar() => const FilterState();
}

class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier() : super(const FilterState());

  void setDataInici(String? data) =>
      state = state.copyWith(dataInici: data, clearDates: false);

  void setDataFi(String? data) =>
      state = state.copyWith(dataFi: data);

  void setGratuit(bool? valor) =>
      state = state.copyWith(gratuit: valor, clearGratuit: valor == null);

  void setPreuMax(double? preu) =>
      state = state.copyWith(preuMax: preu, clearPreuMax: preu == null);

  void setRadiKm(double? radi) =>
      state = state.copyWith(radiKm: radi, clearRadiKm: radi == null);

  void setCategories(List<String> cats) =>
      state = state.copyWith(categories: cats);

  void setActivarQualitatAire(bool actiu) =>
      state = state.copyWith(activarQualitatAire: actiu);

  void setAqiMax(int? aqi) =>
      state = state.copyWith(aqiMax: aqi, clearAqiMax: aqi == null);

  void netejar() => state = const FilterState();
}

final filterProvider = StateNotifierProvider<FilterNotifier, FilterState>((ref) {
  return FilterNotifier();
});