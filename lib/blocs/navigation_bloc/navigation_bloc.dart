import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'navigation_event.dart';

part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState()) {
    on<NavigateToTab>((event, emit) {
      emit(
        state.copyWith(
          tabIndex: event.tabIndex,
          status: NavigationStateStatus.tab,
        ),
      );
    });
  }
}
