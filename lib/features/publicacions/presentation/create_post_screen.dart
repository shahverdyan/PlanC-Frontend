import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart'; 
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/amistats/presentation/providers/amistats_provider.dart';
import 'package:plan_c_frontend/features/activitats/presentation/provider/activitats_providers.dart';
import 'package:plan_c_frontend/features/activitats/model/activitat.dart';
import 'package:plan_c_frontend/features/publicacions/presentation/providers/post_provider.dart'; 
import 'package:plan_c_frontend/features/perfil/presentation/providers/profile_provider.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

import 'package:path_provider/path_provider.dart'; 
import 'package:path/path.dart' as p;             

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _picker = ImagePicker(); 
  Activitat? _selectedActivity;
  final List<String> _mentionedUserIds = [];
  bool _isLoading = false;

  final List<XFile> _attachedImages = [];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _selectUserMention(String username) {
    setState(() {
      _textController.text = '${_textController.text}@$username ';
      _textController.selection = TextSelection.collapsed(
        offset: _textController.text.length,
      );
    });
  }

Future<void> _pickImageFromGallery() async {
  try {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85, 
    );
    
    if (image == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = p.basename(image.path);

    final savedImagePath = p.join(appDir.path, 'post_img_${DateTime.now().millisecondsSinceEpoch}_$fileName');

    final File permanentFile = await File(image.path).copy(savedImagePath);

    setState(() {
      _attachedImages.add(XFile(permanentFile.path)); 
    });
  } catch (e) {
    debugPrint("Error al seleccionar y guardar la imagen: $e");
    // Alerta visual para el usuario (Falta de almacenamiento, permisos denegados, etc.)
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo cargar la imagen: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

  void _removeImage(int index) {
    setState(() {
      _attachedImages.removeAt(index);
    });
  }

  void _showSearchPicker<T>({
    required String title,
    required String hintText,
    required String emptyMessage,
    required ProviderListenable<AsyncValue<List<T>>> provider,
    required String Function(T item) getSearchableString,
    required Widget Function(T item, VoidCallback onTap) itemBuilder,
    required void Function(T item) onItemSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        String localSearchQuery = "";

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Consumer(
              builder: (context, ref, child) {
                final asyncData = ref.watch(provider);

                return Padding(
                  padding: EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        decoration: InputDecoration(
                          hintText: hintText,
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        onChanged: (value) {
                          setModalState(() {
                            localSearchQuery = value.toLowerCase();
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 250),
                        child: asyncData.when(
                          loading: () => const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          error: (err, stack) => Center(
                            child: Text('Error al cargar datos: $err'),
                          ),
                          data: (allItems) {
                            final filteredItems = allItems.where((item) {
                              return getSearchableString(item).toLowerCase().contains(localSearchQuery);
                            }).toList();

                            if (filteredItems.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(emptyMessage),
                                ),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = filteredItems[index];
                                return itemBuilder(item, () {
                                  onItemSelected(item);
                                  Navigator.pop(context);
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showActivityPicker(AppLocalizations t) {
    _showSearchPicker<Activitat>(
      title: t.selectActivity,
      hintText: t.searchActivity,
      emptyMessage: t.noActivitiesFound,
      provider: activitatsByUserIdProvider(ref.read(currentUserIdProvider) ?? ''),
      getSearchableString: (act) => act.titol,
      itemBuilder: (act, onTap) => ListTile(
        leading: const Icon(Icons.local_activity, color: Colors.orange, size: 28),
        title: Text(act.titol, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(act.categoria, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        onTap: onTap,
      ),
      onItemSelected: (act) {
        setState(() {
          _selectedActivity = act;
        });
      },
    );
  }


  void _showUserPicker(AppLocalizations t) {
    final currentUserId = ref.read(currentUserIdProvider) ?? '';
    String localSearchQuery = "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // 🌟 StatefulBuilder para redibujar los checks dentro del modal dinámicamente
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Consumer(
              builder: (context, ref, child) {
                final asyncAmics = ref.watch(amistatsProvider(currentUserId));

                return Padding(
                  padding: EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cabecera con título y botón de confirmación
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${t.mentionFriends} (${_mentionedUserIds.length})',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context), // Cierra al terminar
                            child: Text(
                              t.done,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // Buscador local
                      TextField(
                        decoration: InputDecoration(
                          hintText: t.searchFriends,
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        onChanged: (value) {
                          setModalState(() {
                            localSearchQuery = value.toLowerCase();
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Listado de amigos con soporte asíncrono
                      Container(
                        constraints: const BoxConstraints(maxHeight: 280),
                        child: asyncAmics.when(
                          loading: () => const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(color: Colors.orange),
                            ),
                          ),
                          error: (err, stack) => Center(
                            child: Text('Error al cargar amigos: $err'),
                          ),
                          data: (allFriends) {
                            final filteredFriends = allFriends.where((user) {
                              return user.nomUsuari.toLowerCase().contains(localSearchQuery);
                            }).toList();

                            if (filteredFriends.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(t.noFriendsFound),
                                ),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredFriends.length,
                              itemBuilder: (context, index) {
                                final user = filteredFriends[index];
                                // Comprobamos si el ID ya está en la lista de la pantalla
                                final isSelected = _mentionedUserIds.contains(user.usuariId);

                                return ListTile(
                                  title: Text(user.nomUsuari, style: const TextStyle(fontWeight: FontWeight.w500)),
                                  subtitle: Text('@${user.nomUsuari}'),
                                  // Check interactivo estilo Instagram
                                  trailing: Icon(
                                    isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                                    color: isSelected ? Colors.orange : Colors.grey.shade400,
                                    size: 24,
                                  ),
                                  onTap: () {

                                    setModalState(() {
                                      setState(() {
                                        if (isSelected) {
                                          _mentionedUserIds.remove(user.usuariId);
                                        } else {
                                          _mentionedUserIds.add(user.usuariId);
                                          // Añade automáticamente el tag de texto en la descripción al seleccionarlo
                                          _selectUserMention(user.nomUsuari);
                                        }
                                      });
                                    });
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(currentUserIdProvider) ?? '';
    final t = AppLocalizations.of(context)!;

    // 1. Escucha fallos globales al cargar actividades
    ref.listen<AsyncValue>(activitatsByUserIdProvider(currentUserId), (previous, next) {
      if (next is AsyncError && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar actividades: ${next.error}'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating, // Hace que flote elegantemente
          ),
        );
      }
    });

    // 2. Escucha fallos globales al cargar amigos (menciones)
    if (currentUserId.isNotEmpty) {
      ref.listen<AsyncValue>(amistatsProvider(currentUserId), (previous, next) {
        if (next is AsyncError && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al cargar amigos: ${next.error}'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      });
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.createPost, style: TextStyle(color: colorScheme.onSurface, fontSize: 18)),
        backgroundColor: colorScheme.surface,
        elevation: 0.5,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: ElevatedButton.icon(
              onPressed: _isLoading
                  ? null
                  : () async {
                      if (_selectedActivity == null || _attachedImages.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(t.createPostWarning),
                            backgroundColor: Colors.orangeAccent,
                          ),
                        );
                        return;
                      }

                      final navigator = Navigator.of(context);
                      final messenger = ScaffoldMessenger.of(context);

                      setState(() => _isLoading = true);

                      try {
                        final String activityId = _selectedActivity!.id;
                        final List<String> userIds = _mentionedUserIds;
                        final String text = _textController.text.trim();

                        await ref.read(postRepositoryProvider).createPost(
                              userId: currentUserId,
                              text: text,
                              activityId: activityId,
                              images: _attachedImages,
                              userIds: userIds,
                            );

                        if (mounted) {
                          ref.invalidate(profileByIdProvider(currentUserId));
                          navigator.pop();
                        }
                      } catch (e) {
                        if (mounted) {
                          setState(() => _isLoading = false);
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text('Error al crear la publicación: $e'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      }
                    },
              // Icono dinámico: muestra un spinner si está cargando, o el icono de enviar si está listo
              icon: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                      ),
                    )
                  : const Icon(Icons.add, size: 16),
              label: Text(
                _isLoading ? t.posting : t.post,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              // Estilización del botón
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange, // Color principal
                disabledBackgroundColor: Colors.grey.shade300, // Color cuando está deshabilitado
                disabledForegroundColor: Colors.grey.shade500,
                elevation: _isLoading ? 0 : 2,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Bordes redondeados modernos
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_selectedActivity != null) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_selectedActivity!.titol, style: const TextStyle(fontSize: 12)),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => setState(() => _selectedActivity = null),
                            child: const Icon(Icons.close, size: 14, color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                TextField(
                  controller: _textController,
                  maxLines: null,
                  style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: t.writeMessage,
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 16),

                if (_attachedImages.isNotEmpty)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _attachedImages.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_attachedImages[index].path), 
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                child: const Icon(Icons.close, size: 14, color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),

          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SafeArea(
              child: Row(
                children: [
                  Text(t.addMultimedia, style: TextStyle(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.image_outlined, color: Colors.green),
                    onPressed: _pickImageFromGallery, 
                  ),
                  IconButton(
                    icon: const Icon(Icons.local_activity_rounded, color: Colors.orange),
                    onPressed: () => _showActivityPicker(t),
                  ),
                  IconButton(
                    icon: const Icon(Icons.alternate_email, color: Colors.blue),
                    onPressed: () => _showUserPicker(t),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}