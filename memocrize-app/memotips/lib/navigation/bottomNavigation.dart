import 'package:floating_navbar/floating_navbar.dart';
import 'package:floating_navbar/floating_navbar_item.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:memotips/screens/collections.dart';
import 'package:memotips/screens/home.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      FloatingNavBar(
        resizeToAvoidBottomInset: false,
        color: Colors.white.withOpacity(0.1),
        selectedIconColor: Colors.white,
        index: 1,
        unselectedIconColor: Colors.white.withOpacity(0.6),
        items: [
          FloatingNavBarItem(
              iconData: LucideIcons.folders,
              page: Collections(),
              title: 'Collections'),
          FloatingNavBarItem(
              iconData: Icons.camera, page: Home(), title: 'Home'),
          FloatingNavBarItem(
              iconData: Icons.view_timeline, page: Home(), title: 'Memories'),
        ],
        horizontalPadding: 10.0,
        hapticFeedback: true,
      ),
    ]);
  }
}
