import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/core/providers/dio_provider.dart';
import 'package:plan_c_frontend/features/publicacions/data/post_repository_impl.dart';
import 'package:plan_c_frontend/features/publicacions/domain/repositories/post_respository.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) {
  // Leemos tu dioProvider global idéntico a como haces con el perfil
  final dioClient = ref.watch(dioProvider); 
  return PostRepositoryImpl(dioClient);
});