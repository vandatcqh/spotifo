// domain/usecases/auth/update_user_profile.dart

import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class UpdateUserProfileUseCase {
  final UserRepository userRepository;

  UpdateUserProfileUseCase(this.userRepository);

  Future<UserEntity> call(UserEntity updatedUser) {
    return userRepository.updateUserProfile(updatedUser);
  }
  Future<void> updateFullName(String fullName) {
    return userRepository.updateFullName(fullName);
  }
}
