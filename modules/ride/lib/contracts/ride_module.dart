import 'package:contracts/contracts.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../data/datasources/ride_remote_data_source.dart';
import '../data/repositories/ride_repository_impl.dart';
import '../domain/repositories/ride_repository.dart';
import '../domain/usecases/get_popular_destinations.dart';
import '../domain/usecases/get_ride_status.dart';
import '../domain/usecases/request_ride.dart';
import '../presentation/ride_dependencies.dart';
import '../presentation/ride_flow.dart';

class RideModule implements ModuleLauncher {
  RideModule({
    required ApiClient apiClient,
    AnalyticsService? analytics,
    AppLogger? logger,
  }) : _analytics = analytics ?? const NoopAnalyticsService(),
       _logger = logger ?? AppLogger(tag: 'Ride') {
    final RideRepository repository = RideRepositoryImpl(
      RideRemoteDataSourceImpl(apiClient),
    );

    _dependencies = RideDependencies(
      getPopularDestinations: GetPopularDestinations(repository),
      requestRide: RequestRide(repository),
      getRideStatus: GetRideStatus(repository),
      analytics: _analytics,
      logger: _logger,
    );

    _logger.info('Ride module initialised');
  }

  final AnalyticsService _analytics;
  final AppLogger _logger;
  late final RideDependencies _dependencies;

  @override
  String get moduleId => 'ride';

  @override
  String get title => 'Ride';

  @override
  IconData get icon => Icons.local_taxi;

  @override
  Widget buildRoot(BuildContext context) =>
      RideFlow(dependencies: _dependencies);
}
