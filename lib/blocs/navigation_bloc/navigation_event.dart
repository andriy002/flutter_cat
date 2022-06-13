part of 'navigation_bloc.dart';

@immutable
abstract class NavigationEvent {}

class NavigateToTab extends NavigationEvent {
  NavigateToTab({
    required this.tabIndex,
  });

  final int tabIndex;
}
