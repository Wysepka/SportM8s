import 'package:logger/logger.dart';
import 'logger_config.dart';

class LoggerService {
  final Logger _logger = LoggerConfig.logger;

  void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d("[WYSPA WORKS] $message", error: error, stackTrace: stackTrace);
  }

  void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i("[WYSPA WORKS] $message", error: error, stackTrace: stackTrace);
  }

  void warning(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w("[WYSPA WORKS] $message", error: error, stackTrace: stackTrace);
  }

  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e("[WYSPA WORKS] $message", error: error, stackTrace: stackTrace);
  }

  void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.wtf("[WYSPA WORKS] $message", error: error, stackTrace: stackTrace);
  }
} 