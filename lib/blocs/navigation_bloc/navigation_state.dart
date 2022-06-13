part of 'navigation_bloc.dart';

enum NavigationStateStatus { initial, tab, page }

class NavigationState {
  const NavigationState({
    this.status = NavigationStateStatus.initial,
    this.tabIndex = 0,
  });

  final NavigationStateStatus status;
  final int tabIndex;

  NavigationState copyWith({
    NavigationStateStatus? status,
    int? tabIndex,
  }) {
    return NavigationState(
      status: status ?? this.status,
      tabIndex: tabIndex ?? this.tabIndex,
    );
  }
}
