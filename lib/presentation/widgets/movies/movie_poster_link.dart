import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoviePosterLink extends StatelessWidget {
  final Movie movie;
  const MoviePosterLink({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push("/movie/${movie.id}");
      },
      child: FadeInUp(
        child: SizedBox(
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              height: 200,
              fit: BoxFit.cover,
              movie.posterPath,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return FadeIn(child: child);
                }
                return const SizedBox(
                  height: 200,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
