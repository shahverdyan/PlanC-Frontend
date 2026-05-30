import '../entities/calendari_compte.dart';
import '../entities/calendari_event.dart';
import '../repositories/i_calendari_repository.dart';

sealed class CalendariResultat {
  const CalendariResultat();
}

final class CalendariSuccess extends CalendariResultat {
  final String eventId;
  const CalendariSuccess(this.eventId);
}

final class CalendariPermisDenega extends CalendariResultat {
  const CalendariPermisDenega();
}

final class CalendariError extends CalendariResultat {
  final String missatge;
  const CalendariError(this.missatge);
}

final class CalendariNecessitaSeleccio extends CalendariResultat {
  final List<CalendariCompte> calendaris;
  const CalendariNecessitaSeleccio(this.calendaris);
}

class AfegirAlCalendariUseCase {
  final ICalendariRepository _repository;

  const AfegirAlCalendariUseCase(this._repository);

  Future<CalendariResultat> obtenirCalendaris() async {
    try {
      final permisOk = await _repository.solicitarPermisos();
      if (!permisOk) return const CalendariPermisDenega();

      final calendaris = await _repository.obtenirCalendarisGoogle();
      if (calendaris.isEmpty) {
        return const CalendariError(
          'No hi ha cap compte de Google Calendar disponible al dispositiu',
        );
      }
      return CalendariNecessitaSeleccio(calendaris);
    } catch (e) {
      return CalendariError(e.toString());
    }
  }

  Future<CalendariResultat> call(CalendariEvent event, String calendarId) async {
    try {
      final eventId = await _repository.afegirEsdeveniment(event, calendarId);
      if (eventId != null && eventId.isNotEmpty) {
        return CalendariSuccess(eventId);
      }
      return const CalendariError('No s\'ha pogut crear l\'esdeveniment al calendari');
    } catch (e) {
      return CalendariError(e.toString());
    }
  }
}
