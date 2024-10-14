import 'package:flutter/material.dart';

final messages = [
  "Just a sec, we're rolling out the red carpet.",
  "Hold on, the director is saying 'Action!'",
  "Pop some popcorn, almost there!",
  "Setting the scene, hang tight!",
  "Cue the dramatic music... 🎬",
  "Just a moment, we're in post-production.",
  "Hold your horses, the show is about to start!",
  "The plot thickens, just a bit more!",
  "Ready for the premiere? Just a moment!",
  "Don't go anywhere, the sequel is coming up!",
];

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessages() {
    return Stream.periodic(
      const Duration(milliseconds: 3000),
      (computationCount) => messages[computationCount],
    ).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder(
          stream: getLoadingMessages(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("Wait a moment please", style: textStyle.bodyLarge);
            }

            return Text(
              snapshot.data!,
              style: textStyle.bodyLarge,
              textAlign: TextAlign.center,
            );
          },
        ),
        const SizedBox(height: 50),
        const CircularProgressIndicator(strokeWidth: 2),
        const SizedBox(height: 50),
        Text("Loading...", style: textStyle.bodyMedium),
      ],
    );
  }
}
