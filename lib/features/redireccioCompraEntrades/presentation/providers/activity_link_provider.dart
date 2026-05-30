import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/activity_link_repository_impl.dart';
import '../../domain/repositories/i_activity_link_repository.dart';
import '../../domain/usecases/open_ticket_link_usecase.dart';

// --- Providers de dependències ---

final activityLinkRepositoryProvider = Provider<IActivityLinkRepository>(
  (_) => ActivityLinkRepositoryImpl(),
);

final openTicketLinkUseCaseProvider = Provider<OpenTicketLinkUseCase>(
  (ref) => OpenTicketLinkUseCase(ref.watch(activityLinkRepositoryProvider)),
);

// --- Estat ---

enum BuyTicketsStatus { idle, loading, success, error }

class BuyTicketsState {
  final BuyTicketsStatus status;
  final String? errorMessage;

  const BuyTicketsState({
    this.status = BuyTicketsStatus.idle,
    this.errorMessage,
  });

  BuyTicketsState copyWith({
    BuyTicketsStatus? status,
    String? errorMessage,
  }) {
    return BuyTicketsState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

// --- Notifier ---

class BuyTicketsNotifier extends StateNotifier<BuyTicketsState> {
  final OpenTicketLinkUseCase _useCase;
  final String _url;

  BuyTicketsNotifier(this._useCase, this._url)
      : super(const BuyTicketsState());

  Future<void> openLink() async {
    state = state.copyWith(status: BuyTicketsStatus.loading);
    try {
      await _useCase(_url);
      state = state.copyWith(status: BuyTicketsStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: BuyTicketsStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}

// --- Provider principal ---

final buyTicketsProvider = StateNotifierProvider.autoDispose
    .family<BuyTicketsNotifier, BuyTicketsState, String>(
  (ref, url) => BuyTicketsNotifier(
    ref.watch(openTicketLinkUseCaseProvider),
    url,
  ),
);