import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:plan_c_frontend/features/activitats/model/activitat.dart';
import 'package:plan_c_frontend/features/activitats/presentation/provider/activitats_providers.dart';
import 'package:plan_c_frontend/features/activitats/presentation/screens/activitat_detail_screen.dart';
import 'package:plan_c_frontend/features/auth/presentation/main_auth_wrapper.dart';

/// Pantalla intermedia que se muestra cuando la app se abre desde un deep link
/// tipo `planc://activitats/<id>`. Resuelve el id contra el repositorio y
/// redirige a [ActivitatDetailScreen] si tiene éxito, o al [MainAuthWrapper]
/// en caso de error / id inválido.
class DeepLinkLoaderScreen extends ConsumerStatefulWidget {
  const DeepLinkLoaderScreen({required this.activitatId, super.key});

  final String activitatId;

  @override
  ConsumerState<DeepLinkLoaderScreen> createState() =>
      _DeepLinkLoaderScreenState();
}

class _DeepLinkLoaderScreenState extends ConsumerState<DeepLinkLoaderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _resolveAndNavigate());
  }

  Future<void> _resolveAndNavigate() async {
    final navigator = Navigator.of(context);

    if (widget.activitatId.trim().isEmpty) {
      debugPrint('🔗 DeepLink: id vacío, redirigiendo a Home');
      _goHome(navigator);
      return;
    }

    try {
      final repo = ref.read(activitatsRepositoryProvider);
      final Activitat activitat =
          await repo.getActivitatById(widget.activitatId);

      if (!mounted) return;

      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (_) => ActivitatDetailScreen(activitat: activitat),
        ),
      );
    } catch (e, st) {
      debugPrint('🔗 DeepLink: fallo al resolver actividad: $e\n$st');
      if (!mounted) return;
      _goHome(navigator);
    }
  }

  void _goHome(NavigatorState navigator) {
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainAuthWrapper()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Carregant activitat…',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
