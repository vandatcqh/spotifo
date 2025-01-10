// injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ------------------- //
//  Chỉ import Cubit  //
// ------------------- //
import 'presentation/cubit/auth/sign_in_cubit.dart';
import 'presentation/cubit/auth/sign_up_cubit.dart';
import 'presentation/cubit/user/user_info_cubit.dart';
import 'presentation/cubit/genre/genre_cubit.dart';

// ------------------- //
//    Import domain    //
// ------------------- //
import 'domain/usecases/sign_in.dart';
import 'domain/usecases/sign_up.dart';
import 'domain/usecases/get_current_user.dart';
import 'domain/usecases/sign_out.dart';
import 'domain/usecases/get_all_genre.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/genre_repository.dart';

// ------------------- //
//    Import data      //
// ------------------- //
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/user_remote_datasource.dart';
import 'data/datasources/genre_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/genre_repository_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;

  // --- Data Sources ---
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSource(firebaseAuth: firebaseAuth),
  );
  sl.registerLazySingleton<UserRemoteDataSource>(
        () => UserRemoteDataSource(firestore: firebaseFirestore),
  );
  sl.registerLazySingleton<GenreRemoteDataSource>(
      () => GenreRemoteDataSource(firestore: firebaseFirestore),
  );

  // --- Repositories ---
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      authRemoteDataSource: sl(),
      userRemoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<GenreRepository>(
      () => GenreRepositoryImpl(sl()),
  );

  // --- UseCases ---
  sl.registerLazySingleton<SignInUseCase>(
        () => SignInUseCase(sl()),
  );
  sl.registerLazySingleton<SignUpUseCase>(
        () => SignUpUseCase(sl()),
  );
  sl.registerLazySingleton<GetCurrentUserUseCase>(
        () => GetCurrentUserUseCase(sl()),
  );
  sl.registerLazySingleton<SignOutUseCase>(
        () => SignOutUseCase(sl()),
  );
  sl.registerLazySingleton<GetAllGenresUseCase>(
      () => GetAllGenresUseCase(sl()),
  );

  // --- Cubits ---
  // Lưu ý: Dùng registerFactory nếu mỗi lần tạo mới Cubit
  //        Dùng registerLazySingleton nếu chỉ muốn một instance duy nhất
  sl.registerFactory<SignInCubit>(
        () => SignInCubit(signInUseCase: sl()),
  );
  sl.registerFactory<SignUpCubit>(
        () => SignUpCubit(signUpUseCase: sl()),
  );
  sl.registerFactory<UserInfoCubit>(
        () => UserInfoCubit(
      getCurrentUserUseCase: sl(),
      signOutUseCase: sl(),
    ),
  );
  sl.registerFactory<GenreCubit>(
      () => GenreCubit(sl()),
  );
}
