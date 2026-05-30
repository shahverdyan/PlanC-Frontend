import '../repositories/i_activity_link_repository.dart';

class OpenTicketLinkUseCase {
  final IActivityLinkRepository _repository;

  OpenTicketLinkUseCase(this._repository);

  Future<void> call(String url) => _repository.openTicketLink(url);
}