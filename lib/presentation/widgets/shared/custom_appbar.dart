import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            Icon(Icons.movie_creation_outlined,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 5),
            Text("CinemaPedia", style: titleStyle),
            const Spacer(),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.search_outlined))
          ],
        ),
      ),
    );
  }
}
