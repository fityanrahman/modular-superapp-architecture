import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/driver.dart';
import '../../domain/entities/ride.dart';
import '../bloc/ride_status_cubit.dart';
import '../ride_dependencies.dart';
import '../widgets/driver_card.dart';

const List<RideStatus> _progress = [
  RideStatus.requesting,
  RideStatus.driverAssigned,
  RideStatus.driverArriving,
  RideStatus.inProgress,
  RideStatus.completed,
];

class RideStatusPage extends StatelessWidget {
  const RideStatusPage({
    super.key,
    required this.dependencies,
    required this.rideId,
    this.initialRide,
  });

  final RideDependencies dependencies;
  final String rideId;
  final Ride? initialRide;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RideStatusCubit>(
      create: (_) {
        final RideStatusCubit cubit = RideStatusCubit(
          rideId: rideId,
          getRideStatus: dependencies.getRideStatus,
          initialRide: initialRide,
        );
        if (initialRide == null) {
          cubit.load();
        }
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Ride status')),
        body: BlocBuilder<RideStatusCubit, RideStatusState>(
          builder: (context, state) {
            return switch (state) {
              RideStatusLoading() => const AppLoading(
                message: 'Refreshing status...',
              ),
              RideStatusError(:final String message) => AppErrorView(
                message: message,
                onRetry: () => context.read<RideStatusCubit>().load(),
              ),
              RideStatusLoaded(:final Ride ride) => _RideStatusBody(ride: ride),
            };
          },
        ),
      ),
    );
  }
}

class _RideStatusBody extends StatelessWidget {
  const _RideStatusBody({required this.ride});

  final Ride ride;

  @override
  Widget build(BuildContext context) {
    final Driver? driver = ride.driver;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ride.status.label, style: AppTypography.headline),
                  const SizedBox(height: 8),
                  Text('Ride ${ride.id}', style: AppTypography.caption),
                  const SizedBox(height: 12),
                  _Timeline(status: ride.status),
                  const SizedBox(height: 12),
                  Text(
                    '${ride.destination.name} · ${formatRupiah(ride.fare)}',
                    style: AppTypography.body,
                  ),
                ],
              ),
            ),
            if (driver != null) ...[
              const SizedBox(height: 16),
              DriverCard(driver: driver),
            ],
            const Spacer(),
            PrimaryButton(
              label: 'Refresh status',
              icon: Icons.refresh,
              onPressed: () => context.read<RideStatusCubit>().load(),
            ),
            if (ride.status == RideStatus.completed) ...[
              const SizedBox(height: 12),
              PrimaryButton(
                label: 'Done',
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.status});

  final RideStatus status;

  @override
  Widget build(BuildContext context) {
    final int currentIndex = _progress.indexOf(status);
    return Column(
      children: [
        for (int index = 0; index < _progress.length; index++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(
                  index <= currentIndex
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  size: 18,
                  color: index <= currentIndex
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  _progress[index].label,
                  style: index <= currentIndex
                      ? AppTypography.body
                      : AppTypography.caption,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
