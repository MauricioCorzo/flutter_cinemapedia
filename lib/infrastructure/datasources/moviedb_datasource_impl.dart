import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
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

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final Response response = await _dio.get(
      "/movie/popular",
      queryParameters: {
        "page": page,
      },
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final Response response = await _dio.get(
      "/movie/upcoming",
      queryParameters: {
        "page": page,
      },
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final Response response = await _dio.get(
      "/movie/top_rated",
      queryParameters: {
        "page": page,
      },
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<Movie> getMovieById(String movieId) async {
    final Response response = await _dio.get(
      "/movie/$movieId",
    );

    if (response.statusCode != 200) {
      throw Exception("Movie with id: $movieId not found.");
    }

    final movieDb = MovieDetailsResponse.fromJson(response.data);
    return MovieMapper.detailsMovieDbToEntity(movieDb);
  }

  @override
  Future<List<Movie>> searchMovies(String querySearch) async {
    final Response dioResponse = await _dio.get(
      "/search/movie",
      queryParameters: {
        "query": querySearch,
      },
    );

    return _jsonToMovies(dioResponse.data);
  }
}

List<Movie> _jsonToMovies(Map<String, dynamic> json) {
  final movieDbResponse = MovieDbResponse.fromJson(json);

  final List<Movie> movies = List.from(movieDbResponse.results
      .where((movieDb) => movieDb.posterPath != "no-poster")
      .map((movieDb) => MovieMapper.movieDBToEntity(movieDb)));

  return movies;
}
