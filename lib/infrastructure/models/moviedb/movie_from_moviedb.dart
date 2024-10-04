class MovieFromMovieDb {
  final bool adult;
  final String backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final DateTime releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  MovieFromMovieDb({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory MovieFromMovieDb.fromJson(Map<String, dynamic> json) =>
      MovieFromMovieDb(
        adult: json["adult"] ?? false,
        backdropPath: json["backdrop_path"] ?? "",
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"] ?? "",
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"] ?? "",
        releaseDate: DateTime.parse(json["release_date"]),
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
        "adult": this.adult,
        "backdrop_path": this.backdropPath,
        "genre_ids": List<dynamic>.from(this.genreIds.map((x) => x)),
        "id": this.id,
        "original_language": this.originalLanguage,
        "original_title": this.originalTitle,
        "overview": this.overview,
        "popularity": this.popularity,
        "poster_path": this.posterPath,
        "release_date":
            "${this.releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "title": this.title,
        "video": this.video,
        "vote_average": this.voteAverage,
        "vote_count": this.voteCount,
      };
}
