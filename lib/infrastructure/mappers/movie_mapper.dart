import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_from_moviedb.dart';

class MovieMapper {
  static Movie movieDBToEntity(MovieFromMovieDb movieFromMovieDb) {
    return Movie(
      adult: movieFromMovieDb.adult,
      backdropPath: movieFromMovieDb.backdropPath.isNotEmpty
          ? "https://image.tmdb.org/t/p/w500/${movieFromMovieDb.backdropPath}"
          : "https://th.bing.com/th/id/OIP.ZdUQAnmWS5XuXyJ9S9UJpwHaHa?rs=1&pid=ImgDetMain",
      genreIds:
          movieFromMovieDb.genreIds.map((genre) => genre.toString()).toList(),
      id: movieFromMovieDb.id,
      originalLanguage: movieFromMovieDb.originalLanguage,
      originalTitle: movieFromMovieDb.originalTitle,
      overview: movieFromMovieDb.overview,
      popularity: movieFromMovieDb.popularity,
      posterPath: movieFromMovieDb.posterPath.isNotEmpty
          ? "https://image.tmdb.org/t/p/w500/${movieFromMovieDb.posterPath}"
          : "no-poster",
      releaseDate: movieFromMovieDb.releaseDate,
      title: movieFromMovieDb.title,
      video: movieFromMovieDb.video,
      voteAverage: movieFromMovieDb.voteAverage,
      voteCount: movieFromMovieDb.voteCount,
    );
  }
}
