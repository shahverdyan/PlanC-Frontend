import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'package:plan_c_frontend/features/groups/domain/models/group.dart';
import 'package:plan_c_frontend/features/groups/presentation/providers/create_group_provider.dart';
import 'package:plan_c_frontend/features/groups/presentation/providers/edit_group_provider.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/activitats/model/activitat.dart';
import 'package:plan_c_frontend/features/chat/presentation/providers/chat_list_provider.dart'; // ✅ Importamos el provider de la lista de chats
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class GroupFormScreen extends ConsumerStatefulWidget {
  final String activityId;
  final Activitat activitat;
  final Group? groupToEdit;

  const GroupFormScreen({
    super.key,
    required this.activityId,
    required this.activitat,
    this.groupToEdit,
  });

  @override
  ConsumerState<GroupFormScreen> createState() => _GroupFormScreenState();
}

class _GroupFormScreenState extends ConsumerState<GroupFormScreen> {

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _minParticipantsController;
  late final TextEditingController _maxParticipantsController;

  XFile? _selectedPhoto;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _dateError = false;

  String? _minError;
  String? _maxError;
  bool _isFormValid = false;

  bool get _isEditMode => widget.groupToEdit != null;

  @override
  void initState() {
    super.initState();
    final g = widget.groupToEdit;
    _titleController = TextEditingController(text: g?.title ?? '');
    _descriptionController = TextEditingController(text: g?.description ?? '');
    _minParticipantsController = TextEditingController(
      text: g != null ? g.minParticipants.toString() : '',
    );
    _maxParticipantsController = TextEditingController(
      text: g != null ? g.maxParticipants.toString() : '',
    );
    if (g != null) {
      _selectedDate = g.dateTime;
      _selectedTime = TimeOfDay.fromDateTime(g.dateTime);
    }
    _isFormValid = _computeFormValid();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _minParticipantsController.dispose();
    _maxParticipantsController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final dataInici = widget.activitat.dataInici;
    final dataFi = widget.activitat.dataFi;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final isSameDay = dataInici.year == dataFi.year &&
        dataInici.month == dataFi.month &&
        dataInici.day == dataFi.day;
    final lastDate = isSameDay
        ? DateTime(dataFi.year, dataFi.month, dataFi.day, 23, 59, 59)
        : dataFi;

    // Block past dates: firstDate is the later of the activity start and today
    final firstDate = dataInici.isBefore(today) ? today : dataInici;

    // Safety: entire activity range is in the past
    if (firstDate.isAfter(lastDate)) return;

    final effectiveInitialDate =
        _selectedDate != null &&
                !_selectedDate!.isBefore(firstDate) &&
                !_selectedDate!.isAfter(lastDate)
            ? _selectedDate!
            : firstDate;

    final date = await showDatePicker(
      context: context,
      initialDate: effectiveInitialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: Theme.of(context).colorScheme.primary),
        ),
        child: child!,
      ),
    );
    if (date == null) return;
    if (!mounted) return;

    final existingTime = _selectedTime ?? TimeOfDay.now();
    final time = await showDialog<TimeOfDay>(
      context: context,
      barrierColor: Colors.black45,
      builder: (context) {
        DateTime tempTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          existingTime.hour,
          existingTime.minute,
        );
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.seleccionaHora,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    TimePickerSpinner(
                      is24HourMode: true,
                      time: tempTime,
                      onTimeChange: (time) => tempTime = time,
                      normalTextStyle: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      highlightedTextStyle: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      spacing: 44,
                      itemHeight: 48,
                      isForce2Digits: true,
                      isShowSeconds: false,
                    ),
                    Text(
                      ':',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, null),
                      child: Text(
                        AppLocalizations.of(context)!.cancelLa,
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(
                        context,
                        TimeOfDay(
                          hour: tempTime.hour,
                          minute: tempTime.minute,
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.dacord,
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    if (time == null) return;

    // Reject if the selected date+time is in the past
    final pickedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    if (pickedDateTime.isBefore(now)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.groupFormDatePast),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() {
      _selectedDate = date;
      _selectedTime = time;
      _dateError = false;
      _isFormValid = _computeFormValid();
    });
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() => _selectedPhoto = picked);
    }
  }

  bool _computeFormValid() {
    final minVal = int.tryParse(_minParticipantsController.text);
    final maxVal = int.tryParse(_maxParticipantsController.text);
    return _titleController.text.trim().isNotEmpty &&
        minVal != null && minVal > 0 &&
        maxVal != null && maxVal > 0 &&
        maxVal >= minVal &&
        _selectedDate != null &&
        _selectedTime != null;
  }

  String? _computeMaxError(String value) {
    final t = AppLocalizations.of(context)!;
    if (value == '0') return t.groupFormMinAtLeastOne;
    final maxVal = int.tryParse(value);
    final minVal = int.tryParse(_minParticipantsController.text);
    if (maxVal != null && minVal != null && maxVal < minVal) {
      return t.groupFormMaxGreaterEqualMin;
    }
    return null;
  }

  void _validateMin(String value) {
    final t = AppLocalizations.of(context)!;
    setState(() {
      _minError = value == '0' ? t.groupFormMinAtLeastOne : null;
      _maxError = _computeMaxError(_maxParticipantsController.text);
      _isFormValid = _computeFormValid();
    });
  }

  void _validateMax(String value) {
    setState(() {
      _maxError = _computeMaxError(value);
      _isFormValid = _computeFormValid();
    });
  }

  Future<void> _submit() async {
    final isFormValid = _formKey.currentState!.validate();

    final hasDateError = _selectedDate == null || _selectedTime == null;
    if (hasDateError) setState(() => _dateError = true);

    if (!isFormValid || hasDateError || _minError != null || _maxError != null) {
      return;
    }

    final isSingleDayActivity = widget.activitat.dataInici.year == widget.activitat.dataFi.year &&
    widget.activitat.dataInici.month == widget.activitat.dataFi.month &&
    widget.activitat.dataInici.day == widget.activitat.dataFi.day;

    final dateTime = isSingleDayActivity
    ? widget.activitat.dataInici
    : DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

    // Safety net: reject if the final dateTime is in the past
    if (!isSingleDayActivity && dateTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.groupFormDatePast), backgroundColor: Theme.of(context).colorScheme.error),
      );
      return;
    }

    if (_isEditMode) {
      await _editGroup(dateTime);
    } else {
      await _createGroup(dateTime);
    }
  }

  Future<void> _createGroup(DateTime dateTime) async {
    final t = AppLocalizations.of(context)!;
    final currentUserId = ref.read(currentUserIdProvider);
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.groupFormNoUser)),
      );
      return;
    }

    try {
      await ref.read(createGroupProvider.notifier).createGroup(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        minParticipants: int.parse(_minParticipantsController.text),
        maxParticipants: int.parse(_maxParticipantsController.text),
        dateTime: dateTime,
        activityId: widget.activityId,
        creatorId: currentUserId,
      );

      // ✅ Refrescamos la lista de chats automáticamente porque crear una quedada crea un chat
      ref.invalidate(chatListProvider); 

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.groupFormCreateSuccess),
          backgroundColor: AppSemanticColors.of(context).success,
        ),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.groupFormErrorPrefix(e.toString())),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _editGroup(DateTime dateTime) async {
    final t = AppLocalizations.of(context)!;
    final g = widget.groupToEdit!;
    try {
      await ref.read(editGroupProvider.notifier).updateGroup(
        groupId: g.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        minParticipants: int.parse(_minParticipantsController.text),
        maxParticipants: int.parse(_maxParticipantsController.text),
        currentParticipants: g.currentParticipants,
        participantIds: g.participantIds,
        dateTime: dateTime,
        activityId: g.activityId,
        creatorId: g.creatorId,
        createdAt: g.createdAt,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.groupFormUpdateSuccess),
          backgroundColor: AppSemanticColors.of(context).success,
        ),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.groupFormErrorPrefix(e.toString())),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isLoading = _isEditMode
        ? ref.watch(editGroupProvider).isLoading
        : ref.watch(createGroupProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditMode ? t.groupFormEditTitle : t.groupFormCreateTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildActivityInfoCard(widget.activitat),
              const SizedBox(height: 20),
              _buildPhotoPickerSection(t),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _titleController,
                label: t.groupFormTitleLabel,
                icon: Icons.title,
                hint: widget.activitat.titol,
                onChanged: (_) => setState(() => _isFormValid = _computeFormValid()),
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _descriptionController,
                label: t.groupFormDescriptionLabel,
                icon: Icons.description,
                maxLines: 3,
              ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _minParticipantsController,
                      label: t.groupFormMinLabel,
                      icon: Icons.group,
                      isNumber: true,
                      onChanged: _validateMin,
                      realtimeError: _minError,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildTextField(
                      controller: _maxParticipantsController,
                      label: t.groupFormMaxLabel,
                      icon: Icons.group_add,
                      isNumber: true,
                      onChanged: _validateMax,
                      realtimeError: _maxError,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              InkWell(
                onTap: _pickDateTime,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _dateError
                          ? Theme.of(context).colorScheme.error
                          : AppSemanticColors.of(context).inputBorder,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: AppSemanticColors.of(context).inputFill,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 12),
                      Text(
                        _selectedDate == null || _selectedTime == null
                            ? t.groupFormPickDateTime
                            : t.groupFormDateValue(_selectedDate!.day, _selectedDate!.month, _selectedTime!.format(context)),
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedDate == null
                              ? Theme.of(context).colorScheme.onSurfaceVariant
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_dateError) ...[
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    t.groupFormDateRequired,
                    style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
                  ),
                ),
              ],
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: isLoading || !_isFormValid ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  disabledBackgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  disabledForegroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary)
                    : Text(
                        _isEditMode ? t.groupFormSaveButton : t.groupFormCreateButton,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPickerSection(AppLocalizations t) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: _pickPhoto,
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppSemanticColors.of(context).inputBorder,
            style: BorderStyle.solid,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: _selectedPhoto != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    File(_selectedPhoto!.path),
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedPhoto = null),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(Icons.close, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: _pickPhoto,
                      child: Container(
                        decoration: BoxDecoration(
                          color: cs.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.edit, color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            Text(t.groupFormChangePhoto, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined, size: 36, color: cs.primary),
                  const SizedBox(height: 8),
                  Text(
                    t.groupFormAddPhoto,
                    style: TextStyle(color: cs.primary, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t.groupFormAddPhotoSubtitle,
                    style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildActivityInfoCard(Activitat activitat) {
    final isSameDay = activitat.dataInici.year == activitat.dataFi.year &&
        activitat.dataInici.month == activitat.dataFi.month &&
        activitat.dataInici.day == activitat.dataFi.day;

    final dateFormat = DateFormat('d MMM yyyy', Localizations.localeOf(context).toString());
    final dateText = isSameDay
        ? dateFormat.format(activitat.dataInici)
        : '${dateFormat.format(activitat.dataInici)} – ${dateFormat.format(activitat.dataFi)}';

    final address = [activitat.adreca, activitat.localitat]
        .where((s) => s.isNotEmpty)
        .join(', ');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            activitat.titol,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          _InfoRow(icon: Icons.calendar_today_outlined, text: dateText),
          if (activitat.nomEspai.isNotEmpty) ...[
            const SizedBox(height: 4),
            _InfoRow(icon: Icons.place_outlined, text: activitat.nomEspai),
          ],
          if (address.isNotEmpty) ...[
            const SizedBox(height: 4),
            _InfoRow(icon: Icons.map_outlined, text: address),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    bool isNumber = false,
    void Function(String)? onChanged,
    String? realtimeError,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          inputFormatters:
              isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
            filled: true,
            fillColor: AppSemanticColors.of(context).inputFill,
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppSemanticColors.of(context).inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppSemanticColors.of(context).inputFocusBorder, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 2),
            ),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? AppLocalizations.of(context)!.groupFormRequiredField : null,
        ),
        if (realtimeError != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              realtimeError,
              style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}