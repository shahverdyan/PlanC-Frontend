import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:plan_c_frontend/features/calendari/presentation/providers/quedades_calendari_provider.dart';
import 'package:plan_c_frontend/features/publicacions/presentation/providers/publicacio_provider.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class CreatePublicacioScreen extends ConsumerStatefulWidget {
  const CreatePublicacioScreen({super.key});

  @override
  ConsumerState<CreatePublicacioScreen> createState() =>
      _CreatePublicacioScreenState();
}

class _CreatePublicacioScreenState
    extends ConsumerState<CreatePublicacioScreen> {
  final _descController = TextEditingController();
  XFile? _imatgeSeleccionada;
  String? _activitatSeleccionadaId;
  String? _activitatSeleccionadaTitol;

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => _imatgeSeleccionada = picked);
    }
  }

  Future<void> _publish(AppLocalizations t) async {
    final desc = _descController.text.trim();
    if (desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.createPublicacioRequiredDesc)),
      );
      return;
    }
    if (_activitatSeleccionadaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.createPublicacioRequiredActivity)),
      );
      return;
    }

    await ref.read(createPublicacioProvider.notifier).create(
          textDescripcio: desc,
          activitatId: _activitatSeleccionadaId!,
          imatge: _imatgeSeleccionada,
        );

    if (!mounted) return;

    final state = ref.read(createPublicacioProvider);
    if (state.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.createPublicacioSuccess)),
      );
      Navigator.of(context).pop();
    } else if (state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${t.createPublicacioError}: ${state.error}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final createState = ref.watch(createPublicacioProvider);
    final quedadesAsync = ref.watch(quedadesCalendariProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.createPublicacioTitle,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: createState.isLoading ? null : () => _publish(t),
              child: createState.isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: cs.primary),
                    )
                  : Text(
                      t.createPublicacioPublish,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: cs.primary),
                    ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Imatge (opcional) ────────────────────────────────────────
            GestureDetector(
              onTap: _pickImage,
              child: _imatgeSeleccionada != null
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_imatgeSeleccionada!.path),
                            width: double.infinity,
                            height: 220,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: CircleAvatar(
                            backgroundColor: cs.surface.withValues(alpha: 0.8),
                            radius: 18,
                            child: Icon(Icons.edit, size: 18, color: cs.onSurface),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      width: double.infinity,
                      height: 160,
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: cs.outlineVariant, style: BorderStyle.solid),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined,
                              size: 40, color: cs.onSurfaceVariant),
                          const SizedBox(height: 8),
                          Text(t.createPublicacioAddImage,
                              style: TextStyle(color: cs.onSurfaceVariant)),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 16),

            // ─── Descripció ───────────────────────────────────────────────
            TextField(
              controller: _descController,
              maxLines: 4,
              maxLength: 1000,
              decoration: InputDecoration(
                hintText: t.createPublicacioDescriptionHint,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: cs.surfaceContainerLow,
              ),
            ),
            const SizedBox(height: 16),

            // ─── Selector d'activitat ─────────────────────────────────────
            quedadesAsync.when(
              loading: () => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(t.createPublicacioLoadingActivities,
                    style: TextStyle(color: cs.onSurfaceVariant)),
              ),
              error: (e, _) => Text(
                t.createPublicacioNoActivities,
                style: TextStyle(color: cs.error),
              ),
              data: (quedades) {
                // Deduplicació per activitatId (una activitat pot tenir >1 quedada)
                final seen = <String>{};
                final activitats = quedades
                    .where((q) =>
                        q.activitatId.isNotEmpty &&
                        seen.add(q.activitatId))
                    .toList();

                if (activitats.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      t.createPublicacioNoActivities,
                      style: TextStyle(color: cs.onSurfaceVariant),
                    ),
                  );
                }

                return DropdownButtonFormField<String>(
                  initialValue: _activitatSeleccionadaId,
                  decoration: InputDecoration(
                    labelText: t.createPublicacioSelectActivity,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: cs.surfaceContainerLow,
                  ),
                  items: activitats
                      .map((q) => DropdownMenuItem<String>(
                            value: q.activitatId,
                            child: Text(
                              q.titolActivitat.isNotEmpty
                                  ? q.titolActivitat
                                  : q.activitatId,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val == null) return;
                    final q = activitats.firstWhere(
                        (q) => q.activitatId == val);
                    setState(() {
                      _activitatSeleccionadaId = val;
                      _activitatSeleccionadaTitol = q.titolActivitat;
                    });
                  },
                );
              },
            ),

            if (_activitatSeleccionadaTitol != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 16, color: cs.primary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _activitatSeleccionadaTitol!,
                      style: TextStyle(
                          color: cs.primary, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
