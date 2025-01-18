import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:spotifo/presentation/util/hash_gradient.dart';
import '../../../theme/theme_helper.dart';
import '../../cubit/user/user_info_cubit.dart';
import '../../cubit/genre/genre_cubit.dart';
import '../../cubit/genre/genre_state.dart';
import '../home_screen/home_screen.dart';
import '../../common_widgets/custom_elevated_button.dart';
import '../../../../injection_container.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  List<String> tempFavoriteGenres = [];

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
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
          backgroundColor: Colors.orange.shade50,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            title: const Text(
              "What is your preference?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: BlocConsumer<UserInfoCubit, UserInfoState>(
            listener: (context, state) {
              if (state is UserInfoNotAuthenticated) {
                Navigator.of(context).pop();
              } else if (state is UserInfoFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              } else if (state is UserInfoLoaded) {
                tempFavoriteGenres =
                    List<String>.from(state.user.favoriteGenres);
              }
            },
            builder: (context, state) {
              if (state is UserInfoLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is UserInfoLoaded) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 20.0,
                    ),
                    decoration: BoxDecoration(
                      color: colorTheme.onSurface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3), // Shadow position
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "What are your favourite genres?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Please pick three",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        BlocBuilder<GenreCubit, GenreState>(
                          builder: (context, genreState) {
                            if (genreState is GenreLoading ||
                                genreState is GenreInitial) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (genreState is GenreLoaded) {
                              final genres = genreState
                                  .genres; // True genres from the state
                              if (genres.isEmpty) {
                                return const Center(
                                    child: Text('No genres available.'));
                              }

                              // Define a map of decorations for selected genres
                              final decorations = {
                                'POP': "Pop",
                                'ROCK': "Rock",
                                'BLUE': "Blue",
                                'VIETNAM': "Vietnam",
                                'JAZZ': "Jazz",
                                'COUNTRY': "Country",
                                'CLASSICAL': "Classical",
                                'HIP HOP': "Hip Hop",
                                'FUNK': "Funk",
                              };

                              return Center(
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing:
                                      4.w, // Horizontal spacing between items
                                  runSpacing:
                                      2.h, // Vertical spacing between rows
                                  children: genres.map((genre) {
                                    final isSelected = tempFavoriteGenres
                                        .contains(genre.toUpperCase());
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (isSelected) {
                                            tempFavoriteGenres
                                                .remove(genre.toUpperCase());
                                          } else {
                                            if (tempFavoriteGenres.length < 3) {
                                              tempFavoriteGenres
                                                  .add(genre.toUpperCase());
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'You can only select up to 3 genres.'),
                                                ),
                                              );
                                            }
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: 8
                                            .h, // Adjusted height for bigger size
                                        width: 20.w, // Approx. 4 items per row
                                        decoration: isSelected
                                            ? BoxDecoration(
                                                gradient: generateHashGradient(
                                                    decorations[
                                                        genre.toUpperCase()]!),
                                                borderRadius:
                                                    BorderRadius.circular(2.h))
                                            : BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(2.h),
                                              ),
                                        child: Center(
                                          child: Text(
                                            genre.toUpperCase(),
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            } else if (genreState is GenreError) {
                              return Center(child: Text(genreState.message));
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        SizedBox(height: 10.h),
                        Center(
                          child: CustomElevatedButton(
                            text: "Next",
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: tempFavoriteGenres.length < 3
                                  ? Colors.grey.shade300
                                  : Colors.orange,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            buttonStyle: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                            buttonTextStyle: TextStyle(
                              color: tempFavoriteGenres.length < 3
                                  ? Colors.grey
                                  : Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            onPressed: tempFavoriteGenres.length < 3
                                ? null
                                : () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) => HomeScreen(),
                                      ),
                                    );
                                  },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is UserInfoFailure) {
                return const Center(child: Text('Failed to load user info.'));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });
  }
}
