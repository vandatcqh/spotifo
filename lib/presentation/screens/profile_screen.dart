// presentation/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/user/user_info_cubit.dart';
import '../cubit/genre/genre_cubit.dart';
import '../cubit/genre/genre_state.dart';
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
        appBar: AppBar(
          title: const Text('Thông Tin Người Dùng'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<UserInfoCubit>().signOut();
              },
            ),
            // Nút Save
            BlocBuilder<UserInfoCubit, UserInfoState>(
              builder: (context, state) {
                if (state is UserInfoLoaded) {
                  return IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: () {
                      context.read<UserInfoCubit>().updateFavoriteGenres(tempFavoriteGenres);
                    },
                  );
                }
                return SizedBox.shrink();
              },
            ),
            // Nút Đổi Tên
            BlocBuilder<UserInfoCubit, UserInfoState>(
              builder: (context, state) {
                if (state is UserInfoLoaded) {
                  return IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final newName = await showDialog<String>(
                        context: context,
                        builder: (context) {
                          String? tempName = state.user.fullName;
                          return AlertDialog(
                            title: const Text('Đổi tên'),
                            content: TextField(
                              onChanged: (value) {
                                tempName = value;
                              },
                              decoration: const InputDecoration(hintText: 'Nhập tên mới'),
                              controller: TextEditingController(text: state.user.fullName),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Hủy'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(tempName),
                                child: const Text('Lưu'),
                              ),
                            ],
                          );
                        },
                      );
                      if (newName != null && newName.trim().isNotEmpty) {
                        context.read<UserInfoCubit>().updateFullName(newName.trim());
                      }
                    },
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Họ và Tên: ${user.fullName}',
                        style: const TextStyle(fontSize: 18)),
                    Text('Email: ${user.username}',
                        style: const TextStyle(fontSize: 18)),
                    if (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
                      Image.network(user.avatarUrl!),
                    const SizedBox(height: 16),
                    const Text(
                      'Thể loại yêu thích:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: BlocBuilder<GenreCubit, GenreState>(
                        builder: (context, genreState) {
                          if (genreState is GenreLoading || genreState is GenreInitial) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (genreState is GenreLoaded) {
                            final genres = genreState.genres;
                            if (genres.isEmpty) {
                              return const Center(child: Text('Không có thể loại nào.'));
                            }
                            return ListView.builder(
                              itemCount: genres.length,
                              itemBuilder: (context, index) {
                                final genre = genres[index];
                                final isSelected = tempFavoriteGenres.contains(genre);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      isSelected ? Colors.blue : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (isSelected) {
                                          tempFavoriteGenres.remove(genre);
                                        } else {
                                          tempFavoriteGenres.add(genre);
                                        }
                                      });
                                    },
                                    child: Text(
                                      genre,
                                      style: TextStyle(
                                        color:
                                        isSelected ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else if (genreState is GenreError) {
                            return Center(child: Text(genreState.message));
                          }
                          return const SizedBox.shrink();
                        },
                      ),
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
