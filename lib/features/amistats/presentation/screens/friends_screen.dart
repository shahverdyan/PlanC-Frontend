import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/amistats/domain/models/amistat.dart';
import 'package:plan_c_frontend/features/amistats/presentation/providers/amistats_provider.dart';
import 'package:plan_c_frontend/features/perfil/presentation/profile_screen.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class FriendsScreen extends ConsumerWidget {
  final String usuariId;

  const FriendsScreen({
    super.key,
    required this.usuariId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final rebudesAsync = ref.watch(sollicitudsRebudesProvider(usuariId));
    final enviadesAsync = ref.watch(sollicitudsEnviadesProvider(usuariId));

    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      onRefresh: () async {
        ref.invalidate(sollicitudsRebudesProvider(usuariId));
        ref.invalidate(sollicitudsEnviadesProvider(usuariId));
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionTitle(t.friendsScreenSectionReceived),
          const SizedBox(height: 12),
          rebudesAsync.when(
            loading: () => const _SectionLoading(),
            error: (error, _) => _SectionError(
              message: error.toString().replaceFirst('Exception: ', ''),
              onRetry: () => ref.invalidate(sollicitudsRebudesProvider(usuariId)),
            ),
            data: (rebudes) {
              if (rebudes.isEmpty) {
                return _EmptySection(
                  message: t.friendsScreenNoReceived,
                );
              }
              return Column(
                children: rebudes
                    .map((solicitud) => _IncomingRequestCard(
                          solicitud: solicitud,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProfileScreen(profileUserId: solicitud.usuariId),
                            ),
                          ),
                          onAccept: () async {
                            await _executarAccio(
                              context,
                              ref,
                              () => ref.read(amistatsActionsProvider).acceptarSolicitud(
                                    usuariId: usuariId,
                                    altreUsuariId: solicitud.usuariId,
                                  ),
                              missatgeOk: t.friendsScreenAcceptedSuccess,
                            );
                          },
                          onReject: () async {
                            await _executarAccio(
                              context,
                              ref,
                              () => ref.read(amistatsActionsProvider).rebutjarSolicitud(
                                    usuariId: usuariId,
                                    altreUsuariId: solicitud.usuariId,
                                  ),
                              missatgeOk: t.friendsScreenRejectedSuccess,
                            );
                          },
                        ))
                    .toList(),
              );
            },
          ),

          const SizedBox(height: 24),
          _SectionTitle(t.friendsScreenSectionSent),
          const SizedBox(height: 12),
          enviadesAsync.when(
            loading: () => const _SectionLoading(),
            error: (error, _) => _SectionError(
              message: error.toString().replaceFirst('Exception: ', ''),
              onRetry: () => ref.invalidate(sollicitudsEnviadesProvider(usuariId)),
            ),
            data: (enviades) {
              if (enviades.isEmpty) {
                return _EmptySection(
                  message: t.friendsScreenNoSent,
                );
              }
              return Column(
                children: enviades
                    .map((solicitud) => _OutgoingRequestCard(
                          solicitud: solicitud,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProfileScreen(profileUserId: solicitud.usuariId),
                            ),
                          ),
                          onCancel: () async {
                            await _executarAccio(
                              context,
                              ref,
                              () => ref.read(amistatsActionsProvider).cancelarSolicitud(
                                    usuariId: usuariId,
                                    altreUsuariId: solicitud.usuariId,
                                  ),
                              missatgeOk: t.friendsScreenCanceledSuccess,
                            );
                          },
                        ))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  static Future<void> _executarAccio(
    BuildContext context,
    WidgetRef ref,
    Future<void> Function() action, {
    required String missatgeOk,
  }) async {
    try {
      await action();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(missatgeOk),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _SectionLoading extends StatelessWidget {
  const _SectionLoading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

class _SectionError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _SectionError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onRetry, child: Text(AppLocalizations.of(context)!.friendsScreenRetry)),
          ],
        ),
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  final String message;

  const _EmptySection({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          message,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14),
        ),
      ),
    );
  }
}

class _IncomingRequestCard extends StatelessWidget {
  final SolicitudAmistat solicitud;
  final VoidCallback onTap;
  final Future<void> Function() onAccept;
  final Future<void> Function() onReject;

  const _IncomingRequestCard({
    required this.solicitud,
    required this.onTap,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _Avatar(nom: solicitud.nomUsuari, foto: solicitud.fotoPerfil),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    solicitud.nomUsuari,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)!.friendsScreenWantsFriend,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(AppLocalizations.of(context)!.friendsScreenAcceptButton),
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: onReject,
                  child: Text(AppLocalizations.of(context)!.friendsScreenRejectButton),
                ),
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class _OutgoingRequestCard extends StatelessWidget {
  final SolicitudAmistat solicitud;
  final VoidCallback onTap;
  final Future<void> Function() onCancel;

  const _OutgoingRequestCard({
    required this.solicitud,
    required this.onTap,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _Avatar(nom: solicitud.nomUsuari, foto: solicitud.fotoPerfil),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      solicitud.nomUsuari,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t.friendsScreenPendingRequest,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: onCancel,
                child: Text(t.friendsScreenCancelButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String nom;
  final String? foto;

  const _Avatar({required this.nom, this.foto});

  @override
  Widget build(BuildContext context) {
    if (foto != null && foto!.isNotEmpty) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(foto!),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      );
    }

    final initial = nom.isNotEmpty ? nom[0].toUpperCase() : '?';
    return CircleAvatar(
      radius: 24,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: Text(
        initial,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}