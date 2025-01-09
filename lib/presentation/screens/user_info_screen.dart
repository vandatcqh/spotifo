// presentation/screens/user_info_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/user/user_info_cubit.dart';
import '../cubit/genre/genre_cubit.dart';
import '../cubit/genre/genre_state.dart';
import 'sign_in_screen.dart';

import '../../../injection_container.dart';

class UserInfoScreen extends StatelessWidget {
  UserInfoScreen({Key? key}) : super(key: key);

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
            }
          },
          builder: (context, state) {
            if (state is UserInfoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserInfoLoaded) {
              final user = state.user;
              final favoriteGenres = user.favoriteGenres;

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
                                final isSelected = favoriteGenres.contains(genre);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      isSelected ? Colors.blue : Colors.grey,
                                    ),
                                    onPressed: () {
                                      context.read<UserInfoCubit>().toggleFavoriteGenre(genre);
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
