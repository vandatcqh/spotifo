// domain/usecases/auth/sign_in.dart

import '../repositories/user_repository.dart';
import '../entities/user_entity.dart';

class SignInUseCase {
  final UserRepository authRepository;

  SignInUseCase(this.authRepository);

  Future<UserEntity> call({
    required String email,
    required String password,
  }) {
    return authRepository.signIn(email: email, password: password);
  }
}
