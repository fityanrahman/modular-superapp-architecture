import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ride/ride.dart';

void main() {
  final RideModule rideModule = RideModule(
    apiClient: FakeApiClient(routes: rideMockRoutes()),
    logger: AppLogger(tag: 'RideDevApp'),
  );

  runApp(RideDevApp(rideModule: rideModule));
}

class RideDevApp extends StatelessWidget {
  const RideDevApp({super.key, required this.rideModule});

  final RideModule rideModule;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ride Dev App',
      theme: AppTheme.light(),
      debugShowCheckedModeBanner: false,
      home: rideModule.buildRoot(context),
    );
  }
}
