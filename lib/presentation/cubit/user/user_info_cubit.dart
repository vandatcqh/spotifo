// presentation/cubit/user/user_info_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/get_current_user.dart';
import '../../../domain/usecases/sign_out.dart';

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SignOutUseCase signOutUseCase;

  UserInfoCubit({
    required this.getCurrentUserUseCase,
    required this.signOutUseCase,
  }) : super(UserInfoInitial());

  Future<void> fetchUser() async {
    emit(UserInfoLoading());
    try {
      UserEntity? user = await getCurrentUserUseCase.call();
      if (user != null) {
        emit(UserInfoLoaded(user));
      } else {
        emit(UserInfoNotAuthenticated());
      }
    } catch (e) {
      emit(UserInfoFailure(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(UserInfoLoading());
    try {
      await signOutUseCase.call();
      emit(UserInfoNotAuthenticated());
    } catch (e) {
      emit(UserInfoFailure(e.toString()));
    }
  }
}