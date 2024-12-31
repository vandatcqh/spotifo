// presentation/cubit/auth/sign_up_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/sign_up.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SignUpUseCase signUpUseCase;

  SignUpCubit({required this.signUpUseCase}) : super(SignUpInitial());

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    DateTime? dateOfBirth,
    String? gender,
    String? avatarUrl,
  }) async {
    emit(SignUpLoading());
    try {
      UserEntity user = await signUpUseCase.call(
        email: email,
        password: password,
        fullName: fullName,
        dateOfBirth: dateOfBirth,
        gender: gender,
        avatarUrl: avatarUrl,
      );
      emit(SignUpSuccess(user));
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }
}
