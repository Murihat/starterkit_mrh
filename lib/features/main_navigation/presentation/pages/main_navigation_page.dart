import 'package:flutter/material.dart';

import '../screens/main_navigation_screen.dart';

class MainNavigationPage extends StatelessWidget {
  final Widget child;
  const MainNavigationPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MainNavigationScreen(child: child);
  }
}
