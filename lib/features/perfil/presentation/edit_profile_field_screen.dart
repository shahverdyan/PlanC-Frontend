import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/shared/custom_textform_input.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class EditProfileFieldScreen extends ConsumerStatefulWidget{
  final String label; 
  final String actualValue;
  final Future<void> Function(String value) onSave;

  const EditProfileFieldScreen({super.key, required this.label, required this.actualValue, required this.onSave});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileFieldScreenState();
}

class _EditProfileFieldScreenState extends ConsumerState<EditProfileFieldScreen> {

  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.actualValue);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
        leading: BackButton(),
        actionsPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        actions: [
          TextButton(onPressed: () async {
            await widget.onSave(controller.text);
          }, 
            child: Text(
              AppLocalizations.of(context)!.editProfileFieldSave,
              style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w900, fontSize: 20),
            ),)
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: CustomTextformInput(controller: controller, keyboardType: TextInputType.multiline, )
        )
      )
        
    );
  }
}