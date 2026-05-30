import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plan_c_frontend/core/providers/location_provider.dart';
import 'package:plan_c_frontend/features/activitats/presentation/provider/activitats_providers.dart';
import 'package:plan_c_frontend/features/groups/domain/models/assistent_quedada.dart';
import 'package:plan_c_frontend/features/groups/domain/models/group.dart';
import 'package:plan_c_frontend/features/groups/presentation/providers/assistents_quedada_provider.dart';
import 'package:plan_c_frontend/features/activitats/model/activitat.dart';
import 'package:plan_c_frontend/features/groups/presentation/screens/group_form_screen.dart';
import 'package:plan_c_frontend/features/groups/presentation/providers/join_group_provider.dart';
import 'package:plan_c_frontend/features/groups/presentation/providers/leave_group_provider.dart';
import 'package:plan_c_frontend/features/groups/presentation/providers/delete_group_provider.dart';
import 'package:plan_c_frontend/features/groups/presentation/providers/confirm_attendance_provider.dart';
import 'package:plan_c_frontend/features/groups/presentation/providers/unconfirm_attendance_provider.dart';
import 'package:plan_c_frontend/features/groups/presentation/providers/validate_attendance_provider.dart';
import 'package:plan_c_frontend/features/map/presentation/services/location_service.dart';
import 'package:plan_c_frontend/features/chat/presentation/providers/chat_list_provider.dart';
import 'package:plan_c_frontend/features/chat/presentation/screens/chat_room_screen.dart';
import 'package:plan_c_frontend/features/perfil/presentation/profile_screen.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class GroupCardWidget extends ConsumerStatefulWidget {
  final Group group;
  final Activitat activitat;
  final int currentParticipants;
  final String? currentUserId;
  final bool isCreator;
  final VoidCallback? onGroupUpdated;

  const GroupCardWidget({
    super.key,
    required this.group,
    required this.activitat,
    required this.currentParticipants,
    required this.currentUserId,
    this.isCreator = false,
    this.onGroupUpdated,
  });

  @override
  ConsumerState<GroupCardWidget> createState() => _GroupCardWidgetState();
}

class _GroupCardWidgetState extends ConsumerState<GroupCardWidget> {
  late AttendanceStatus _localStatus;
  late int _localParticipants;
  late int _localConfirmedParticipants;

  bool _isProcessing = false;
  bool _isDeleted = false;

  @override
  void initState() {
    super.initState();
    _localStatus = _computeStatus();
    _localParticipants = widget.currentParticipants;
    _localConfirmedParticipants = widget.group.confirmedParticipantIds.length;
    _loadPersistedValidation();
  }

  String _validationKey() =>
      'validated_quedada_${widget.group.id}_${widget.currentUserId}';

  Future<void> _loadPersistedValidation() async {
    if (widget.currentUserId == null) return;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_validationKey()) == true && mounted) {
      setState(() => _localStatus = AttendanceStatus.validated);
    }
  }

  Future<void> _persistValidation() async {
    if (widget.currentUserId == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_validationKey(), true);
  }

  Future<void> _navigateToGroupChat() async {
    await ref.read(chatListProvider.notifier).refreshChats();
    if (!mounted) return;
    final chats = ref.read(chatListProvider).valueOrNull ?? [];
    final matches = chats.where((c) => c.quedadaId == widget.group.id);
    if (matches.isNotEmpty && mounted) {
      final chat = matches.first;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ChatRoomScreen(chatName: chat.name, chatId: chat.id),
        ),
      );
    }
  }

  AttendanceStatus _computeStatus() {
    final userId = widget.currentUserId;
    if (userId == null) return AttendanceStatus.notJoined;
    return widget.group.attendanceStatusFor(userId);
  }

  @override
  void didUpdateWidget(covariant GroupCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentParticipants != widget.currentParticipants) {
      _localParticipants = widget.currentParticipants;
    }
    if (oldWidget.group.confirmedParticipantIds.length !=
        widget.group.confirmedParticipantIds.length) {
      _localConfirmedParticipants = widget.group.confirmedParticipantIds.length;
    }
    // Never downgrade from validated — backend reload may return stale state.
    if (_localStatus != AttendanceStatus.validated &&
        (oldWidget.group.participantIds.length != widget.group.participantIds.length ||
            oldWidget.group.confirmedParticipantIds.length !=
                widget.group.confirmedParticipantIds.length ||
            oldWidget.group.validatedParticipantIds.length !=
                widget.group.validatedParticipantIds.length)) {
      _localStatus = _computeStatus();
    }
  }

  Future<void> _confirmDelete() async {
    final t = AppLocalizations.of(context)!;
    if (widget.currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.groupCardNoUserError), backgroundColor: Theme.of(context).colorScheme.error),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.groupCardDeleteDialogTitle),
        content: Text(t.groupCardDeleteDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.groupCardDeleteBack, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              t.groupCardDeleteConfirm,
              style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isProcessing = true);
      ref.read(deleteGroupProvider.notifier).deleteGroup(
        groupId: widget.group.id,
        userId: widget.currentUserId!,
      );
    }
  }

  Future<void> _confirmLeave() async {
    final t = AppLocalizations.of(context)!;
    if (widget.currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.groupCardNoUserError), backgroundColor: Theme.of(context).colorScheme.error),
      );
      return;
    }

    if (widget.isCreator) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.groupCardCreatorCannotLeave),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.groupCardLeaveDialogTitle),
        content: Text(t.groupCardLeaveDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.groupCardLeaveCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.groupCardLeaveConfirm),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isProcessing = true);
      ref.read(leaveGroupProvider.notifier).leaveGroup(
        groupId: widget.group.id,
        userId: widget.currentUserId!,
      );
    }
  }

  Future<void> _confirmAttendance() async {
    final t = AppLocalizations.of(context)!;
    if (widget.currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.groupCardNoUserError), backgroundColor: Theme.of(context).colorScheme.error),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.groupCardConfirmAttendanceTitle),
        content: Text(t.groupCardConfirmAttendanceContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.groupCardConfirmAttendanceCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.groupCardConfirmAttendanceConfirm),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isProcessing = true);
      ref.read(confirmAttendanceProvider.notifier).confirmAttendance(
        groupId: widget.group.id,
        userId: widget.currentUserId!,
      );
    }
  }

  Future<void> _unconfirmAttendance() async {
    final t = AppLocalizations.of(context)!;
    if (widget.currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.groupCardNoUserError), backgroundColor: Theme.of(context).colorScheme.error),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.groupCardUnconfirmAttendanceTitle),
        content: Text(t.groupCardUnconfirmAttendanceContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.groupCardUnconfirmAttendanceCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              t.groupCardUnconfirmAttendanceConfirm,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isProcessing = true);
      ref.read(unconfirmAttendanceProvider.notifier).unconfirmAttendance(
        groupId: widget.group.id,
        userId: widget.currentUserId!,
      );
    }
  }

  Future<void> _validateAttendance() async {
    final t = AppLocalizations.of(context)!;
    if (widget.currentUserId == null) return;

    final now = DateTime.now();
    final d = widget.group.dateTime;
    final f = widget.activitat.dataFi;
    final trobada = DateTime(d.year, d.month, d.day, d.hour, d.minute);
    final fi = DateTime(f.year, f.month, f.day, f.hour, f.minute);
    final windowStart = trobada.subtract(const Duration(minutes: 30));
    final isInWindow = now.isAfter(windowStart) && now.isBefore(fi);

    if (!isInWindow) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.validateAttendanceOutsideWindow),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
      return;
    }

    final locationService = ref.read(locationServiceProvider);
    final result = await locationService.obtenirUbicacioActual();

    if (!mounted) return;

    if (result.estat != EstatPermisUbicacio.concedit) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.validateAttendanceLocationRequired)),
      );
      return;
    }

    ref.read(validateAttendanceProvider(widget.group.id).notifier).validate(
      quedadaId: widget.group.id,
      usuariId: widget.currentUserId!,
      latitud: result.position!.latitude,
      longitud: result.position!.longitude,
    );
  }

  Future<void> _goToEditScreen() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GroupFormScreen(
          activityId: widget.group.activityId,
          activitat: widget.activitat,
          groupToEdit: widget.group,
        ),
      ),
    );
    if (result == true) widget.onGroupUpdated?.call();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    if (_isDeleted) return const SizedBox.shrink();

    ref.listen(deleteGroupProvider, (prev, next) {
      next.when(
        data: (_) {
          if (prev is AsyncLoading && _isProcessing) {
            setState(() {
              _isProcessing = false;
              _isDeleted = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(t.groupCardGroupDeleted)),
            );
            ref.invalidate(chatListProvider);
            widget.onGroupUpdated?.call();
          }
        },
        error: (err, _) {
          if (_isProcessing) setState(() => _isProcessing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(err.toString())),
          );
        },
        loading: () {},
      );
    });

    ref.listen(joinGroupProvider, (prev, next) {
      next.when(
        data: (_) {
          if (prev is AsyncLoading && _isProcessing) {
            setState(() {
              _localStatus = AttendanceStatus.joined;
              _localParticipants++;
              _isProcessing = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(t.groupCardJoinedSuccess)),
            );
            widget.onGroupUpdated?.call();
            _navigateToGroupChat();
          }
        },
        error: (err, _) {
          if (_isProcessing) setState(() => _isProcessing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(err.toString())),
          );
        },
        loading: () {},
      );
    });

    ref.listen(leaveGroupProvider, (prev, next) {
      next.when(
        data: (_) {
          if (prev is AsyncLoading && _isProcessing) {
            final wasConfirmed = _localStatus == AttendanceStatus.confirmed ||
                _localStatus == AttendanceStatus.validated;
            setState(() {
              if (wasConfirmed) {
                _localConfirmedParticipants =
                    (_localConfirmedParticipants > 0) ? _localConfirmedParticipants - 1 : 0;
              }
              _localStatus = AttendanceStatus.notJoined;
              _localParticipants = (_localParticipants > 0) ? _localParticipants - 1 : 0;
              _isProcessing = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(t.groupCardLeftSuccess)),
            );
            ref.invalidate(chatListProvider);
            widget.onGroupUpdated?.call();
          }
        },
        error: (err, _) {
          if (_isProcessing) setState(() => _isProcessing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(err.toString())),
          );
        },
        loading: () {},
      );
    });

    ref.listen(confirmAttendanceProvider, (prev, next) {
      next.when(
        data: (_) {
          if (prev is AsyncLoading && _isProcessing) {
            setState(() {
              _localStatus = AttendanceStatus.confirmed;
              _localConfirmedParticipants++;
              _isProcessing = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(t.groupCardAttendanceConfirmed)),
            );
            widget.onGroupUpdated?.call();
          }
        },
        error: (err, _) {
          if (_isProcessing) setState(() => _isProcessing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(err.toString())),
          );
          widget.onGroupUpdated?.call();
        },
        loading: () {},
      );
    });

    ref.listen(unconfirmAttendanceProvider, (prev, next) {
      next.when(
        data: (_) {
          if (prev is AsyncLoading && _isProcessing) {
            setState(() {
              _localStatus = AttendanceStatus.joined;
              _localConfirmedParticipants =
                  (_localConfirmedParticipants > 0) ? _localConfirmedParticipants - 1 : 0;
              _isProcessing = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(t.groupCardAttendanceUnconfirmed)),
            );
            widget.onGroupUpdated?.call();
          }
        },
        error: (err, _) {
          if (_isProcessing) setState(() => _isProcessing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(err.toString())),
          );
        },
        loading: () {},
      );
    });

    ref.listen(validateAttendanceProvider(widget.group.id), (prev, next) {
      if (prev?.status == ValidateAttendanceStatus.loading &&
          next.status == ValidateAttendanceStatus.validated) {
        setState(() => _localStatus = AttendanceStatus.validated);
        _persistValidation();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.validateAttendanceValidatedSnackbar),
            backgroundColor: AppSemanticColors.of(context).success,
          ),
        );
        widget.onGroupUpdated?.call();
      }
    });

    final validateState = ref.watch(validateAttendanceProvider(widget.group.id));
    final bool isFull = _localConfirmedParticipants >= widget.group.maxParticipants;

    // IDs dels amics de l'usuari que assisteixen a l'activitat (per a la distinció visual).
    final amicsAsync = ref.watch(amicsAssistentsProvider(widget.group.activityId));
    final amicsIds = amicsAsync.hasValue
        ? amicsAsync.value!.map((a) => a.id).toSet()
        : <String>{};

    // Tots els assistents d'aquesta quedada concreta (amb nom i foto).
    final assistentsAsync =
        ref.watch(assistentsPerActivitatProvider(widget.group.activityId));
    final assistentsQuedada = assistentsAsync.hasValue
        ? (assistentsAsync.value![widget.group.id] ?? [])
        : <AssistentQuedadaModel>[];

    // Sincronitza _localStatus des del provider (que SÍ inclou `estat`).
    // Cobreix reinstal·lacions on SharedPreferences s'esborra i l'objecte
    // Group parsejat des de l'endpoint de llistat no conté `estat`.
    if (_localStatus != AttendanceStatus.validated &&
        widget.currentUserId != null &&
        assistentsQuedada.isNotEmpty) {
      final userAssistent = assistentsQuedada
          .where((a) => a.id == widget.currentUserId)
          .firstOrNull;
      if (userAssistent != null) {
        if (userAssistent.esValidat) {
          _localStatus = AttendanceStatus.validated;
          _persistValidation();
        } else if (userAssistent.esConfirmat &&
            _localStatus == AttendanceStatus.joined) {
          _localStatus = AttendanceStatus.confirmed;
        }
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 4,
      shadowColor: const Color(0x14000000),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.group.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      if (widget.group.creatorNomUsuari != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          '@${widget.group.creatorNomUsuari}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.isCreator) ...[
                  IconButton(
                    icon: Icon(Icons.edit_outlined, color: Theme.of(context).colorScheme.primary),
                    onPressed: _isProcessing ? null : _goToEditScreen,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                    onPressed: _isProcessing ? null : _confirmDelete,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            if (widget.group.description.isNotEmpty) ...[
              Text(
                widget.group.description,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 10),
            ],
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  DateFormat('dd MMM yyyy, HH:mm').format(widget.group.dateTime.toLocal()),
                  style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        t.groupCardJoinedCount(
                            _localParticipants, widget.group.maxParticipants),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t.groupCardConfirmedCount(
                            _localConfirmedParticipants,
                            widget.group.maxParticipants),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _localConfirmedParticipants >=
                                  widget.group.maxParticipants
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                if (assistentsQuedada.isNotEmpty) ...[
                  const SizedBox(width: 10),
                  _AssistentsPill(
                    assistents: assistentsQuedada,
                    amicsIds: amicsIds,
                    group: widget.group,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            _buildActions(isFull, validateState),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(bool isFull, ValidateAttendanceState validateState) {
    final t = AppLocalizations.of(context)!;
    final sem = AppSemanticColors.of(context);
    final orange = Theme.of(context).colorScheme.primary;
    const buttonShape =
        RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)));

    if (_isProcessing) {
      return Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: orange),
        ),
      );
    }

    switch (_localStatus) {
      case AttendanceStatus.notJoined:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (isFull || widget.currentUserId == null)
                ? null
                : () {
                    setState(() => _isProcessing = true);
                    ref.read(joinGroupProvider.notifier).joinGroup(
                      group: widget.group,
                      currentParticipants: _localParticipants,
                      userId: widget.currentUserId!,
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: orange,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: buttonShape,
            ),
            child: Text(isFull ? t.groupCardFullButton : t.groupCardJoinButton),
          ),
        );

      case AttendanceStatus.joined:
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _confirmLeave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: sem.destructiveSurface,
                  foregroundColor: sem.destructive,
                  elevation: 0,
                  side: BorderSide(color: sem.destructive.withValues(alpha: 0.3)),
                  shape: buttonShape,
                ),
                child: Text(t.groupCardLeaveButton, textAlign: TextAlign.center),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _confirmAttendance,
                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: buttonShape,
                ),
                child: Text(t.groupCardConfirmButton, textAlign: TextAlign.center),
              ),
            ),
          ],
        );

      case AttendanceStatus.confirmed:
        final isValidating = validateState.status == ValidateAttendanceStatus.loading;

        String? errorMessage;
        if (validateState.status == ValidateAttendanceStatus.error) {
          final rawError = validateState.errorMessage ?? '';
          final error = rawError.replaceFirst('Exception: ', '');
          final isTooFar =
              error.startsWith('distance:') || error.toLowerCase().contains('lluny');
          if (isTooFar) {
            errorMessage = error.startsWith('distance:')
                ? t.validateAttendanceTooFarKnown(error.substring('distance:'.length))
                : t.validateAttendanceTooFar;
          } else {
            errorMessage = error.isNotEmpty ? error : t.validateAttendanceGenericError;
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isValidating ? null : _unconfirmAttendance,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: sem.destructiveSurface,
                      foregroundColor: sem.destructive,
                      elevation: 0,
                      side: BorderSide(color: sem.destructive.withValues(alpha: 0.3)),
                      shape: buttonShape,
                    ),
                    child: Text(t.groupCardUnconfirmButton, textAlign: TextAlign.center),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isValidating ? null : _validateAttendance,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orange,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      disabledBackgroundColor: orange,
                      disabledForegroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: buttonShape,
                    ),
                    child: isValidating
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )
                        : Text(t.validateAttendanceButton, textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                errorMessage,
                style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.w600),
              ),
            ],
          ],
        );

      case AttendanceStatus.validated:
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: sem.successSurface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: sem.success.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified, color: sem.success),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  t.groupCardValidatedText,
                  style: TextStyle(
                    color: sem.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }
}

// ─── Pill compacta ──────────────────────────────────────────────────────────

class _AssistentsPill extends StatelessWidget {
  const _AssistentsPill({
    required this.assistents,
    required this.amicsIds,
    required this.group,
  });

  static const int _maxVisible = 3;
  static const double _avatarR = 26;
  static const double _stride = 36;

  final List<AssistentQuedadaModel> assistents;
  final Set<String> amicsIds;
  final Group group;

  void _obrirModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _AssistentsModal(
        assistents: assistents,
        amicsIds: amicsIds,
        group: group,
      ),
    );
  }

  // El creador sempre ocupa l'últim lloc (més a la dreta) del stack.
  List<AssistentQuedadaModel> _buildVisible() {
    final creator = assistents.where((a) => a.esCreador).firstOrNull;
    final others = assistents.where((a) => !a.esCreador).toList();

    if (creator == null) return others.take(_maxVisible).toList();
    // El creador ocupa el primer slot (més a l'esquerra).
    final slots = others.take(_maxVisible - 1).toList();
    return [creator, ...slots];
  }

  @override
  Widget build(BuildContext context) {
    final visible = _buildVisible();
    final restants = assistents.length - visible.length;
    final stackW = visible.length > 1
        ? _stride * (visible.length - 1) + _avatarR * 2
        : _avatarR * 2;

    return GestureDetector(
      onTap: () => _obrirModal(context),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: stackW,
            height: _avatarR * 2,
            child: Stack(
              children: [
                for (int i = 0; i < visible.length; i++)
                  Positioned(
                    left: i * _stride,
                    child: _AvatarMini(
                      assistent: visible[i],
                      isAmic: amicsIds.contains(visible[i].id),
                      index: i,
                    ),
                  ),
              ],
            ),
          ),
          if (restants > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+$restants',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AvatarMini extends StatefulWidget {
  const _AvatarMini({
    required this.assistent,
    required this.isAmic,
    required this.index,
  });

  static const double _r = _AssistentsPill._avatarR;

  final AssistentQuedadaModel assistent;
  final bool isAmic;
  final int index;

  @override
  State<_AvatarMini> createState() => _AvatarMiniState();
}

class _AvatarMiniState extends State<_AvatarMini>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    Future.delayed(Duration(milliseconds: widget.index * 60), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _borderColor(BuildContext context) {
    if (widget.assistent.esCreador) return Colors.amber.shade600;
    if (widget.assistent.esValidat) return Colors.green.shade600;
    if (widget.assistent.esConfirmat) return Colors.green.shade400;
    return Theme.of(context).colorScheme.outlineVariant;
  }

  @override
  Widget build(BuildContext context) {
    const r = _AvatarMini._r;
    final inicials = widget.assistent.nomUsuari.isNotEmpty
        ? widget.assistent.nomUsuari[0].toUpperCase()
        : '?';
    final surface = Theme.of(context).colorScheme.surface;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: r * 2,
              height: r * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: surface, width: 1.5),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _borderColor(context), width: 2),
                ),
                child: CircleAvatar(
                  radius: r - 3.5,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  backgroundImage: widget.assistent.fotoPerfil != null
                      ? NetworkImage(widget.assistent.fotoPerfil!)
                      : null,
                  child: widget.assistent.fotoPerfil == null
                      ? Text(
                          inicials,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        )
                      : null,
                ),
              ),
            ),
            if (widget.assistent.esCreador)
              Positioned(
                top: -1,
                left: -1,
                child: _Badge(
                  icon: Icons.star_rounded,
                  color: Colors.amber.shade700,
                ),
              ),
            if (widget.isAmic)
              Positioned(
                bottom: 2,
                left: 2,
                child: _Badge(
                  icon: Icons.people_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.surface,
          width: 1,
        ),
      ),
      child: Icon(icon, size: 8, color: Colors.white),
    );
  }
}

// ─── Modal complet ───────────────────────────────────────────────────────────

class _AssistentsModal extends StatelessWidget {
  const _AssistentsModal({
    required this.assistents,
    required this.amicsIds,
    required this.group,
  });

  final List<AssistentQuedadaModel> assistents;
  final Set<String> amicsIds;
  final Group group;

  @override
  Widget build(BuildContext context) {
    // Ordre: creador primer, després validats, confirmats, apuntats.
    final ordenats = [...assistents]..sort((a, b) {
        int rang(AssistentQuedadaModel x) {
          if (x.esCreador) return 0;
          if (x.esValidat) return 1;
          if (x.esConfirmat) return 2;
          return 3;
        }

        return rang(a).compareTo(rang(b));
      });

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      minChildSize: 0.35,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.nombreAssistents(assistents.length),
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: ordenats.length,
                itemBuilder: (context, index) => _AssistentTile(
                  assistent: ordenats[index],
                  isAmic: amicsIds.contains(ordenats[index].id),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AssistentTile extends StatelessWidget {
  const _AssistentTile({required this.assistent, required this.isAmic});

  final AssistentQuedadaModel assistent;
  final bool isAmic;

  Color _borderColor(BuildContext context) {
    if (assistent.esCreador) return Colors.amber.shade600;
    if (assistent.esValidat) return Colors.green.shade600;
    if (assistent.esConfirmat) return Colors.green.shade400;
    return Theme.of(context).colorScheme.outlineVariant;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final inicials =
        assistent.nomUsuari.isNotEmpty ? assistent.nomUsuari[0].toUpperCase() : '?';

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => ProfileScreen(profileUserId: assistent.id),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _borderColor(context), width: 2.5),
                  ),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: colorScheme.primaryContainer,
                    backgroundImage: assistent.fotoPerfil != null
                        ? NetworkImage(assistent.fotoPerfil!)
                        : null,
                    child: assistent.fotoPerfil == null
                        ? Text(
                            inicials,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          )
                        : null,
                  ),
                ),
                if (assistent.esCreador)
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: _Badge(
                      icon: Icons.star_rounded,
                      color: Colors.amber.shade700,
                    ),
                  ),
                if (isAmic)
                  Positioned(
                    bottom: 1,
                    left: 1,
                    child: _Badge(
                      icon: Icons.people_rounded,
                      color: colorScheme.primary,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    assistent.nomUsuari,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  _EstatLabel(assistent: assistent, isAmic: isAmic),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EstatLabel extends StatelessWidget {
  const _EstatLabel({required this.assistent, required this.isAmic});

  final AssistentQuedadaModel assistent;
  final bool isAmic;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final parts = <String>[];
    if (assistent.esCreador) {
      parts.add(t.estatCreador);
    } else if (assistent.esValidat) {
      parts.add(t.estatValidat);
    } else if (assistent.esConfirmat) {
      parts.add(t.calendariEstatConfirmat);
    } else {
      parts.add(t.estatApuntat);
    }
    if (isAmic) parts.add(t.estatAmic);

    final Color baseColor;
    if (assistent.esCreador) {
      baseColor = Colors.amber.shade700;
    } else if (assistent.esValidat || assistent.esConfirmat) {
      baseColor = Colors.green.shade600;
    } else {
      baseColor = Theme.of(context).colorScheme.onSurfaceVariant;
    }

    return Text(
      parts.join(' · '),
      style: TextStyle(
        fontSize: 12,
        color: baseColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
