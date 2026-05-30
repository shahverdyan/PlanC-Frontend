import 'package:flutter_test/flutter_test.dart';
import 'package:plan_c_frontend/features/redireccioCompraEntrades/data/repositories/activity_link_repository_impl.dart';

void main() {
  late ActivityLinkRepositoryImpl repository;

  setUp(() {
    repository = ActivityLinkRepositoryImpl();
  });

  group('ActivityLinkRepositoryImpl - openTicketLink', () {
    test('llança excepció si la URL és buida', () async {
      expect(
        () => repository.openTicketLink(''),
        throwsException,
      );
    });

    test('llança excepció si la URL no té scheme', () async {
      expect(
        () => repository.openTicketLink('exemple.cat/concert'),
        throwsException,
      );
    });

    test('llança excepció si la URL té un scheme invàlid', () async {
      expect(
        () => repository.openTicketLink('ftp://exemple.cat/concert'),
        throwsException,
      );
    });
  });
}