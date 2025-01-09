// presentation/cubit/user/user_info_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/get_current_user.dart';
import '../../../domain/usecases/sign_out.dart';
import '../../../domain/usecases/update_user_profile.dart';

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SignOutUseCase signOutUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;

  UserInfoCubit({
    required this.getCurrentUserUseCase,
    required this.signOutUseCase,
    required this.updateUserProfileUseCase,
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

  /// Toggles a genre in the user's favorite genres
  Future<void> toggleFavoriteGenre(String genre) async {
    if (state is UserInfoLoaded) {
      final currentState = state as UserInfoLoaded;
      final user = currentState.user;
      final favoriteGenres = List<String>.from(user.favoriteGenres);

      if (favoriteGenres.contains(genre)) {
        favoriteGenres.remove(genre);
      } else {
        favoriteGenres.add(genre);
      }

      final updatedUser = user.copyWith(favoriteGenres: favoriteGenres);

      emit(UserInfoUpdating()); // Optional: You can create a separate state for updating

      try {
        final updated = await updateUserProfileUseCase.call(updatedUser);
        emit(UserInfoLoaded(updated));
      } catch (e) {
        emit(UserInfoFailure("Không thể cập nhật thể loại yêu thích."));
      }
    }
  }
}
