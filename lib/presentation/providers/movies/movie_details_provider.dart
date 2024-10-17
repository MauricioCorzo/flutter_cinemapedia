import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieDetailsProvider =
    StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
  final getMovieDetails = ref.watch(movieRepositroyProvider).getMovieById;

  return MovieMapNotifier(getMovieDetails: getMovieDetails);
});

/*
Map<String, Movie>
  {
    "505642" : Movie(),
    "505622" : Movie(),
    "745649" : Movie(),
    "816680" : Movie(),
  }
 */

typedef GetMovieDetailsCallback = Future<Movie> Function(String movieId);

class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  final GetMovieDetailsCallback getMovieDetails;

  MovieMapNotifier({required this.getMovieDetails}) : super({});

  Future<void> loadMovie(String movieId) async {
    if (state[movieId] != null) return;
    final movie = await getMovieDetails(movieId);

    state = {...state, movieId: movie};
  }
}
