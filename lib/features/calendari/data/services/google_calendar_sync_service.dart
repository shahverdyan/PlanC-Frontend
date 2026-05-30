import 'dart:convert';

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:plan_c_frontend/features/calendari/data/models/quedada_apuntada_model.dart';

class SyncResult {
  final int created;
  final int updated;
  final int deleted;
  final int failed;

  const SyncResult({
    this.created = 0,
    this.updated = 0,
    this.deleted = 0,
    this.failed = 0,
  });

  bool get hasFailures => failed > 0;
  int get totalChanges => created + updated + deleted;
}

class _SyncEntry {
  final String eventId;
  final String hash;

  const _SyncEntry({required this.eventId, required this.hash});

  Map<String, dynamic> toJson() => {'eventId': eventId, 'hash': hash};

  factory _SyncEntry.fromJson(Map<String, dynamic> json) => _SyncEntry(
        eventId: json['eventId'] as String,
        hash: json['hash'] as String,
      );
}

class GoogleCalendarSyncService {
  static const _storageKey = 'google_calendar_sync_mapping';

  final DeviceCalendarPlugin _plugin;
  final FlutterSecureStorage _storage;

  GoogleCalendarSyncService({
    DeviceCalendarPlugin? plugin,
    FlutterSecureStorage? storage,
  })  : _plugin = plugin ?? DeviceCalendarPlugin(),
        _storage = storage ?? const FlutterSecureStorage();

  // ── Mapping persistence ───────────────────────────────────────────────────

  Future<Map<String, _SyncEntry>> _loadMapping() async {
    final raw = await _storage.read(key: _storageKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map(
        (k, v) => MapEntry(k, _SyncEntry.fromJson(v as Map<String, dynamic>)),
      );
    } catch (_) {
      return {};
    }
  }

  Future<void> _saveMapping(Map<String, _SyncEntry> mapping) async {
    final encoded = jsonEncode(
      mapping.map((k, v) => MapEntry(k, v.toJson())),
    );
    await _storage.write(key: _storageKey, value: encoded);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _contentHash(QuedadaApuntadaModel q) =>
      '${q.quedadaTitol}|${q.dataHoraTrobada.millisecondsSinceEpoch}|${q.titolActivitat}';

  Future<String> _createDeviceEvent(
    QuedadaApuntadaModel q,
    String calendarId,
  ) async {
    final inici = tz.TZDateTime.from(q.dataHoraTrobada.toLocal(), tz.local);
    final fi = inici.add(const Duration(hours: 1));

    final descripcio = [
      q.titolActivitat,
      if (q.categoriaNom.isNotEmpty) q.categoriaNom,
    ].join(' · ');

    final event = Event(
      calendarId,
      title: q.quedadaTitol,
      description: descripcio,
      start: inici,
      end: fi,
      reminders: [Reminder(minutes: 30)],
    );

    final result = await _plugin.createOrUpdateEvent(event);
    if (result == null || !result.isSuccess || (result.data ?? '').isEmpty) {
      final errors =
          result?.errors.map((e) => e.errorMessage).join(', ') ?? 'desconegut';
      throw Exception('Error creant event: $errors');
    }
    return result.data!;
  }

  Future<void> _deleteDeviceEvent(String eventId, String calendarId) async {
    await _plugin.deleteEvent(calendarId, eventId);
  }

  Future<bool> _deviceEventExists(String eventId, String calendarId) async {
    try {
      final result = await _plugin.retrieveEvents(
        calendarId,
        RetrieveEventsParams(eventIds: [eventId]),
      );
      return result.isSuccess && (result.data?.isNotEmpty ?? false);
    } catch (_) {
      return false;
    }
  }

  // ── Public API ────────────────────────────────────────────────────────────

  Future<SyncResult> syncQuedades(
    List<QuedadaApuntadaModel> quedades,
    String calendarId,
  ) async {
    final mapping = await _loadMapping();
    final currentIds = quedades.map((q) => q.quedadaId).toSet();

    int created = 0, updated = 0, deleted = 0, failed = 0;

    // 1. Elimina events de quedades on l'usuari ja no és apuntat
    final toDelete =
        mapping.keys.where((id) => !currentIds.contains(id)).toList();
    for (final id in toDelete) {
      try {
        await _deleteDeviceEvent(mapping[id]!.eventId, calendarId);
        deleted++;
      } catch (_) {
        failed++;
      }
      mapping.remove(id);
    }

    // 2. Crea o actualitza events per a les quedades actuals
    for (final q in quedades) {
      final existing = mapping[q.quedadaId];
      final newHash = _contentHash(q);

      try {
        if (existing == null) {
          // Nova quedada → crear event
          final eventId = await _createDeviceEvent(q, calendarId);
          mapping[q.quedadaId] = _SyncEntry(eventId: eventId, hash: newHash);
          created++;
        } else if (existing.hash != newHash) {
          // Quedada canviada → esborrar l'antic i crear-ne un de nou
          try {
            await _deleteDeviceEvent(existing.eventId, calendarId);
          } catch (_) {}
          final eventId = await _createDeviceEvent(q, calendarId);
          mapping[q.quedadaId] = _SyncEntry(eventId: eventId, hash: newHash);
          updated++;
        } else {
          // Hash no ha canviat → verificar que l'event encara existeix al calendari
          final exists = await _deviceEventExists(existing.eventId, calendarId);
          if (!exists) {
            final eventId = await _createDeviceEvent(q, calendarId);
            mapping[q.quedadaId] = _SyncEntry(eventId: eventId, hash: newHash);
            created++;
          }
        }
      } catch (_) {
        failed++;
      }
    }

    await _saveMapping(mapping);
    return SyncResult(
      created: created,
      updated: updated,
      deleted: deleted,
      failed: failed,
    );
  }
}
