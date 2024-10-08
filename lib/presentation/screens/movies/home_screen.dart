import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/wigets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  static const name = "home-screen";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();
    // Tengo acceso al ref porque estoy dentro de un ConsumerState, no hace falta el build(context,ref)
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final slideShowNowPlayingMovies = ref.watch(moviesSlideShowProvider);

    if (slideShowNowPlayingMovies.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SizedBox.expand(
      child: Column(
        children: [
          const CustomAppbar(),
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
          // MoviesSlideshow(movies: nowPlayingMovies.sublist(0, 6))
          MoviesSlideshow(movies: slideShowNowPlayingMovies)
        ],
      ),
    );
  }
}
