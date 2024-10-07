import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class MoviesSlideshow extends StatelessWidget {
  final List<Movie> movies;
  const MoviesSlideshow({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final swipperController = SwiperController();
    return SizedBox(
      width: double.infinity,
      height: 210,
      child: Swiper(
        autoplay: true,
        autoplayDelay: 2000,
        viewportFraction: 0.8,
        scale: 0.9,
        controller: swipperController,
        pagination: SwiperPagination(
          margin: const EdgeInsets.only(bottom: 0),
          builder: DotSwiperPaginationBuilder(
            activeColor: colors.primary,
            color: colors.secondary,
          ),
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) => _Slide(movie: movies[index]),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;
  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Colors.black45, blurRadius: 10, offset: Offset(0, 10))
        ]);

    return FractionallySizedBox(
      widthFactor: 1,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(bottom: 30),
        child: DecoratedBox(
          decoration: decoration,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    movie.backdropPath,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      // if (loadingProgress != null) {
                      //   return const DecoratedBox(
                      //     decoration: BoxDecoration(color: Colors.black38),
                      //     child: Align(
                      //       child: SizedBox(
                      //         width: 18,
                      //         height: 18,
                      //         child: CircularProgressIndicator(
                      //             color: Colors.white, strokeWidth: 1),
                      //       ),
                      //     ),
                      //   );
                      // }
                      return FadeIn(
                        child: child,
                      );
                    },
                  ),
                  Positioned(
                      left: 10,
                      bottom: 15,
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(140, 0, 0, 0),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            movie.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ))),
                  Positioned(
                    right: 10,
                    bottom: 15,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(140, 0, 0, 0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.star,
                                color: Colors.amber[300],
                                size: 16,
                              ),
                            ),
                            TextSpan(
                              text:
                                  " ${movie.voteAverage.toStringAsPrecision(2)}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
