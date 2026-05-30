import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/core/interceptors/auth_interceptor.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/groups/data/repositories/group_repository_impl.dart';
import 'package:plan_c_frontend/features/groups/domain/models/group.dart';
import 'package:plan_c_frontend/features/groups/domain/repositories/group_repository.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://planc-backend-aff2.onrender.com/',
    contentType: 'application/json',
  ));

  dio.interceptors.add(AuthInterceptor(
    onSessionExpired: () async {
      await ref.read(authProvider.notifier).handleSessionExpired();
    },
  ));

  return dio;
});

final groupRepositoryProvider = Provider<GroupRepository>(
  (ref) => GroupRepositoryImpl(ref.watch(dioProvider)),
);

final groupByIdProvider = FutureProvider.autoDispose.family<Group, String>((ref, groupId) {
  return ref.read(groupRepositoryProvider).getGroupById(groupId);
});
