import '../logging/app_logger.dart';

abstract interface class AnalyticsService {
  void track(String event, [Map<String, Object?> properties = const {}]);
}

class ConsoleAnalyticsService implements AnalyticsService {
  ConsoleAnalyticsService({AppLogger? logger})
      : _logger = logger ?? AppLogger(tag: 'Analytics');

  final AppLogger _logger;
  final List<String> trackedEvents = [];

  @override
  void track(String event, [Map<String, Object?> properties = const {}]) {
    trackedEvents.add(event);
    _logger.info('event=$event properties=$properties');
  }
}

class NoopAnalyticsService implements AnalyticsService {
  const NoopAnalyticsService();

  @override
  void track(String event, [Map<String, Object?> properties = const {}]) {}
}
