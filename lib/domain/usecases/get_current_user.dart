// domain/usecases/auth/get_current_user.dart

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository authRepository;

  GetCurrentUserUseCase(this.authRepository);

  Future<UserEntity?> call() {
    return authRepository.getCurrentUser();
  }
}
