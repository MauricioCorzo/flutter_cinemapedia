import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';

class MovieRepositoryImpl implements MoviesRepository {
  final MoviesDatasource dataSource;

  MovieRepositoryImpl({required this.dataSource});

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return this.dataSource.getNowPlaying(page: page);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) {
    return this.dataSource.getPopular(page: page);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) {
    return this.dataSource.getUpcoming(page: page);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) {
    return this.dataSource.getTopRated(page: page);
  }

  @override
  Future<Movie> getMovieById(String movieId) {
    return this.dataSource.getMovieById(movieId);
  }

  @override
  Future<List<Movie>> searchMovies(String querySearch) {
    return this.dataSource.searchMovies(querySearch);
  }
}
