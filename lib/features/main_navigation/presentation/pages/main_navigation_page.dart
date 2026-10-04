import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/main_navigation_cubit.dart';
import '../screens/main_navigation_screen.dart';

class MainNavigationPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainNavigationPage({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainNavigationCubit(),
      child: MainNavigationScreen(navigationShell: navigationShell),
    );
  }
}
