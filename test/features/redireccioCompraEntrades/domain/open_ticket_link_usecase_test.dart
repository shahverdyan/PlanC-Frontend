import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plan_c_frontend/features/redireccioCompraEntrades/domain/repositories/i_activity_link_repository.dart';
import 'package:plan_c_frontend/features/redireccioCompraEntrades/domain/usecases/open_ticket_link_usecase.dart';

@GenerateMocks([IActivityLinkRepository])
import 'open_ticket_link_usecase_test.mocks.dart';

void main() {
  late OpenTicketLinkUseCase useCase;
  late MockIActivityLinkRepository mockRepository;

  setUp(() {
    mockRepository = MockIActivityLinkRepository();
    useCase = OpenTicketLinkUseCase(mockRepository);
  });

  group('OpenTicketLinkUseCase', () {
    test('crida openTicketLink del repository amb la URL correcta', () async {
      const url = 'https://entrades.exemple.cat/concert';

      when(mockRepository.openTicketLink(url)).thenAnswer((_) async {});

      await useCase(url);

      verify(mockRepository.openTicketLink(url)).called(1);
    });

    test('propaga l\'excepció si el repository falla', () async {
      const url = 'https://entrades.exemple.cat/concert';

      when(mockRepository.openTicketLink(url))
          .thenThrow(Exception('No s\'ha pogut obrir l\'enllaç'));

      expect(() => useCase(url), throwsException);
    });
  });
}