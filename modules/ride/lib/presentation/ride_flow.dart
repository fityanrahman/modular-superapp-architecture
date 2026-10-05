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
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          if (didPop) {
            return;
          }
          final NavigatorState? nested = _navigatorKey.currentState;
          if (nested != null && nested.canPop()) {
            nested.pop();
          } else {
            Navigator.of(context, rootNavigator: true).maybePop();
          }
        },
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
