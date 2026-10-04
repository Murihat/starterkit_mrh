import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/main_navigation_cubit.dart';

class MainNavigationScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationScreen({super.key, required this.navigationShell});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  void _onTap(int index) {
    widget.navigationShell.goBranch(
      index,
      // Jika tab yang sama ditekan ulang, arahkan ke rute awal tab tersebut
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  // ini untuk tab yang aktif dan di klik ulang maka refresh kontennya, misal HomeBloc/HomeCubit di trigger fetch ulang
  // void _onTap(BuildContext context, int index) {
  //   final isSameTab = index == navigationShell.currentIndex;

  //   if (isSameTab) {
  //     // User klik tab yang SEDANG AKTIF -> trigger refresh
  //     _onReselectTab(context, index);
  //   } else {
  //     // Pindah ke tab yang dipilih
  //     navigationShell.goBranch(index, initialLocation: false);
  //   }
  // }

  // ini untuk tiap tab diklik refresh kontennya
  // void _onTap(BuildContext context, int index) {
  //   // 1. Pindah tab di GoRouter
  //   navigationShell.goBranch(index);

  //   // 2. Trigger fetch data sesuai tab yang dituju
  //   switch (index) {
  //     case 0:
  //       // context.read<HomeCubit>().fetchHomeData();
  //       break;
  //     case 1:
  //       // context.read<AccountCubit>().fetchProfile();
  //       break;
  //   }
  // }

  // void _onReselectTab(BuildContext context, int index) {
  //   if (index == 0) {
  //     // Trigger fetch ulang HomeBloc/HomeCubit
  //     // context.read<HomeBloc>().add(HomeRefreshed());
  //   } else if (index == 1) {
  //     // Trigger reload Account
  //     // context.read<AccountBloc>().add(AccountRefreshed());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar:
          BlocBuilder<MainNavigationCubit, MainNavigationState>(
            builder: (context, state) {
              return NavigationBar(
                selectedIndex: widget.navigationShell.currentIndex,
                onDestinationSelected: (index) => _onTap(index),
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
