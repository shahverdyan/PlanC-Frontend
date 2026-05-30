enum RelationshipStatus {
  friends,
  requestReceived,
  requestSent,
  stranger,
}

enum RelationshipAction { accept, reject, cancel, add, remove }

class RelationshipActionsState {
  final RelationshipAction? loadingAction;
  final String? error;

  const RelationshipActionsState({this.loadingAction, this.error});

  bool isLoadingAction(RelationshipAction action) => loadingAction == action;

  RelationshipActionsState copyWith({
    RelationshipAction? loadingAction,
    String? error,
    bool clearLoading = false,
    bool clearError = false,
  }) {
    return RelationshipActionsState(
      loadingAction: clearLoading ? null : loadingAction ?? this.loadingAction,
      error: clearError ? null : error ?? this.error,
    );
  }
}