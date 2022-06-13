import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_cat/repositories/firebase_repositories/firebase_repositories.dart';
import 'package:flutter_cat/utils/constants.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthInitial> {
  AuthBloc({required this.fireBaseRepositories}) : super(AuthInitial()) {
    on<SignInGoogle>((event, emit) async {
      final bool? response = await fireBaseRepositories.signInGoogle();

      if (response != null) {
        emit(
          state.copyWith(
            status: BlocStatus.success,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: BlocStatus.failed,
          ),
        );
      }
    });

    on<SignInFacebook>((event, emit) async {
      final bool? response = await fireBaseRepositories.signInFacebook();

      if (response != null) {
        emit(
          state.copyWith(
            status: BlocStatus.success,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: BlocStatus.failed,
          ),
        );
      }
    });

    on<LogOut>((event, emit) async {
      final bool? response = await fireBaseRepositories.logOut();

      if (response != null) {
        emit(
          state.copyWith(
            status: BlocStatus.success,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: BlocStatus.failed,
          ),
        );
      }
    });
  }
  final FireBaseRepositories fireBaseRepositories;
}
