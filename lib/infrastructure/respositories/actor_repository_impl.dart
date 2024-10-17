import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/repositories/actors_repository.dart';

class ActorRepositoryImpl extends ActorsRepository {
  final ActorsDatasource dataSource;

  ActorRepositoryImpl({required this.dataSource});

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) {
    return this.dataSource.getActorsByMovie(movieId);
  }
}
