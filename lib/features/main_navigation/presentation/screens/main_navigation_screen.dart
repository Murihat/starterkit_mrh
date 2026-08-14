import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/app_router.dart';
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
