import 'package:cinemapedia/config/helpers/date_formats.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/wigets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    // Tengo acceso al ref porque estoy dentro de un ConsumerState, no hace falta el build(context,ref)
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();

    ref.read(popularMoviesProvider.notifier).loadNextPage();

    ref.read(upcomingMoviesProvider.notifier).loadNextPage();

    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(initialLoadingProvider);

    if (initialLoading) {
      return const Center(
        child: FullScreenLoader(),
      );
    }

    // final slideShowNowPlayingMovies = ref.watch(moviesSlideShowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);

    // if (slideShowNowPlayingMovies.isEmpty) {
    // return const Center(
    //   child: FullScreenLoader(),
    // );
    // }

    return SizedBox.expand(
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
            // forceMaterialTransparency: true,

            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              centerTitle: false,
              title: CustomAppbar(),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
              children: [
                // const CustomAppbar(),
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: nowPlayingMovies.length,
                //     itemBuilder: (context, index) {
                //       final movie = nowPlayingMovies[index];
                //       return ListTile(
                //         title: Text(movie.title),
                //       );
                //     },
                //   ),
                // )
                MoviesSlideshow(movies: nowPlayingMovies.sublist(0, 6)),
                // MoviesSlideshow(movies: slideShowNowPlayingMovies),

                MovieHorizontalListview(
                  movies: nowPlayingMovies,
                  title: "In theatres",
                  subTitle:
                      // "${CustomDateFormatter.date("dd/MM", DateTime.parse("2024-09-04"))} - ${CustomDateFormatter.date("dd/MM", DateTime.parse("2024-10-16"))}",
                      "${DateTime.now().monthDaySuffixYear}",
                  loadNextPage: () => ref
                      .read(nowPlayingMoviesProvider.notifier)
                      .loadNextPage(),
                ),

                MovieHorizontalListview(
                  movies: popularMovies,
                  title: "Popular",
                  // subTitle: "Lunes 20",
                  loadNextPage: () =>
                      ref.read(popularMoviesProvider.notifier).loadNextPage(),
                ),

                MovieHorizontalListview(
                  movies: upcomingMovies,
                  title: "Upcoming",
                  subTitle: "This month",
                  loadNextPage: () =>
                      ref.read(upcomingMoviesProvider.notifier).loadNextPage(),
                ),

                MovieHorizontalListview(
                  movies: topRatedMovies,
                  title: "Top Rated",
                  subTitle: "From always",
                  loadNextPage: () =>
                      ref.read(topRatedMoviesProvider.notifier).loadNextPage(),
                ),

                const SizedBox(
                  height: 20,
                )
              ],
            );
          }, childCount: 1))
        ],
      ),
    );
  }
}
