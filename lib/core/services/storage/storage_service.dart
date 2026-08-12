import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageKeys {
  StorageKeys._();

  static const String member = 'auth_member';
  static const String token = 'auth_token';
  static const String themeMode = 'theme_mode';
}

class StorageService {
  final FlutterSecureStorage _storage;

  const StorageService({this._storage = const FlutterSecureStorage()});

  // ==============================
  // String
  // ==============================

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return _storage.read(key: key);
  }

  // ==============================
  // Object
  // ==============================

  Future<void> writeObject(String key, Map<String, dynamic> value) async {
    await write(key, jsonEncode(value));
  }

  Future<Map<String, dynamic>?> readObject(String key) async {
    final data = await read(key);

    if (data == null) {
      return null;
    }

    try {
      final decoded = jsonDecode(data);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  // ==============================
  // Delete
  // ==============================

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }

  // ==============================
  // Check
  // ==============================

  Future<bool> containsKey(String key) async {
    return _storage.containsKey(key: key);
  }

  Future<ThemeMode> getThemeMode() async {
    final theme = await read(StorageKeys.themeMode);

    return theme == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }
}
