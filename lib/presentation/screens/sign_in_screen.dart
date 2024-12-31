// presentation/screens/sign_in_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth/sign_in_cubit.dart';
import '../../../domain/usecases/sign_in.dart';
import '../../../data/datasources/auth_remote_datasource.dart';
import '../../../data/datasources/user_remote_datasource.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import 'user_info_screen.dart';
import 'sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Khởi tạo các phụ thuộc
    final authRemoteDataSource = AuthRemoteDataSource(firebaseAuth: FirebaseAuth.instance);
    final userRemoteDataSource = UserRemoteDataSource(firestore: FirebaseFirestore.instance);
    final authRepository = AuthRepositoryImpl(
      authRemoteDataSource: authRemoteDataSource,
      userRemoteDataSource: userRemoteDataSource,
    );
    final signInUseCase = SignInUseCase(authRepository);

    return BlocProvider(
      create: (_) => SignInCubit(signInUseCase: signInUseCase),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Đăng Nhập'),
        ),
        body: BlocListener<SignInCubit, SignInState>(
          listener: (context, state) {
            if (state is SignInSuccess) {
              // Điều hướng đến màn hình thông tin user
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => UserInfoScreen()),
              );
            } else if (state is SignInFailure) {
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
                  SizedBox(height: 20),
                  BlocBuilder<SignInCubit, SignInState>(
                    builder: (context, state) {
                      if (state is SignInLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            context.read<SignInCubit>().signIn(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                          }
                        },
                        child: Text('Đăng Nhập'),
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      // Điều hướng đến màn hình đăng ký
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => SignUpScreen()),
                      );
                    },
                    child: Text('Chưa có tài khoản? Đăng Ký'),
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
