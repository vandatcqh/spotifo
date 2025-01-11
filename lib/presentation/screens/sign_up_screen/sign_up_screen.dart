// presentation/screens/sign_up_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Chỉ import Cubit và các screen cần thiết
import '../../cubit/auth/sign_up_cubit.dart';
import 'user_info_screen.dart';

// Import service locator
import '../../../../injection_container.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Lấy SignUpCubit từ service locator
      create: (_) => sl<SignUpCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đăng Ký'),
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
                  TextFormField(
                    controller: fullNameController,
                    decoration: const InputDecoration(labelText: 'Họ và Tên'),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Vui lòng nhập họ và tên'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<SignUpCubit, SignUpState>(
                    builder: (context, state) {
                      if (state is SignUpLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            context.read<SignUpCubit>().signUp(
                              email: emailController.text,
                              password: passwordController.text,
                              fullName: fullNameController.text,
                            );
                          }
                        },
                        child: const Text('Đăng Ký'),
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
