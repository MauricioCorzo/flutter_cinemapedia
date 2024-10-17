import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';

class ActorMapper {
  static Actor castToEntity(Cast cast) => Actor(
        id: cast.id,
        name: cast.name,
        profilePath: cast.profilePath != null
            ? "https://image.tmdb.org/t/p/w500/${cast.profilePath}"
            : "https://assets.mycast.io/actor_images/actor-no-actor-718054_large.jpg?1679825161",
        character: cast.character,
      );
}
