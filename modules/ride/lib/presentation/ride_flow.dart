import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/ride_booking_cubit.dart';
import 'pages/ride_home_page.dart';
import 'ride_dependencies.dart';

class RideFlow extends StatefulWidget {
  const RideFlow({super.key, required this.dependencies});

  final RideDependencies dependencies;

  @override
  State<RideFlow> createState() => _RideFlowState();
}

class _RideFlowState extends State<RideFlow> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RideBookingCubit>(
      create: (_) => RideBookingCubit(widget.dependencies.requestRide),
      child: NavigatorPopHandler(
        onPopWithResult: (_) => _navigatorKey.currentState?.pop(),
        child: Navigator(
          key: _navigatorKey,
          onGenerateRoute: (settings) => MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => RideHomePage(dependencies: widget.dependencies),
          ),
        ),
      ),
    );
  }
}
