import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/core/providers/dio_provider.dart';
import 'package:plan_c_frontend/features/gustos/data/gustos_repository_impl.dart';
import 'package:plan_c_frontend/features/gustos/domain/repositories/gustos_repository.dart';

final gustosRepositoryProvider = Provider<GustosRepository>((ref) {
  return GustosRepositoryImpl(ref.watch(dioProvider));
});
