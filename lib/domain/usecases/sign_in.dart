// domain/usecases/auth/sign_in.dart

import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class SignInUseCase {
  final AuthRepository authRepository;

  SignInUseCase(this.authRepository);

  Future<UserEntity> call({
    required String email,
    required String password,
  }) {
    return authRepository.signIn(email: email, password: password);
  }
}
