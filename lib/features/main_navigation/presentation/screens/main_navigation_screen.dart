import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/wrappers/theme/presentation/cubit/theme_cubit.dart';

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
      appBar: AppBar(title: const Text('Main Navigation')),
      body: Column(
        children: [
          const Center(child: Text('Main Navigation Content')),
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
    );
  }
}
