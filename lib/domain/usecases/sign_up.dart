// domain/usecases/auth/sign_up.dart

import '../repositories/user_repository.dart';
import '../entities/user_entity.dart';

class SignUpUseCase {
  final UserRepository authRepository;

  SignUpUseCase(this.authRepository);

  Future<UserEntity> call({
    required String email,
    required String password,
    required String fullName,
    DateTime? dateOfBirth,
    String? gender,
    String? avatarUrl,
  }) {
    return authRepository.signUp(
      email: email,
      password: password,
      fullName: fullName,
      dateOfBirth: dateOfBirth,
      gender: gender,
      avatarUrl: avatarUrl,
    );
  }
}
