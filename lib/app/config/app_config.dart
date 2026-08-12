import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get appName => dotenv.env['APP_NAME'] ?? 'Starterkit MRH';
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'http://localhost:8000';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static bool get enableLog => dotenv.env['ENABLE_LOG'] == 'true';
}
