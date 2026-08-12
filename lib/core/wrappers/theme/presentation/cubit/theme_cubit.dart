import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../base/base_cubit.dart';
import '../../../../services/storage/storage_service.dart';

part 'theme_state.dart';

class ThemeCubit extends BaseCubit<ThemeState> {
  final StorageService storage;

  ThemeCubit({required this.storage, required ThemeMode initialTheme})
    : super(ThemeState(themeMode: initialTheme));

  Future<void> toggleTheme() async {
    final themeMode = state.isDark ? ThemeMode.light : ThemeMode.dark;

    await setTheme(themeMode);
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    await storage.write(
      StorageKeys.themeMode,
      themeMode == ThemeMode.dark ? 'dark' : 'light',
    );

    safeEmit(ThemeState(themeMode: themeMode));
  }
}
