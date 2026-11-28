import 'package:flutter/material.dart';
import 'package:flutterproject/screens/explore_screen.dart';
import 'package:flutterproject/screens/post_screen.dart';
import 'package:flutterproject/screens/profile_screen.dart';
import 'package:flutterproject/store/app_store.dart';

class MainShell extends StatefulWidget {
  final AppStore store;

  const MainShell({super.key, required this.store});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tabIndex = 1; // 0: Profile, 1: Explore, 2: Post

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      ProfileScreen(store: widget.store, onChanged: _refresh),
      ExploreScreen(store: widget.store, onChanged: _refresh),
      PostScreen(
        store: widget.store,
        onPosted: () {
          setState(() {
            _tabIndex = 1;
          });
        },
      ),
    ];

    return Scaffold(
      body: pages[_tabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (index) {
          setState(() {
            _tabIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Post'),
        ],
      ),
    );
  }
}