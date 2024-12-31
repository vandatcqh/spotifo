// presentation/cubit/user/user_info_state.dart

part of 'user_info_cubit.dart';

abstract class UserInfoState extends Equatable {
  const UserInfoState();

  @override
  List<Object?> get props => [];
}

class UserInfoInitial extends UserInfoState {}

class UserInfoLoading extends UserInfoState {}

class UserInfoLoaded extends UserInfoState {
  final UserEntity user;

  const UserInfoLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserInfoNotAuthenticated extends UserInfoState {}

class UserInfoFailure extends UserInfoState {
  final String error;

  const UserInfoFailure(this.error);

  @override
  List<Object?> get props => [error];
}
