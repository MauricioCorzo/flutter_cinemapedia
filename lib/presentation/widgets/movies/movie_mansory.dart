import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'movie_poster_link.dart';

class MovieMasonry extends StatefulWidget {
  final List<Movie> movies;
  final void Function()? loadNextPage;

  const MovieMasonry({
    required this.movies,
    this.loadNextPage,
    super.key,
  });

  @override
  State<MovieMasonry> createState() => _MovieMasonryState();
}

class _MovieMasonryState extends State<MovieMasonry> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;

      if (scrollController.position.pixels + 200 >=
          scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      // child: GridViewCustomWidget(),
      child: MasonryGridView.count(
        controller: scrollController,

        // physics: const BouncingScrollPhysics(),
        itemCount: widget.movies.length,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        crossAxisCount: 3, // cantidad de columnas

        itemBuilder: (context, index) {
          final movie = widget.movies[index];
          if (index == 1) {
            return Column(
              children: [
                const SizedBox(height: 40),
                MoviePosterLink(movie: movie),
              ],
            );
          }
          return MoviePosterLink(movie: movie);
        },
      ),
    );
  }
}

class GridViewCustomWidget extends StatelessWidget {
  const GridViewCustomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.custom(
      shrinkWrap: true,
      gridDelegate: SliverQuiltedGridDelegate(
        crossAxisCount: 4,
        mainAxisSpacing: 15.0,
        crossAxisSpacing: 15.0,
        repeatPattern: QuiltedGridRepeatPattern.inverted,
        pattern: const [
          QuiltedGridTile(2, 2),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 2),
        ],
      ),
      childrenDelegate: SliverChildBuilderDelegate(
        (context, index) => Tile(index: index),
        childCount: colors.length, // Ensure it matches the number of tiles
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final int index;

  const Tile({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors[index],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Tile $index',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

const List<Color> colors = [
  Color(0xffC75B7A), // Midnight Blue
  Color(0xFF333333), // Charcoal
  Color(0xFF2F4F4F), // Dark Slate Gray
  Color(0xFFD9ABAB), // Crimson
  Color(0xFF4682B4), // Steel Blue
  Color(0xffe7e8d83), // Olive Drab
  Color(0xFFAF8260), // Dim Gray
  Color(0xFFB22222), // Firebrick
  Color(0xFF708090), // Slate Gray
  Color(0xFF2E8B57),
];
