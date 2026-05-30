import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/comentari.dart';
import 'interaccions_provider.dart';

final comentarisProvider =
    FutureProvider.family<List<Comentari>, String>((ref, publicacioId) async {
  return ref.watch(interaccionsRepositoryProvider).fetchComentaris(publicacioId);
});
