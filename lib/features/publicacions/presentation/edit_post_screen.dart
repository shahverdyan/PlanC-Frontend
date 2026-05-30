import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart'; 
//import 'package:plan_c_frontend/features/amistats/domain/models/amistat.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/amistats/presentation/providers/amistats_provider.dart';
import 'package:plan_c_frontend/features/activitats/presentation/provider/activitats_providers.dart';
import 'package:plan_c_frontend/features/activitats/model/activitat.dart';
import 'package:plan_c_frontend/features/publicacions/presentation/providers/post_provider.dart'; 
import 'package:plan_c_frontend/features/perfil/presentation/providers/profile_provider.dart';
import 'package:plan_c_frontend/features/publicacions/domain/models/publicacio_detall.dart';
import 'package:plan_c_frontend/features/interaccions/presentation/providers/interaccions_provider.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

import 'package:path_provider/path_provider.dart'; 
import 'package:path/path.dart' as p;

class EditPostScreen extends ConsumerWidget {
  final String postId;

  const EditPostScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(publicacioDetallProvider(postId));

    return Scaffold(
      body: postAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.orange)),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
              const SizedBox(height: 12),
              Text('Error al carregar la publicació: $err'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(publicacioDetallProvider(postId)),
                child: const Text('Reintentar'),
              )
            ],
          ),
        ),
        data: (post) => _EditPostForm(post: post),
      ),
    );
  }
}


class _EditPostForm extends ConsumerStatefulWidget {
  final PublicacioDetall post;

  const _EditPostForm({required this.post});

  @override
  ConsumerState<_EditPostForm> createState() => _EditPostFormState();
}

class _EditPostFormState extends ConsumerState<_EditPostForm> {
  late final TextEditingController _textController;
  final ImagePicker _picker = ImagePicker(); 
  
  Activitat? _selectedActivity;
  final List<String> _mentionedUserIds = [];
  final List<XFile> _attachedImages = []; // Noves imatges locals
  final List<String> _multimediaAEliminar = []; // IDs de les imatges del servidor a esborrar
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.post.descripcio);
    
    // Si el teu model de post ja conté l'activitat associada, la pots inicialitzar aquí:
    // _selectedActivity = widget.post.activitat;
    
    // Si el teu model té mencions inicials, les pots bolcar aquí:
    _mentionedUserIds.addAll(widget.post.mencions.map((m) => m.id));
  }

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

  void _removeNewImage(int index) {
    setState(() {
      _attachedImages.removeAt(index);
    });
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
                                    // 🌟 Modificamos el estado del modal (setModalState) Y de la pantalla (setState)
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

    // Ll色が listeners globals per a errors de dades
    ref.listen<AsyncValue>(activitatsByUserIdProvider(currentUserId), (previous, next) {
      if (next is AsyncError && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar actividades: ${next.error}'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

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

    // Unifiquem en una llista el recompte total d'imatges visibles
    final existingImages = widget.post.imatges;
    final int totalImagesCount = existingImages.length + _attachedImages.length;

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(t.editPost, style: TextStyle(color: colorScheme.onSurface, fontSize: 18)),
        backgroundColor: colorScheme.surface,
        elevation: 0.5,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: ElevatedButton.icon(
              onPressed: _isLoading
                  ? null
                  : () async {
                      final navigator = Navigator.of(context);
                      final messenger = ScaffoldMessenger.of(context);

                      final int imatgesServidorRestants = widget.post.imatges
                        .where((img) => !_multimediaAEliminar.contains(img.id))
                        .length;

                        final int imatgesTotalsActuals = imatgesServidorRestants + _attachedImages.length;

                        // 3. Si el resultado es 0, frenamos el guardado y avisamos al usuario
                        if (imatgesTotalsActuals < 1) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(t.editPostWarning),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return; // Corta la ejecución aquí para que no continúe al setState ni al API
                        }

                      setState(() => _isLoading = true);

                      try {
                        final String text = _textController.text.trim();
                        //final String? activityId = _selectedActivity?.id;

                        // Cridem al repositori amb la informació d'actualització estructurada
                        await ref.read(postRepositoryProvider).updatePost(
                              postId: widget.post.id,
                              userId: currentUserId,
                              textDescripcio: text,
                              multimediaAEliminar: _multimediaAEliminar,
                              mencions: _mentionedUserIds,
                              novesImatges: _attachedImages.map((x) => File(x.path)).toList(),
                              // activityId: activityId // Activa'l si la teva API accepta canvi d'activitat al fer update
                            );

                        if (mounted) {
                          ref.invalidate(publicacioDetallProvider(widget.post.id));
                          ref.invalidate(profileByIdProvider(currentUserId));
                          navigator.pop();
                        }
                      } catch (e) {
                        if (mounted) {
                          setState(() => _isLoading = false);
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text('Error al modificar la publicación: $e'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      }
                    },
              icon: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                      ),
                    )
                  : const Icon(Icons.save, size: 16),
              label: Text(
                _isLoading ? t.saving : t.save,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange,
                disabledBackgroundColor: Colors.grey.shade300,
                disabledForegroundColor: Colors.grey.shade500,
                elevation: _isLoading ? 0 : 2,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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

                // ─── SECCIÓ TEXT DE DESCRIPCIÓ ───
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

                // ─── SECCIÓ COMBINADA DE FILES MULTIMÈDIA (GRIDVIEW 1:1) ───
                if (totalImagesCount > 0)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: totalImagesCount,
                    itemBuilder: (context, index) {
                      // 1. Gestionem primer les imatges que ja venen del Servidor/API
                      if (index < existingImages.length) {
                        final imatgeServer = existingImages[index];
                        final bool esBorrada = _multimediaAEliminar.contains(imatgeServer.id);

                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                imatgeServer.url,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                color: esBorrada ? Colors.black54 : null,
                                colorBlendMode: esBorrada ? BlendMode.darken : null,
                              ),
                            ),
                            if (esBorrada)
                              const Positioned.fill(
                                child: Center(
                                  child: Icon(Icons.delete_forever, color: Colors.redAccent, size: 28),
                                ),
                              ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (esBorrada) {
                                      _multimediaAEliminar.remove(imatgeServer.id);
                                    } else {
                                      _multimediaAEliminar.add(imatgeServer.id);
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: esBorrada ? Colors.green : Colors.black54, 
                                    shape: BoxShape.circle
                                  ),
                                  child: Icon(
                                    esBorrada ? Icons.undo : Icons.close, 
                                    size: 14, 
                                    color: Colors.white
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      } else {
                        // 2. Gestionem les noves imatges triades localment per l'usuari
                        final localIndex = index - existingImages.length;
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(_attachedImages[localIndex].path), 
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => _removeNewImage(localIndex),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                  child: const Icon(Icons.close, size: 14, color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        );
                      }
                    },
                  ),
              ],
            ),
          ),

          // ─── BOTTOM MENU BAR IDENTIC A CREAR ───
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