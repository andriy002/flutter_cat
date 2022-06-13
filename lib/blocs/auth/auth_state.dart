part of 'auth_bloc.dart';

class AuthInitial {
  AuthInitial({this.status = BlocStatus.initial});
  final BlocStatus status;

  AuthInitial copyWith({
    BlocStatus? status,
  }) {
    return AuthInitial(
      status: status ?? this.status,
    );
  }
}
