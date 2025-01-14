// domain/usecases/auth/sign_out.dart

import '../repositories/user_repository.dart';

class SignOutUseCase {
  final UserRepository authRepository;

  SignOutUseCase(this.authRepository);

  Future<void> call() {
    return authRepository.signOut();
  }
}
