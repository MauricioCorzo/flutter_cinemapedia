import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatasourceImpl extends LocalStorageDatasource {
  late Future<Isar> db;

  IsarDatasourceImpl() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();

      return await Isar.open(
        [MovieSchema],
        directory: dir.path,
        inspector: true,
      );
    }

    return Future.value(Isar.getInstance());
  }

  @override
  Future<bool> isMovieFavorite(int movieId) async {
    final isar = await db;

    final movie =
        await isar.collection<Movie>().filter().idEqualTo(movieId).findFirst();

    return movie != null;
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, int offset = 0}) async {
    final isar = await db;

    final movies = await isar
        .collection<Movie>()
        .where()
        .offset(offset)
        .limit(limit)
        .findAll();

    return movies;
  }

  @override
  Future<void> toggleFavorite(Movie movie) async {
    final isar = await db;

    final favoriteMovie =
        await isar.collection<Movie>().filter().idEqualTo(movie.id).findFirst();

    if (favoriteMovie != null) {
      //Delete
      await isar.writeTxn(() async =>
          await isar.collection<Movie>().delete(favoriteMovie.issarId!));
      return;
    }
    //Insert
    await isar.writeTxn(() async => await isar.collection<Movie>().put(movie));
  }
}
