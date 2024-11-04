import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/wigets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {
  bool isLastPage = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    ref.read(favoriteMoviesProvider.notifier).loadNextFavoritesMoviesOffset();
  }

  Future<void> loadFavoritesNextPage() async {
    if (isLoading || isLastPage) return;

    isLoading = true;
    final movies = await ref
        .read(favoriteMoviesProvider.notifier)
        .loadNextFavoritesMoviesOffset();
    isLoading = false;

    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = ref.watch(favoriteMoviesProvider).values.toList();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Favorites View"),
        ),
        body: MovieMasonry(
          movies: favoriteMovies,
          loadNextPage: loadFavoritesNextPage,
        ));
  }
}
