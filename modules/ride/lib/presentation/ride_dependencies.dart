import 'package:core/core.dart';

import '../domain/usecases/get_popular_destinations.dart';
import '../domain/usecases/get_ride_status.dart';
import '../domain/usecases/request_ride.dart';

class RideDependencies {
  const RideDependencies({
    required this.getPopularDestinations,
    required this.requestRide,
    required this.getRideStatus,
    required this.analytics,
    required this.logger,
  });

  final GetPopularDestinations getPopularDestinations;
  final RequestRide requestRide;
  final GetRideStatus getRideStatus;
  final AnalyticsService analytics;
  final AppLogger logger;
}
