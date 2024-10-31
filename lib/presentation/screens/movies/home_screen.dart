import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  static const name = "home-screen";

  final StatefulNavigationShell childView;
  const HomeScreen({super.key, required this.childView});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: const HomeView(),
      // body: const Center(
      //   child: Text("Hola Mundo"),
      // ),
      body: childView,
      bottomNavigationBar:
          CustomBottomNavigationBar(currentIndex: childView.currentIndex),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  // int getCurrentIndex(BuildContext context) {
  //   final location = GoRouterState.of(context).fullPath;

  //   switch (location) {
  //     case "/":
  //       return 0;
  //     case "/categories":
  //       return 1;
  //     case "/favorites":
  //       return 2;
  //     default:
  //       return 0;
  //   }
  // }

  void onItemTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go("/");
        break;
      case 1:
        context.go("/categories");
        break;
      case 2:
        context.go("/favorites");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (iconIndex) {
        return onItemTap(context, iconIndex);
      },
      currentIndex: this.currentIndex,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_max), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.label_outline), label: "Categories"),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline), label: "Favorites"),
      ],
    );
  }
}
