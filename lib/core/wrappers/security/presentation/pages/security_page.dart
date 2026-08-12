import 'package:flutter/material.dart';

import '../screens/security_screen.dart';

class SecurityPage extends StatelessWidget {
  final Widget child;

  const SecurityPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SecurityScreen(child: child);
  }
}
