// domain/usecases/auth/sign_out.dart

import '../repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository authRepository;

  SignOutUseCase(this.authRepository);

  Future<void> call() {
    return authRepository.signOut();
  }
}
