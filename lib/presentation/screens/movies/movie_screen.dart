import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = "movie-screen";

  final String movieId;

  const MovieScreen({
    super.key,
    required this.movieId,
  });

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(movieDetailsProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movieDetails = ref.watch(movieDetailsProvider)[widget.movieId];

    if (movieDetails == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(
            movieTitle: movieDetails.title,
            moviePosterPath: movieDetails.posterPath,
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) => _MovieDetails(
              movieDetails: movieDetails,
            ),
            childCount: 1,
          ))
        ],
      ),
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final String movieTitle;
  final String moviePosterPath;
  const _CustomSliverAppBar({
    required this.movieTitle,
    required this.moviePosterPath,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: MediaQuery.of(context).size.height * 0.7,
      foregroundColor: Colors.white, //Color for text and icons
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        centerTitle: false,
        // title: Text(
        //   movieTitle,
        //   style: const TextStyle(fontSize: 20, color: Colors.white),
        // ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black45],
                    stops: [0.7, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
              ),
              child: Image.network(
                moviePosterPath,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return const Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ));
                  }
                  return FadeIn(child: child);
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.black, Colors.transparent],
                    stops: [0.0, 0.2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movieDetails;
  const _MovieDetails({required this.movieDetails});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeIn(
                  child: Image.network(
                    movieDetails.backdropPath,
                    width: size.width * 0.35,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movieDetails.title, style: textStyles.titleLarge),
                    Text(movieDetails.overview),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            spacing: 10,
            children: [
              ...movieDetails.genreIds.map((genre) => Chip(
                    label: Text(genre),
                    elevation: 5,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  )),
            ],
          ),
        ),
        SizedBox(
            height: 300,
            child: _ActorsByMovie(movieId: movieDetails.id.toString())),
        const SizedBox(height: 20)
      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;
  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ScrollController();
    final actorsByMovie = ref.watch(actorsByMovieProvider)[movieId];

    if (actorsByMovie == null) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    return ListView.builder(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: actorsByMovie.length,
      itemBuilder: (context, index) {
        final actor = actorsByMovie[index];

        final actorWidget = Container(
          width: 150,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  actor.profilePath,
                  width: 135,
                  height: 200,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress != null) {
                      return const SizedBox(
                        height: 200,
                        child: Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    }
                    return child;
                  },
                ),
              ),
              const SizedBox(height: 5),
              Text(
                actor.name,
                maxLines: 2,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                actor.character ?? "",
                maxLines: 2,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );

        return scrollController.position.userScrollDirection ==
                ScrollDirection.reverse
            ? FadeInRight(child: actorWidget)
            : FadeInLeft(
                child: actorWidget,
              );
      },
    );
  }
}
