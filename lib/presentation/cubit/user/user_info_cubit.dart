// presentation/cubit/user/user_info_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/get_current_user.dart';
import '../../../domain/usecases/sign_out.dart';
import '../../../domain/usecases/update_user_profile.dart';
// import '../../../domain/usecases/artist_follow_usecase.dart'; // Xóa dòng này

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SignOutUseCase signOutUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;
  // final ArtistFollowUseCase artistFollowUseCase; // Xóa dòng này

  UserInfoCubit({
    required this.getCurrentUserUseCase,
    required this.signOutUseCase,
    required this.updateUserProfileUseCase,
    // required this.artistFollowUseCase, // Xóa dòng này
  }) : super(UserInfoInitial());

  /// Fetches user information
  Future<void> fetchUser() async {
    emit(UserInfoLoading());
    try {
      UserEntity? user = await getCurrentUserUseCase.call();
      if (user != null) {
        emit(UserInfoLoaded(user));
      } else {
        emit(UserInfoNotAuthenticated());
      }
    } catch (e) {
      emit(UserInfoFailure(e.toString()));
    }
  }

  /// Signs out the user
  Future<void> signOut() async {
    emit(UserInfoLoading());
    try {
      await signOutUseCase.call();
      emit(UserInfoNotAuthenticated());
    } catch (e) {
      emit(UserInfoFailure(e.toString()));
    }
  }

  Future<void> updateFavoriteGenres(List<String> genres) async {
    if (state is UserInfoLoaded) {
      final currentState = state as UserInfoLoaded;
      final user = currentState.user;

      final updatedUser = user.copyWith(favoriteGenres: genres);

      emit(UserInfoUpdating()); // Bạn có thể tạo thêm trạng thái UserInfoUpdating nếu muốn

      try {
        final updated = await updateUserProfileUseCase.call(updatedUser);
        emit(UserInfoLoaded(updated));
      } catch (e) {
        emit(UserInfoFailure("Không thể cập nhật thể loại yêu thích."));
      }
    }
  }

  Future<void> updateFullName(String fullName) async {
    if (state is UserInfoLoaded) {
      final currentState = state as UserInfoLoaded;
      final user = currentState.user;

      // Tạo một bản sao mới của user với fullName được cập nhật
      final updatedUser = user.copyWith(fullName: fullName);

      emit(UserInfoUpdating()); // Emit trạng thái đang cập nhật

      try {
        // Gửi yêu cầu cập nhật thông tin người dùng
        await updateUserProfileUseCase.updateFullName(fullName);

        // Cập nhật thành công, emit trạng thái mới với user đã cập nhật
        emit(UserInfoLoaded(updatedUser));
      } catch (e) {
        // Nếu lỗi xảy ra, emit trạng thái lỗi
        emit(UserInfoFailure("Không thể cập nhật tên đầy đủ."));
      }
    }
  }
}
