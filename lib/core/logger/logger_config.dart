import 'package:logger/logger.dart';

class LoggerConfig {
  static late Logger _instance;
  
  static void initialize({bool isDevelopment = false}) {
    _instance = Logger(
      printer: PrettyPrinter(
        methodCount: isDevelopment ? 2 : 0,
        errorMethodCount: isDevelopment ? 8 : 1,
        lineLength: 120,
        colors: true,
        printEmojis: isDevelopment,
        printTime: true,
      ),
      level: isDevelopment ? Level.debug : Level.info,
      filter: ProductionFilter(),
    );
  }

  static Logger get logger => _instance;
}

// Extension method for easier access
extension LoggerExtension on Object {
  Logger get log => LoggerConfig.logger;
} 