import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_number_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMovieCallback = Future<List<Movie>> Function(String querySearch);

class SearchMoviesDelegate extends SearchDelegate<Movie?> {
  final SearchMovieCallback searchMovies;
  List<Movie> initialData;

  StreamController<List<Movie>> debounceMoviesStrem =
      StreamController.broadcast();

  StreamController<bool> isLoadingStream = StreamController.broadcast();

  Timer? _debounceTimer;

  String? debouncedSearchQuery;

  SearchMoviesDelegate({
    required this.searchMovies,
    required this.initialData,
  });

  void clearStreams() {
    debounceMoviesStrem.close();
    isLoadingStream.close();
    _debounceTimer?.cancel();
  }

// Debounce manual en Dart
  void _onQueryChange(String query) {
    if (query.isEmpty) {
      isLoadingStream.add(false);
    } else {
      isLoadingStream.add(true);
    }
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (debouncedSearchQuery == query) return;

      debouncedSearchQuery = query;

      final movies = await searchMovies(query);
      debounceMoviesStrem.add(movies);

      initialData = movies;
      isLoadingStream.add(false);
    });
  }

  Widget buildResultsAndSuggestions() {
    return StreamBuilder<List<Movie>>(
      initialData: this.initialData,
      stream: debounceMoviesStrem.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return _MovieItem(
                movie: movies[index],
                onMovieSelected: (context, movie) {
                  clearStreams();
                  close(context, movie);
                });
          },
        );
      },
    );
  }

  @override
  String? get searchFieldLabel => "Search movie";

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        // SearchDelegate native metodh close(), second argument is what I wanna return after close
        // onPressed: () => close(context, null),
        onPressed: () {
          clearStreams();
          Navigator.of(context).pop();
        }, // Native go back
        // onPressed: () => context.pop(), // GoRouter go back
        icon: const Icon(Icons.arrow_back_ios_new_rounded));
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    // el query ya lo tenemos disponible dentro de SearchDelegate
    return [
      StreamBuilder<bool>(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!) {
            return FadeInRight(
              child: SpinPerfect(
                  // same if() but for show with animation
                  infinite: true,
                  duration: const Duration(milliseconds: 2000),
                  child: IconButton(
                      onPressed: () => query = "",
                      icon: const Icon(Icons.refresh_rounded))),
            );
          }
          // if (query.isNotEmpty)
          return FadeInRight(
              animate:
                  query.isNotEmpty, // same if() but for show with animation
              duration: const Duration(milliseconds: 250),
              child: IconButton(
                  onPressed: () => query = "", icon: const Icon(Icons.clear)));
        },
      ),
    ];
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChange(query);

    return buildResultsAndSuggestions();
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final void Function(BuildContext context, Movie movie) onMovieSelected;

  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Image

            SizedBox(
              width: size.width * 0.2,
              height: 130,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    height: 130,
                    fit: BoxFit.cover,
                    movie.posterPath != "no-poster"
                        ? movie.posterPath
                        : "https://th.bing.com/th/id/OIP.qnfdahew4LmC74fcBgKnRgAAAA?rs=1&pid=ImgDetMain",
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress != null) {
                        return const Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ));
                      }

                      return FadeIn(child: child);
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            //Description

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyle.titleMedium),
                  (movie.overview.length > 130)
                      ? Text('${movie.overview.substring(0, 130)}...')
                      : Text(movie.overview),

                  //Rating
                  Row(children: [
                    Icon(Icons.star_half_outlined,
                        color: Colors.yellow.shade800),
                    const SizedBox(width: 5),
                    Text(
                      HumanNumberFormats.number(movie.voteAverage, 1),
                      style: textStyle.bodyMedium
                          ?.copyWith(color: Colors.yellow.shade900),
                    )
                  ])
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
