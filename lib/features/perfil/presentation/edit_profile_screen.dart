import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/perfil/presentation/edit_profile_field_screen.dart';
import 'package:plan_c_frontend/features/perfil/presentation/providers/profile_provider.dart';
import 'package:plan_c_frontend/shared/error_screen.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String userId;
  final bool isOwnProfile;

  const EditProfileScreen({super.key, required this.userId, required this.isOwnProfile});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();

}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
    bool isUploading = false; 

    Future<void> _handleImageUpload(WidgetRef ref, String userId) async {
      final picker = ImagePicker();
      
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50, 
      );

      if (image == null) return;

      setState(() => isUploading = true);

      try {
        await ref.read(profileRepositoryProvider).updateProfilePicture(
          userId: userId,
          imageFile: File(image.path),
        );

        ref.invalidate(profileByIdProvider(userId));

        if (mounted) {
          final t = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(t.editProfileImageUpdated),
              backgroundColor: AppSemanticColors.of(context).success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          final t = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(t.editProfileImageError(e.toString())),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => isUploading = false);
        }
      }
    }

    Widget _buildFieldRow (String label, String text) {
    return (
      Padding(
        padding: const EdgeInsetsGeometry.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
            ), 
            const SizedBox(width: 16),
            Expanded(
              child: (text.isNotEmpty) ? 
                Text(text, softWrap: true,) : 
                Text (label, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),)
            )
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final user = ref.watch(authProvider);
    final profileAsync = ref.watch(profileByIdProvider(widget.userId));

    return Scaffold (
      appBar: AppBar(
        title: Text(t.editProfileTitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
        centerTitle: true,
        leading: BackButton(),
      ),
      body: SafeArea(
        child: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => ErrorScreen(error: err.toString()), 
          data: (profile) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () => _handleImageUpload(ref, widget.userId),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                            backgroundImage: (profile.profilePictureUrl != null && profile.profilePictureUrl!.isNotEmpty)
                                ? NetworkImage(profile.profilePictureUrl!)
                                : null,
                            child: isUploading
                                ? const CircularProgressIndicator()
                                : (profile.profilePictureUrl == null || profile.profilePictureUrl!.isEmpty)
                                    ? Icon(Icons.person, size: 50, color: Theme.of(context).colorScheme.onSurfaceVariant)
                                    : null,
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(Icons.edit, size: 16, color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // avatar picker
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (_) => EditProfileFieldScreen(label: t.editProfileNameLabel,
                      actualValue: profile.name,
                      onSave: (value) async {
                        final userId = user.userId!;
                        debugPrint('[onSave name] value: $value, userId: $userId');
                        try {
                          await ref.read(profileRepositoryProvider).updateProfile(name: value, userId: userId);
                          debugPrint('[onSave name] updateProfile OK');
                          ref.invalidate(profileByIdProvider(userId));
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          debugPrint('[onSave name] ERROR: $e');
                        }
                      },
                      ),));
                    },
                    child: _buildFieldRow(t.editProfileNameLabel, profile.name)),
                  Divider(color: Theme.of(context).colorScheme.outline),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (_) => EditProfileFieldScreen(label: t.editProfileSurnameLabel,
                      actualValue: profile.surname ,
                      onSave: (value) async {
                        final userId = user.userId!;
                        debugPrint('[onSave surname] value: $value, userId: $userId');
                        try {
                          await ref.read(profileRepositoryProvider).updateProfile(surname: value, userId: userId);
                          debugPrint('[onSave surname] updateProfile OK');
                          ref.invalidate(profileByIdProvider(userId));
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          debugPrint('[onSave surname] ERROR: $e');
                        }
                      },
                      ),));
                    },
                    child: _buildFieldRow(t.editProfileSurnameLabel, profile.surname)),
                  Divider(color: Theme.of(context).colorScheme.outline),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (_) => EditProfileFieldScreen(label: t.editProfileUsernameLabel,
                      actualValue: profile.username ,
                      onSave: (value) async {
                        final userId = user.userId!;
                        debugPrint('[onSave username] value: $value, userId: $userId');
                        try {
                          await ref.read(profileRepositoryProvider).updateProfile(username: value, userId: userId);
                          debugPrint('[onSave username] updateProfile OK');
                          ref.invalidate(profileByIdProvider(userId));
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          debugPrint('[onSave username] ERROR: $e');
                        }
                      },
                      ),));
                    },
                    child: _buildFieldRow(t.editProfileUsernameLabel, profile.username)),
                  Divider(color: Theme.of(context).colorScheme.outline),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (_) => EditProfileFieldScreen(label: t.editProfileDescriptionLabel, actualValue: profile.description,
                      onSave: (value) async {
                          final userId = user.userId!;
                          await ref.read(profileRepositoryProvider).updateProfile(description: value, userId: userId);
                          ref.invalidate(profileByIdProvider(userId));
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                      }, 
                      ),));
                    },
                    child: _buildFieldRow(t.editProfileDescriptionLabel, profile.description)),
                ],
              )
          );
          }
        )
      ),
    );
  }

}



