import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar(
      backgroundColor: const Color(0xff202020),
      activeIndex: selectedIndex,
      icons: const [
        Icons.home,
        Icons.person,
      ],
      gapLocation: GapLocation.center,
      activeColor: Colors.blue,
      inactiveColor: Colors.white,
      notchSmoothness: NotchSmoothness.verySmoothEdge,
      onTap: onItemTapped,
    );
  }
}
