import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MoviedbDatasourceImpl implements MoviesDatasource {
  final _dio = Dio(BaseOptions(
      baseUrl: "https://api.themoviedb.org/3",
      queryParameters: {
        'api_key': Environment.movieDbApiKey,
        'language': 'en-US'
      }));

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final Response response = await _dio.get(
      "/movie/now_playing",
      queryParameters: {
        "page": page,
      },
    );

    final movieDbResponse = MovieDbResponse.fromJson(response.data);

    final List<Movie> movies = List.from(movieDbResponse.results
        .where((movieDb) => movieDb.posterPath != "no-poster")
        .map((movieDb) => MovieMapper.movieDBToEntity(movieDb)));

    return movies;
  }
}
