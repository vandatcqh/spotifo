// presentation/screens/sign_up_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth/sign_up_cubit.dart';
import '../../../domain/usecases/sign_up.dart';
import '../../../data/datasources/auth_remote_datasource.dart';
import '../../../data/datasources/user_remote_datasource.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import 'user_info_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController fullNameController = TextEditingController();

  // Thêm các controller cho dateOfBirth, gender, avatarUrl nếu cần

  @override
  Widget build(BuildContext context) {
    // Khởi tạo các phụ thuộc
    final authRemoteDataSource = AuthRemoteDataSource(firebaseAuth: FirebaseAuth.instance);
    final userRemoteDataSource = UserRemoteDataSource(firestore: FirebaseFirestore.instance);
    final authRepository = AuthRepositoryImpl(
      authRemoteDataSource: authRemoteDataSource,
      userRemoteDataSource: userRemoteDataSource,
    );
    final signUpUseCase = SignUpUseCase(authRepository);

    return BlocProvider(
      create: (_) => SignUpCubit(signUpUseCase: signUpUseCase),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Đăng Ký'),
        ),
        body: BlocListener<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              // Điều hướng đến màn hình thông tin user
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => UserInfoScreen()),
              );
            } else if (state is SignUpFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Vui lòng nhập email'
                        : null,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Mật khẩu'),
                    obscureText: true,
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Vui lòng nhập mật khẩu'
                        : null,
                  ),
                  TextFormField(
                    controller: fullNameController,
                    decoration: InputDecoration(labelText: 'Họ và Tên'),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Vui lòng nhập họ và tên'
                        : null,
                  ),
                  // Thêm các trường bổ sung nếu cần
                  SizedBox(height: 20),
                  BlocBuilder<SignUpCubit, SignUpState>(
                    builder: (context, state) {
                      if (state is SignUpLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            context.read<SignUpCubit>().signUp(
                              email: emailController.text,
                              password: passwordController.text,
                              fullName: fullNameController.text,
                              // Truyền các trường bổ sung nếu có
                            );
                          }
                        },
                        child: Text('Đăng Ký'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
