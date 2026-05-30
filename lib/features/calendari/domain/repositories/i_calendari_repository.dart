import '../entities/calendari_compte.dart';
import '../entities/calendari_event.dart';

abstract class ICalendariRepository {
  Future<bool> solicitarPermisos();
  Future<List<CalendariCompte>> obtenirCalendarisGoogle();
  Future<String?> afegirEsdeveniment(CalendariEvent event, String calendarId);
}
