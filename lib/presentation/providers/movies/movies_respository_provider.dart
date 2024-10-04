import 'package:cinemapedia/infrastructure/datasources/moviedb_datasource_impl.dart';
import 'package:cinemapedia/infrastructure/respositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Provider de solo lectura, repositorio inmutable
final movieRepositroyProvider =
    Provider((ref) => MovieRepositoryImpl(dataSource: MoviedbDatasourceImpl()));
