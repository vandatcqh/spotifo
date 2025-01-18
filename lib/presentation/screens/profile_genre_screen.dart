// presentation/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotifo/core/app_export.dart';

import '../common_widgets/custom_bottom_bar.dart';
import '../components/svg.dart';
import '../cubit/user/user_info_cubit.dart';
import '../cubit/genre/genre_cubit.dart';
import '../cubit/genre/genre_state.dart';
import '../util/hash_gradient.dart';
import 'sign_in_screen.dart';

import '../../../injection_container.dart';

class UserInfoGenreScreen extends StatefulWidget {
  const UserInfoGenreScreen({super.key});

  @override
  State<UserInfoGenreScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoGenreScreen> {
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
        appBar: AppBar(title: const Text('Interests')),
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
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: BlocBuilder<GenreCubit, GenreState>(
                        builder: (context, genreState) {
                          if (genreState is GenreLoading || genreState is GenreInitial) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (genreState is GenreLoaded) {
                            final genres = genreState.genres;
                            if (genres.isEmpty) {
                              return const Center(child: Text('No genre availables.'));
                            }
                            return ListView.builder(
                              itemCount: genres.length,
                              itemBuilder: (context, index) {
                                final genre = genres[index];
                                final isSelected = tempFavoriteGenres.contains(genre);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (isSelected) {
                                          tempFavoriteGenres.remove(genre);
                                        } else {
                                          tempFavoriteGenres.add(genre);
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12),
                                      decoration: BoxDecoration(
                                        gradient: isSelected ? generateHashGradient(genre) : LinearGradient(colors: [Colors.grey, Colors.grey]),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        genre,
                                        style: TextStyle(
                                          color: isSelected ? Colors.white : Colors.black,
                                        ),
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
                    const SizedBox(height: 8),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        context.read<UserInfoCubit>().updateFavoriteGenres(tempFavoriteGenres);
                      },
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 32,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 10,
                            children: [
                              SVG("assets/svgs/heroicons-solid/clipboard-document-check.svg", size: 24, color: colorTheme.primary),
                              Text("Save Favorite Genres", style: textTheme.titleMedium?.withColor(colorTheme.primary)),
                            ],
                          ),
                          SVG("assets/svgs/heroicons-solid/chevron-right.svg", size: 24, color: colorTheme.primary)
                        ],
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
        bottomNavigationBar: CustomBottomBar(type: CustomBottomBarType.profile),
      ),
    );
  }
}
