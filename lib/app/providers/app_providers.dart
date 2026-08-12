import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/wrappers/connectivity/presentation/bloc/connectivity_bloc.dart';
import '../../core/wrappers/security/presentation/cubit/security_cubit.dart';
import '../../core/wrappers/theme/presentation/cubit/theme_cubit.dart';
import '../../features/main_navigation/presentation/cubit/main_navigation_cubit.dart';
import '../di/injection.dart';

class AppProviders {
  AppProviders._();

  static List<BlocProvider> providers({required ThemeMode initialTheme}) => [
    BlocProvider<ConnectivityBloc>(
      create: (_) => sl<ConnectivityBloc>()..add(ConnectivityStarted()),
    ),
    BlocProvider<SecurityCubit>(create: (_) => sl<SecurityCubit>()..check()),
    BlocProvider<ThemeCubit>(
      create: (_) => sl<ThemeCubit>(param1: initialTheme),
    ),
    BlocProvider<MainNavigationCubit>(create: (_) => sl<MainNavigationCubit>()),
  ];
}
