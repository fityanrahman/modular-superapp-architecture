import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class AppLogger {
  AppLogger({this.tag = 'SuperApp', this.minimumLevel = LogLevel.debug});

  final String tag;
  final LogLevel minimumLevel;

  final List<String> _entries = [];

  List<String> get entries => List.unmodifiable(_entries);

  void debug(String message) => _log(LogLevel.debug, message);

  void info(String message) => _log(LogLevel.info, message);

  void warning(String message) => _log(LogLevel.warning, message);

  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message);
    if (error != null) {
      _log(LogLevel.error, '  caused by: $error');
    }
    if (stackTrace != null) {
      _log(LogLevel.error, '  $stackTrace');
    }
  }

  void _log(LogLevel level, String message) {
    if (level.index < minimumLevel.index) {
      return;
    }
    final entry = '[${level.name.toUpperCase()}] [$tag] $message';
    _entries.add(entry);
    debugPrint(entry);
  }
}
