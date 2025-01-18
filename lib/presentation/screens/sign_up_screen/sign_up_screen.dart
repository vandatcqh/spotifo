import 'package:flutter/material.dart';

// Import necessary Cubit and screens
import '../../common_widgets/custom_elevated_button.dart';
import '../../common_widgets/custom_text_form_field.dart';
import '../../cubit/auth/sign_up_cubit.dart';
import 'user_info_screen.dart';

// Import service locator

import '../../../../injection_container.dart';
import '../../../core/app_export.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SignUpCubit>(),
      child: Scaffold(
        backgroundColor: colorTheme.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 8.h), // Top spacing
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 5.h,
                      ),
                      decoration:
                          AppDecoration.gradientC.copyWith(
                        borderRadius: BorderRadius.circular(10.h),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Create an Account",
                              style: textTheme.headlineMedium?.withBold(),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Full Name",
                            style: textTheme.titleMedium,
                          ),
                          CustomTextFormField(
                            controller: fullNameController,
                            textInputType: TextInputType.text,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 1.5.h,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
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
                            obscureText: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 1.5.h,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              } else if (value.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 5.h),
                          Divider(
                            thickness: 0.1.h,
                            color: colorTheme.onSurface.withAlphaD(0.4),
                          ),
                          SizedBox(height: 5.h),
                          BlocListener<SignUpCubit, SignUpState>(
                            listener: (context, state) {
                              if (state is SignUpSuccess) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => UserInfoScreen(),
                                  ),
                                );
                              } else if (state is SignUpFailure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.error)),
                                );
                              }
                            },
                            child: BlocBuilder<SignUpCubit, SignUpState>(
                              builder: (context, state) {
                                if (state is SignUpLoading) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                return CustomElevatedButton(
                                  height: 6.h,
                                  width: 80.w,
                                  text: "Sign Up",
                                  buttonTextStyle:
                                      textTheme.titleMedium,
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      context.read<SignUpCubit>().signUp(
                                            email: emailController.text,
                                            password: passwordController.text,
                                            fullName: fullNameController.text,
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
                        // Navigate back to the login page
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Already have an account? Log in here",
                      ),
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
