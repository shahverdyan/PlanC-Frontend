import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';

import '../providers/fcm_provider.dart';

class NotificacionsScreen extends ConsumerStatefulWidget {
  const NotificacionsScreen({super.key});

  @override
  ConsumerState<NotificacionsScreen> createState() => _NotificacionsScreenState();
}

class _NotificacionsScreenState extends ConsumerState<NotificacionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(fcmProvider.notifier).requestAndRegister();
    });
  }

  @override
  Widget build(BuildContext context) {
    final fcmState = ref.watch(fcmProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notificacions')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: switch (fcmState.status) {
            FcmStatus.idle || FcmStatus.loading => const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Configurant notificacions...'),
                ],
              ),
            FcmStatus.registered => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: AppSemanticColors.of(context).success, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    'Notificacions activades correctament',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            FcmStatus.permissionDenied => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications_off, color: Theme.of(context).colorScheme.primary, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    'Has denegat el permís de notificacions.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Per activar-les, ves a Configuració > Aplicacions > PlanC > Notificacions.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Força un nou intent ignorant la guarda "permissionDenied"
                      ref.invalidate(fcmProvider);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ref.read(fcmProvider.notifier).requestAndRegister();
                      });
                    },
                    child: const Text('Tornar a intentar'),
                  ),
                ],
              ),
            FcmStatus.error => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    fcmState.errorMessage ?? 'Error desconegut',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      ref.invalidate(fcmProvider);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ref.read(fcmProvider.notifier).requestAndRegister();
                      });
                    },
                    child: const Text('Tornar a intentar'),
                  ),
                ],
              ),
          },
        ),
      ),
    );
  }
}
