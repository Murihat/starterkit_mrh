import 'package:logger/logger.dart';
import '../../../app/config/app_config.dart';

class LoggerService {
  final Logger _logger;

  LoggerService()
    : _logger = Logger(
        level: AppConfig.enableLog ? Level.debug : Level.warning,
        printer: PrettyPrinter(
          methodCount: AppConfig.enableLog ? 1 : 0,
          errorMethodCount: AppConfig.enableLog ? 5 : 2,
          lineLength: 120,
          printEmojis: AppConfig.enableLog,
          dateTimeFormat: AppConfig.enableLog
              ? DateTimeFormat.onlyTimeAndSinceStart
              : DateTimeFormat.none,
        ),
      );

  void d(String tag, String msg) => _logger.d('[$tag] $msg');

  void i(String tag, String msg) => _logger.i('[$tag] $msg');

  void w(String tag, String msg) => _logger.w('[$tag] $msg');

  void e(String tag, String msg, [Object? error, StackTrace? stackTrace]) {
    _logger.e('[$tag] $msg', error: error, stackTrace: stackTrace);
  }
}
