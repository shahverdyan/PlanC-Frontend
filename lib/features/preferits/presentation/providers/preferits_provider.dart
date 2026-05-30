import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:plan_c_frontend/features/activitats/model/activitat.dart';
import 'package:plan_c_frontend/features/publicacions/domain/models/post_preview.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/preferits/data/preferits_remote_data_source.dart';
import 'package:plan_c_frontend/features/preferits/data/preferits_repository_impl.dart';
import 'package:plan_c_frontend/features/preferits/domain/preferits_repository.dart';

class PreferitsState {
  final List<Activitat> activitats;
  final List<PostPreview> publicacions;
  final String? publicacionsError;

  const PreferitsState({
    this.activitats = const [],
    this.publicacions = const [],
    this.publicacionsError,
  });
}

final preferitsRemoteDataSourceProvider = Provider<PreferitsRemoteDataSource>((ref) {
  return PreferitsRemoteDataSourceImpl(http.Client());
});

final preferitsRepositoryProvider = Provider<PreferitsRepository>((ref) {
  return PreferitsRepositoryImpl(ref.watch(preferitsRemoteDataSourceProvider));
});

final preferitsProvider =
    AsyncNotifierProvider<PreferitsNotifier, PreferitsState>(
  PreferitsNotifier.new,
);

class PreferitsNotifier extends AsyncNotifier<PreferitsState> {
  PreferitsRepository get _repository => ref.read(preferitsRepositoryProvider);

  @override
  Future<PreferitsState> build() async {

    final usuariId = ref.read(currentUserIdProvider);
    if (usuariId == null || usuariId.isEmpty) {
      return const PreferitsState();
    }

    final activitats = await _repository.getActivitatsGuardades(usuariId: usuariId);

    List<PostPreview> publicacions = [];
    String? publicacionsError;
    try {
      publicacions = await _repository.getPublicacionsGuardades(usuariId: usuariId);
    } catch (e) {
      publicacionsError = e.toString();
    }

    return PreferitsState(
      activitats: activitats,
      publicacions: publicacions,
      publicacionsError: publicacionsError,
    );
  }

  bool esPreferida(String activitatId) {
    final actuals = state.valueOrNull?.activitats ?? [];
    return actuals.any((a) => a.id == activitatId);
  }

  Future<void> refreshPreferits() async {
    final usuariId = ref.read(currentUserIdProvider);
    if (usuariId == null || usuariId.isEmpty) {
      state = const AsyncData(PreferitsState());
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final activitats = await _repository.getActivitatsGuardades(usuariId: usuariId);

      List<PostPreview> publicacions = [];
      String? publicacionsError;
      try {
        publicacions = await _repository.getPublicacionsGuardades(usuariId: usuariId);
      } catch (e) {
        publicacionsError = e.toString();
      }

      return PreferitsState(
        activitats: activitats,
        publicacions: publicacions,
        publicacionsError: publicacionsError,
      );
    });
  }

  Future<void> togglePreferida(Activitat activitat) async {
    final usuariId = ref.read(currentUserIdProvider);
    if (usuariId == null || usuariId.isEmpty) {
      throw Exception('No hi ha usuari autenticat');
    }

    final current = state.valueOrNull ?? const PreferitsState();
    final jaHiEs = current.activitats.any((a) => a.id == activitat.id);

    await AsyncValue.guard(() async {
      if (jaHiEs) {
        await _repository.desguardarActivitat(
          activitatId: activitat.id,
          usuariId: usuariId,
        );
      } else {
        await _repository.guardarActivitat(
          activitatId: activitat.id,
          usuariId: usuariId,
        );
      }
      final activitats =
          await _repository.getActivitatsGuardades(usuariId: usuariId);
      return PreferitsState(
        activitats: activitats,
        publicacions: current.publicacions,
      );
    }).then((value) {
      state = value;
    });
  }
}
