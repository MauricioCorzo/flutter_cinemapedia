import 'package:cinemapedia/infrastructure/datasources/actor_moviedb_datasource_impl.dart';
import 'package:cinemapedia/infrastructure/respositories/actor_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsRepositoryProvider = Provider(
    (ref) => ActorRepositoryImpl(dataSource: ActorMoviedbDatasourceImpl()));
