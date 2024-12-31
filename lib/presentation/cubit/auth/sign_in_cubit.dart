// presentation/cubit/auth/sign_in_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/sign_in.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final SignInUseCase signInUseCase;

  SignInCubit({required this.signInUseCase}) : super(SignInInitial());

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(SignInLoading());
    try {
      UserEntity user = await signInUseCase.call(
        email: email,
        password: password,
      );
      emit(SignInSuccess(user));
    } catch (e) {
      emit(SignInFailure(e.toString()));
    }
  }
}
