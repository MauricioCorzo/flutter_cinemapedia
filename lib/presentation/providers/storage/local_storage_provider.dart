import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/infrastructure/datasources/isar_datasource_impl.dart';
import 'package:cinemapedia/infrastructure/respositories/local_storage_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localStorageRepositoryProvider = Provider(
    (ref) => LocalStorageRepositoryImpl(datasource: IsarDatasourceImpl()));

//  https://riverpod.dev/es/docs/essentials/auto_dispose
//  Riverpod recomendation
//  When providers receive parameters, it is recommended to enable automatic disposal.
//  That is because otherwise, one state per parameter combination will be created, which can lead to memory leaks.
final isFavoriteMovieProvider =
    FutureProvider.autoDispose.family((ref, int movieId) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);

  return localStorageRepository.isMovieFavorite(movieId);
});

final favoriteMoviesProvider =
    StateNotifierProvider<StorageMoviesNotifier, Map<int, Movie>>((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return StorageMoviesNotifier(localStorageRepository: localStorageRepository);
});
/*
    {
      1234: Movie(),
      5612: Movie(),
      8615: Movie(),
    } 
 */

class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  final LocalStorageRepository localStorageRepository;
  int page = 0;

  StorageMoviesNotifier({required this.localStorageRepository}) : super({});

  Future<void> loadNextFavoritesMoviesOffset() async {
    final movies = await localStorageRepository.loadMovies(offset: page * 10);
    page++;

    final moviesMap = <int, Movie>{};
    for (final movie in movies) {
      moviesMap[movie.id] = movie;
    }
    state = {...state, ...moviesMap};

    return;
  }
}
