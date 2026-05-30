import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:plan_c_frontend/features/calendari/domain/entities/calendari_compte.dart';
import 'package:plan_c_frontend/features/calendari/domain/entities/calendari_event.dart';
import 'package:plan_c_frontend/features/calendari/domain/repositories/i_calendari_repository.dart';

class CalendariRepositoryImpl implements ICalendariRepository {
  final DeviceCalendarPlugin _plugin;

  CalendariRepositoryImpl(this._plugin);

  @override
  Future<bool> solicitarPermisos() async {
    var result = await _plugin.hasPermissions();
    if (result.isSuccess && (result.data ?? false)) return true;
    result = await _plugin.requestPermissions();
    return result.isSuccess && (result.data ?? false);
  }

  @override
  Future<List<CalendariCompte>> obtenirCalendarisGoogle() async {
    final result = await _plugin.retrieveCalendars();
    if (!result.isSuccess) {
      throw Exception('No s\'han pogut obtenir els calendaris del dispositiu');
    }

    final tots = result.data ?? [];
    debugPrint('--- Tots els calendaris al dispositiu (${tots.length}) ---');
    for (final c in tots) {
      debugPrint('ID: ${c.id} | Nom: ${c.name} | Compte: ${c.accountName} | Tipus: ${c.accountType} | ReadOnly: ${c.isReadOnly} | Default: ${c.isDefault}');
    }

    final filtrats = tots
        .where((c) => c.accountType == 'com.google' && !(c.isReadOnly ?? true))
        .map((c) => CalendariCompte(
              id: c.id ?? '',
              nomCompte: c.accountName ?? c.id ?? '',
              nomCalendari: c.name ?? c.accountName ?? c.id ?? '',
            ))
        .where((c) => c.id.isNotEmpty)
        .toList();

    debugPrint('--- Calendaris Google escrivibles (${filtrats.length}) ---');
    for (final c in filtrats) {
      debugPrint('ID: ${c.id} | Calendari: ${c.nomCalendari} | Compte: ${c.nomCompte}');
    }

    return filtrats;
  }

  @override
  Future<String?> afegirEsdeveniment(
    CalendariEvent event,
    String calendarId,
  ) async {
    final tzStart = tz.TZDateTime.from(event.dataInici, tz.local);
    final tzEnd = tz.TZDateTime.from(event.dataFi, tz.local);

    final deviceEvent = Event(
      calendarId,
      title: event.titol,
      description: event.descripcio,
      location: event.ubicacio,
      start: tzStart,
      end: tzEnd,
      reminders: event.alertaMinuts != null
          ? [Reminder(minutes: event.alertaMinuts!)]
          : [],
    );
    debugPrint('Creant esdeveniment al calendari ID: $calendarId');
    debugPrint('Títol: ${event.titol}');
    debugPrint('Inici: ${event.dataInici}');
    debugPrint('Fi: ${event.dataFi}');

    final result = await _plugin.createOrUpdateEvent(deviceEvent);
    debugPrint('Resultat isSuccess: ${result?.isSuccess}');
    debugPrint('Resultat data: ${result?.data}');
    debugPrint('Resultat errors: ${result?.errors.map((e) => e.errorMessage).join(', ')}');
    if (result == null || !result.isSuccess) {
      final errors = result?.errors.map((e) => e.errorMessage).join(', ');
      throw Exception(
        (errors != null && errors.isNotEmpty)
            ? errors
            : 'Error desconegut en crear l\'esdeveniment',
      );
    }
    return result.data;
  }
}
