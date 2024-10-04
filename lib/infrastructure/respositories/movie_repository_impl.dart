import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movies_repositiry.dart';

class MovieRepositoryImpl implements MoviesRepository {
  final MoviesDatasource dataSource;

  MovieRepositoryImpl({required this.dataSource});
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return this.dataSource.getNowPlaying(page: page);
  }
}
