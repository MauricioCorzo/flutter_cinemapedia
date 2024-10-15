import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_number_formats.dart';
import 'package:cinemapedia/config/router/app_router.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';

class MovieHorizontalListview extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  final Future<void> Function()? loadNextPage;

  const MovieHorizontalListview(
      {super.key,
      required this.movies,
      this.title,
      this.subTitle,
      this.loadNextPage});

  @override
  State<MovieHorizontalListview> createState() =>
      _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {
  final scrollController = ScrollController();
  bool isFetchingMoreMovies = false;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() async {
      if (widget.loadNextPage == null) return;

      if (scrollController.position.pixels + 200 >=
          scrollController.position.maxScrollExtent) {
        if (isFetchingMoreMovies) return;

        isFetchingMoreMovies = true;

        await widget.loadNextPage!();

        isFetchingMoreMovies = false;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          if (widget.title != null || widget.subTitle != null)
            _Title(title: this.widget.title, subTitle: this.widget.subTitle),
          Expanded(
              child: ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            itemCount: widget.movies.length,
            itemBuilder: (context, index) {
              final slideWidget = _Slide(movie: widget.movies[index]);

              return scrollController.position.userScrollDirection ==
                      ScrollDirection.reverse
                  ? FadeInRight(child: slideWidget)
                  : FadeInLeft(
                      child: slideWidget,
                    );
            },
          )),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String? title;
  final String? subTitle;

  const _Title({this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleLarge;
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (title != null) Text(title!, style: textStyle),
          if (subTitle != null)
            FilledButton.tonal(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              onPressed: () {},
              child: Text(subTitle!),
            ),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;
  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // * Imagen
          SizedBox(
            width: 150,
            height: 210,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                width: 150,
                height: 210,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return const Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(strokeWidth: 2));
                  }
                  return GestureDetector(
                      onTap: () => context.push("/movie/${movie.id}"),
                      child: FadeIn(child: child));
                },
              ),
            ),
          ),
          const SizedBox(height: 5),

          // * Title
          SizedBox(
            width: 150,
            child: Text(
              movie.title,
              maxLines: 2,
              style: textStyles.titleSmall,
            ),
          ),

          // * Rating
          SizedBox(
            width: 150,
            child: Row(
              children: [
                Icon(
                  Icons.star_half_rounded,
                  color: Colors.yellow.shade800,
                ),
                const SizedBox(width: 3),
                Text(
                  movie.voteAverage.toStringAsPrecision(2),
                  style: textStyles.bodyMedium
                      ?.copyWith(color: Colors.yellow.shade800),
                ),
                const SizedBox(width: 10),
                const Spacer(),
                Text(
                  HumanNumberFormats.number(movie.popularity),
                  style: textStyles.bodyMedium,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
