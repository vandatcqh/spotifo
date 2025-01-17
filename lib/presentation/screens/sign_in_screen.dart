// presentation/screens/sign_in_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotifo/presentation/screens/player/queue_screen.dart';
import 'package:spotifo/presentation/screens/search_screen.dart';

// Import necessary Cubit and screens
import '../cubit/auth/sign_in_cubit.dart';
import 'sign_up_screen/sign_up_screen.dart';
import 'home_screen/home_screen.dart';

// Import service locator
import '../../../injection_container.dart';
import '../../../core/app_export.dart';
import '../common_widgets/custom_elevated_button.dart';
import '../common_widgets/custom_text_form_field.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Lấy SignInCubit từ service locator
      create: (_) => sl<SignInCubit>(),
      child: Scaffold(
        backgroundColor: colorTheme.onSurface,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 10.h), // Top spacing
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 5.h,
                      ),
                      decoration:
                          AppDecoration.gradientB.copyWith(
                        borderRadius: BorderRadius.circular(10.h),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Sign in to App",
                              style: textTheme.headlineMedium,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Email",
                            style: textTheme.titleMedium,
                          ),
                          CustomTextFormField(
                            controller: emailController,
                            textInputType: TextInputType.emailAddress,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 1.5.h,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$")
                                  .hasMatch(value)) {
                                return 'Invalid email format';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Password",
                            style: textTheme.titleMedium,
                          ),
                          CustomTextFormField(
                            controller: passwordController,
                            textInputAction: TextInputAction.done,
                            obscureText: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 1.5.h,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 1.h),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Forgot your password?",
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Divider(
                            thickness: 0.1.h,
                            color: colorTheme.onSurface.withAlphaD(0.4),
                          ),
                          SizedBox(height: 5.h),
                          BlocListener<SignInCubit, SignInState>(
                            listener: (context, state) {
                              if (state is SignInSuccess) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                    // settings: RouteSettings(name: '/home'),
                                  ),
                                );
                                //Navigator.pushNamed(context, '/genre_song');
                              } else if (state is SignInFailure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.error)),
                                );
                              }
                            },
                            child: BlocBuilder<SignInCubit, SignInState>(
                              builder: (context, state) {
                                if (state is SignInLoading) {
                                  return const CircularProgressIndicator();
                                }
                                return CustomElevatedButton(
                                  height: 6.h,
                                  width: 80.w,
                                  text: "Sign in",
                                  buttonTextStyle:
                                      textTheme.titleMedium,
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      context.read<SignInCubit>().signIn(
                                            email: emailController.text,
                                            password: passwordController.text,
                                          );
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text('Don’t have an account? Sign Up'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
