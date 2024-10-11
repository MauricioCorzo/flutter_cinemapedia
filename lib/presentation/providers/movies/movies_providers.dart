import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_respository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowPlayingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositroyProvider).getNowPlaying;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

typedef MovieCallback = Future<List<Movie>> Function({int page});

class MoviesNotifier extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  bool isFetchingMovies = false;

  MovieCallback fetchMoreMovies;

  MoviesNotifier({required this.fetchMoreMovies})
      : super([]); // No tengo Movies al inicio

  Future<void> loadNextPage() async {
    if (isFetchingMovies) return;

    isFetchingMovies = true;
    currentPage++;

    // await Future.delayed(const Duration(seconds: 2));
    final List<Movie> newMovies = await fetchMoreMovies(page: currentPage);

    state = [...state, ...newMovies];

    isFetchingMovies = false;
  }
}
