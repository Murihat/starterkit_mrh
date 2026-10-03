import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/main_navigation_cubit.dart';
import '../screens/main_navigation_screen.dart';

class MainNavigationPage extends StatelessWidget {
  final Widget child;
  const MainNavigationPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainNavigationCubit(),
      child: MainNavigationScreen(child: child),
    );
  }
}
