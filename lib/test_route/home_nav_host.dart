import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeNavHost extends StatelessWidget {
  const HomeNavHost({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        // onTap: (index) => navigationShell.goBranch(
        //   index,
        //   initialLocation: index == navigationShell.currentIndex,
        // ),
        onTap: (index) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
