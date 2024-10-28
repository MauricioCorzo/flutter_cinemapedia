import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:cinemapedia/presentation/views/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: "/",
  routes: [
    // GoRoute(
    //     path: "/",
    //     name: HomeScreen.name,
    //     pageBuilder: (context, state) {
    //       //Custom page transition example
    //       return cupertinolikePageTransition(
    //         child: const HomeScreen(
    //           childView: HomeView(),
    //         ),
    //       );
    //     },
    //     routes: [
    //       GoRoute(
    //         path: "movie/:id",
    //         name: MovieScreen.name,
    //         pageBuilder: (context, state) {
    //           //Custom page transition example
    //           return cupertinolikePageTransition(
    //             child: MovieScreen(
    //               movieId: state.pathParameters["id"] ?? "no-id",
    //             ),
    //           );
    //         },
    //       ),
    //     ]),

    StatefulShellRoute.indexedStack(
      builder: (context, state, statefulNavigationShell) {
        return HomeScreen(childView: statefulNavigationShell);
      },
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/",
            pageBuilder: (context, state) {
              return cupertinolikePageTransition(child: const HomeView());
            },

            //Si quiero mantener el BottomNavigationBar en esta pantalla
            //tengo que declararlo aqui y no afuera

            // routes: [
            // GoRoute(
            //   path: "movie/:id",
            //   name: MovieScreen.name,
            //   pageBuilder: (context, state) {
            //     //Custom page transition example
            //     return cupertinolikePageTransition(
            //       child: MovieScreen(
            //         movieId: state.pathParameters["id"] ?? "no-id",
            //       ),
            //     );
            //   },
            // ),
            // ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/categories",
            pageBuilder: (context, state) {
              return cupertinolikePageTransition(child: const CategoriesView());
            },
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/favorites",
            pageBuilder: (context, state) {
              return cupertinolikePageTransition(child: const FavoritesView());
            },
          ),
        ])
      ],
    ),
    GoRoute(
      path: "/movie/:id",
      name: MovieScreen.name,
      pageBuilder: (context, state) {
        //Custom page transition example
        return cupertinolikePageTransition(
          child: MovieScreen(
            movieId: state.pathParameters["id"] ?? "no-id",
          ),
        );
      },
    ),
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
