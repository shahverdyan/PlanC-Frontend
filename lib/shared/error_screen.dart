import 'package:flutter/material.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class ErrorScreen extends StatelessWidget {

  final String error;

  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center (
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.errorScreenTitle, style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.error),),
                Icon(Icons.bug_report, size: MediaQuery.of(context).size.width * 0.5),
                Text(error, style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 16), textAlign: TextAlign.center,)
              ],
            )
          ),
      )
      )
    );
  }
}