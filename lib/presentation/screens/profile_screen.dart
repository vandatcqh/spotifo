// presentation/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:spotifo/core/app_export.dart';

import '../components/svg.dart';
import '../cubit/user/user_info_cubit.dart';
import '../cubit/genre/genre_cubit.dart';
import 'profile_genre_screen.dart';
import 'sign_in_screen.dart';

import '../../../injection_container.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  List<String> tempFavoriteGenres = [];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserInfoCubit>(
          create: (_) => sl<UserInfoCubit>()..fetchUser(),
        ),
        BlocProvider<GenreCubit>(
          create: (_) => sl<GenreCubit>()..fetchGenres(),
        ),
      ],
      child: Scaffold(
        body: BlocConsumer<UserInfoCubit, UserInfoState>(
          listener: (context, state) {
            if (state is UserInfoNotAuthenticated) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => SignInScreen()),
              );
            } else if (state is UserInfoFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            } else if (state is UserInfoLoaded) {
              // Khi dữ liệu người dùng được tải, khởi tạo tempFavoriteGenres
              tempFavoriteGenres = List<String>.from(state.user.favoriteGenres);
            }
          },
          builder: (context, state) {
            if (state is UserInfoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserInfoLoaded) {
              final user = state.user;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        color: Colors.grey,
                      ),
                      width: 100,
                      height: 100,
                      child: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                          ? Image.asset(user.avatarUrl!)
                          : SizedBox(
                              width: 100,
                              height: 100,
                              child: const Icon(
                                Icons.music_note,
                                size: 40,
                                color: Colors.black,
                              ),
                            ),
                    ),
                    SizedBox(height: 10),
                    Text(user.username, style: textTheme.headlineMedium?.withColor(colorTheme.secondary)),
                    SizedBox(height: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 20,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: 32,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: 10,
                              children: [
                                SVG("assets/svgs/heroicons-solid/user-circle.svg", size: 32, color: colorTheme.secondary),
                                Text("Name", style: textTheme.titleMedium?.withColor(colorTheme.secondary)),
                              ],
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: colorTheme.secondary, width: 1))),
                                child: Row(
                                  spacing: 8,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 32),
                                      child: Text(user.fullName, style: textTheme.titleMedium?.withColor(colorTheme.secondary)),
                                    ),
                                    IconButton(
                                      icon: SVG("assets/svgs/heroicons-solid/pencil.svg", color: colorTheme.secondary, size: 16),
                                      onPressed: () async {
                                        final newName = await showDialog<String>(
                                          context: context,
                                          builder: (context) {
                                            String? tempName = state.user.fullName;
                                            return AlertDialog(
                                              title: const Text('Rename'),
                                              content: TextField(
                                                onChanged: (value) {
                                                  tempName = value;
                                                },
                                                decoration: const InputDecoration(hintText: 'New name'),
                                                controller: TextEditingController(text: state.user.fullName),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(),
                                                  child: const Text('Discard'),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(tempName),
                                                  child: const Text('Save'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        if (newName != null && newName.trim().isNotEmpty) {
                                          if (context.mounted) {
                                            context.read<UserInfoCubit>().updateFullName(newName.trim());
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: 32,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: 10,
                              children: [
                                SVG("assets/svgs/heroicons-solid/envelope.svg", size: 32, color: colorTheme.secondary),
                                Text("Email", style: textTheme.titleMedium?.withColor(colorTheme.secondary)),
                              ],
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: colorTheme.secondary, width: 1))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32),
                                  child: Text(user.username, style: textTheme.titleMedium?.withColor(colorTheme.secondary)),
                                ),
                              ),
                            )
                          ],
                        ),
                        if (user.dateOfBirth != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 32,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                spacing: 10,
                                children: [
                                  SVG("assets/svgs/heroicons-solid/calendar.svg", size: 32, color: colorTheme.secondary),
                                  Text("Birthday", style: textTheme.titleMedium?.withColor(colorTheme.secondary)),
                                ],
                              ),
                              // ignore: avoid_unnecessary_containers
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32),
                                  child: Text(user.dateOfBirth!.toString(), style: textTheme.titleMedium?.withColor(colorTheme.secondary)),
                                ),
                              )
                            ],
                          ),

                        //Dark mode toggle

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   spacing: 32,
                        //   children: [
                        //     Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       spacing: 10,
                        //       children: [
                        //         SVG("assets/svgs/heroicons-solid/sparkles.svg", size: 32, color: colorTheme.secondary),
                        //         Text("Interface", style: textTheme.titleMedium?.withColor(colorTheme.secondary)),
                        //       ],
                        //     ),
                        //     Switch(
                        //       value: theme.isDarkMode(),
                        //       activeTrackColor: colorTheme.onPrimary,
                        //       activeColor: colorTheme.onError,
                        //       inactiveTrackColor: colorTheme.secondary,
                        //       inactiveThumbColor: colorTheme.onError,
                        //       onChanged: (bool value) {
                        //         setState(() {
                        //           theme.toggleMode();
                        //         });
                        //       },
                        //     )
                        //   ],
                        // ),

                        //Notification toggle

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   spacing: 32,
                        //   children: [
                        //     Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       spacing: 10,
                        //       children: [
                        //         SVG("assets/svgs/heroicons-solid/bell.svg", size: 32, color: colorTheme.secondary),
                        //         Text("Notification", style: textTheme.titleMedium?.withColor(colorTheme.secondary)),
                        //       ],
                        //     ),
                        //     Switch(
                        //       value: true,
                        //       activeTrackColor: colorTheme.onPrimary,
                        //       activeColor: colorTheme.onError,
                        //       inactiveTrackColor: colorTheme.secondary,
                        //       inactiveThumbColor: colorTheme.onError,
                        //       onChanged: (bool value) {
                        //         setState(() {});
                        //       },
                        //     )
                        //   ],
                        // ),

                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => UserInfoGenreScreen()));
                          },
                          icon: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 32,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                spacing: 10,
                                children: [
                                  SVG("assets/svgs/heroicons-solid/heart.svg", size: 32, color: colorTheme.secondary),
                                  Text("Interests", style: textTheme.titleMedium?.withColor(colorTheme.secondary)),
                                ],
                              ),
                              SVG("assets/svgs/heroicons-solid/chevron-right.svg", size: 24, color: colorTheme.secondary)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48),
                          child: Container(color: colorTheme.secondary.withAlphaD(0.6), height: 1),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            context.read<UserInfoCubit>().signOut();
                          },
                          icon: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 32,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                spacing: 10,
                                children: [
                                  SVG("assets/svgs/heroicons-solid/arrow-right-end-on-rectangle.svg", size: 32, color: colorTheme.error),
                                  Text("Log Out", style: textTheme.titleMedium?.withColor(colorTheme.error)),
                                ],
                              ),
                              SVG("assets/svgs/heroicons-solid/chevron-right.svg", size: 24, color: colorTheme.error)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else if (state is UserInfoNotAuthenticated) {
              return const Center(child: Text('Chưa đăng nhập'));
            } else if (state is UserInfoFailure) {
              return const Center(child: Text('Không thể tải thông tin người dùng'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
