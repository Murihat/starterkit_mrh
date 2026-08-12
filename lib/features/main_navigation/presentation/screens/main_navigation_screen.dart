import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/app_router.dart';
import '../../../../core/wrappers/theme/presentation/cubit/theme_cubit.dart';
import '../cubit/main_navigation_cubit.dart';

class MainNavigationScreen extends StatefulWidget {
  final Widget child;

  const MainNavigationScreen({super.key, required this.child});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StarterKit MRH'),
        actions: [
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return IconButton(
                tooltip: state.isDark
                    ? 'Switch to light mode'
                    : 'Switch to dark mode',
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Icon(
                    state.isDark
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                    key: ValueKey(state.isDark),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: widget.child,
      bottomNavigationBar:
          BlocBuilder<MainNavigationCubit, MainNavigationState>(
            builder: (context, state) {
              return NavigationBar(
                selectedIndex: state.index,
                onDestinationSelected: (index) {
                  context.read<MainNavigationCubit>().changeIndex(index);

                  switch (index) {
                    case 0:
                      context.goNamed(AppRouteName.home);
                      break;

                    case 1:
                      context.goNamed(AppRouteName.account);
                      break;
                  }
                },
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home_rounded),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person_outline_rounded),
                    selectedIcon: Icon(Icons.person_rounded),
                    label: 'Account',
                  ),
                ],
              );
            },
          ),
    );
  }
}
