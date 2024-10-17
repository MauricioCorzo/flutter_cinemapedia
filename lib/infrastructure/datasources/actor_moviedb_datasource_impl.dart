import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActorMoviedbDatasourceImpl extends ActorsDatasource {
  final _dio = Dio(BaseOptions(
      baseUrl: "https://api.themoviedb.org/3",
      headers: {
        "Authorization": Environment.movieDbBearerToken,
        'accept': 'application/json'
      },
      queryParameters: {
        'language': 'en-US'
      }));
  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final Response dioResponse = await _dio.get("/movie/$movieId/credits");

    final CreditsMovieDbResponse creditsMovieDbResponse =
        CreditsMovieDbResponse.fromJson(dioResponse.data);

    final List<Actor> actors = creditsMovieDbResponse.cast
        .map((cast) => ActorMapper.castToEntity(cast))
        .toList();

    return actors;
  }
}
