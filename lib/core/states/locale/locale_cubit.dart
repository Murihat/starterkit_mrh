import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/storage/storage_service.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final StorageService storage;

  // Default locale is Indonesian (id-ID)
  LocaleCubit({required this.storage})
    : super(const LocaleState(Locale('id', 'ID')));

  Future<void> loadLocale() async {
    final locale = await storage.getLocale();
    emit(LocaleState(locale));
  }

  Future<void> changeLocale(Locale newLocale) async {
    if (state.locale == newLocale) return;
    await storage.setLocale(newLocale.languageCode);
    emit(LocaleState(newLocale));
  }

  void setIndonesian() => changeLocale(const Locale('id', 'ID'));
  void setEnglish() => changeLocale(const Locale('en', 'US'));
}
