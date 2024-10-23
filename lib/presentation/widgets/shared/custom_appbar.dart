import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/delegates/search_movies_delegate.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            Icon(Icons.movie_creation_outlined,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 5),
            Text("CinemaPedia", style: titleStyle),
            const Spacer(),
            IconButton(
                onPressed: () {
                  final movieRepository = ref.read(movieRepositroyProvider);
                  showSearch<Movie?>(
                    context: context,
                    delegate: SearchMoviesDelegate(
                        searchMovies: movieRepository.searchMovies),
                  ).then((movie) {
                    if (movie == null || !context.mounted) return;

                    context.push('/movie/${movie.id}');
                  });
                },
                icon: const Icon(
                  Icons.search_outlined,
                ))
          ],
        ),
      ),
    );
  }
}
