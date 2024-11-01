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
