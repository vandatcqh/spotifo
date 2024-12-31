// presentation/screens/user_info_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/user/user_info_cubit.dart';
import '../../../domain/usecases/get_current_user.dart';
import '../../../domain/usecases/sign_out.dart';
import '../../../data/datasources/auth_remote_datasource.dart';
import '../../../data/datasources/user_remote_datasource.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import 'sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoScreen extends StatelessWidget {
  UserInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Khởi tạo các phụ thuộc
    final authRemoteDataSource = AuthRemoteDataSource(firebaseAuth: FirebaseAuth.instance);
    final userRemoteDataSource = UserRemoteDataSource(firestore: FirebaseFirestore.instance);
    final authRepository = AuthRepositoryImpl(
      authRemoteDataSource: authRemoteDataSource,
      userRemoteDataSource: userRemoteDataSource,
    );
    final getCurrentUserUseCase = GetCurrentUserUseCase(authRepository);
    final signOutUseCase = SignOutUseCase(authRepository);

    return BlocProvider(
      create: (_) => UserInfoCubit(
        getCurrentUserUseCase: getCurrentUserUseCase,
        signOutUseCase: signOutUseCase,
      )..fetchUser(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Thông Tin Người Dùng'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                context.read<UserInfoCubit>().signOut();
              },
            ),
          ],
        ),
        body: BlocConsumer<UserInfoCubit, UserInfoState>(
          listener: (context, state) {
            if (state is UserInfoNotAuthenticated) {
              // Điều hướng đến màn hình đăng nhập
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => SignInScreen()),
              );
            } else if (state is UserInfoFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is UserInfoLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is UserInfoLoaded) {
              final user = state.user;
              return Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Họ và Tên: ${user.fullName}', style: TextStyle(fontSize: 18)),
                    Text('Email: ${user.username}', style: TextStyle(fontSize: 18)),
                    // Hiển thị các trường khác nếu cần
                    // Ví dụ: avatar
                    if (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
                      Image.network(user.avatarUrl!),
                  ],
                ),
              );
            } else if (state is UserInfoNotAuthenticated) {
              return Center(child: Text('Chưa đăng nhập'));
            } else if (state is UserInfoFailure) {
              return Center(child: Text('Không thể tải thông tin người dùng'));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
