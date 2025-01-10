// presentation/cubit/user/user_info_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/get_current_user.dart';
import '../../../domain/usecases/sign_out.dart';
import '../../../domain/usecases/update_user_profile.dart';
import '../../../domain/usecases/artist_follow_usecase.dart';

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SignOutUseCase signOutUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;
  final ArtistFollowUseCase artistFollowUseCase;

  UserInfoCubit({
    required this.getCurrentUserUseCase,
    required this.signOutUseCase,
    required this.updateUserProfileUseCase,
    required this.artistFollowUseCase,
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
  /// Thêm nghệ sĩ vào danh sách yêu thích
  Future<void> addFavoriteArtist(String artistId) async {
    if (state is UserInfoLoaded) {

      final currentState = state as UserInfoLoaded;
      final user = currentState.user;
      final favoriteArtists = List<String>.from(user.favoriteArtists);

      if (!favoriteArtists.contains(artistId)) {
        favoriteArtists.add(artistId);
      }

      final updatedUser = user.copyWith(favoriteArtists: favoriteArtists);

      emit(UserInfoUpdating());

      try {
        await artistFollowUseCase.increaseFollower(artistId);
        final updated = await updateUserProfileUseCase.call(updatedUser);
        emit(UserInfoLoaded(updated));
      } catch (e) {
        print("dudu: $e");
        emit(UserInfoFailure("Không thể thêm nghệ sĩ yêu thích."));
      }
    }
  }

  /// Xoá nghệ sĩ khỏi danh sách yêu thích
  Future<void> removeFavoriteArtist(String artistId) async {
    if (state is UserInfoLoaded) {
      final currentState = state as UserInfoLoaded;
      final user = currentState.user;
      final favoriteArtists = List<String>.from(user.favoriteArtists);

      if (favoriteArtists.contains(artistId)) {
        favoriteArtists.remove(artistId);
      }

      final updatedUser = user.copyWith(favoriteArtists: favoriteArtists);

      emit(UserInfoUpdating());

      try {
        await artistFollowUseCase.decreaseFollower(artistId);
        final updated = await updateUserProfileUseCase.call(updatedUser);
        emit(UserInfoLoaded(updated));
      } catch (e) {
        emit(UserInfoFailure("Không thể xoá nghệ sĩ yêu thích."));
      }
    }
  }
}