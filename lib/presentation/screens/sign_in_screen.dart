// presentation/screens/sign_in_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Chỉ import Cubit và các screen cần thiết
import '../cubit/auth/sign_in_cubit.dart';
import 'sign_up_screen.dart';
import 'user_info_screen.dart';
import 'list_artist_screen.dart';
import 'song_list_screen.dart';

// Import service locator
import '../../../injection_container.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Lấy SignInCubit từ service locator
      create: (_) => sl<SignInCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đăng Nhập'),
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
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Vui lòng nhập email'
                        : null,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Mật khẩu'),
                    obscureText: true,
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Vui lòng nhập mật khẩu'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<SignInCubit, SignInState>(
                    builder: (context, state) {
                      if (state is SignInLoading) {
                        return const Center(child: CircularProgressIndicator());
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
                        child: const Text('Đăng Nhập'),
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
                    child: const Text('Chưa có tài khoản? Đăng Ký'),
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
