import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: "/",
      name: HomeScreen.name,
      pageBuilder: (context, state) {
        //Custom page transition example
        return cupertinolikePageTransition(child: const HomeScreen());
      },
    )
  ],
);

CustomTransitionPage<dynamic> cupertinolikePageTransition(
    {required Widget child}) {
  return CustomTransitionPage(
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      });
}
