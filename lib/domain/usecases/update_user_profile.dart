// domain/usecases/auth/update_user_profile.dart

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class UpdateUserProfileUseCase {
  final AuthRepository authRepository;

  UpdateUserProfileUseCase(this.authRepository);

  Future<UserEntity> call(UserEntity updatedUser) {
    return authRepository.updateUserProfile(updatedUser);
  }
}
