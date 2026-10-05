import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/ride_location.dart';
import '../bloc/destination_list_cubit.dart';
import '../bloc/ride_booking_cubit.dart';
import '../ride_dependencies.dart';
import '../widgets/destination_tile.dart';
import 'ride_status_page.dart';

class RideHomePage extends StatelessWidget {
  const RideHomePage({super.key, required this.dependencies});

  final RideDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DestinationListCubit>(
      create: (_) =>
          DestinationListCubit(dependencies.getPopularDestinations)..load(),
      child: BlocListener<RideBookingCubit, RideBookingState>(
        listener: (context, state) {
          if (state is RideBookingActive) {
            dependencies.analytics.track(
              'ride_requested',
              {
                'rideId': state.ride.id,
                'destination': state.ride.destination.name,
              },
            );
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => RideStatusPage(
                  dependencies: dependencies,
                  rideId: state.ride.id,
                  initialRide: state.ride,
                ),
              ),
            );
          } else if (state is RideBookingFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).maybePop(),
            ),
            title: const Text('Ride'),
          ),
          body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: _PickupCard(),
              ),
              Expanded(
                child: BlocBuilder<DestinationListCubit, DestinationListState>(
                  builder: (context, state) {
                    return switch (state) {
                      DestinationListLoading() => const AppLoading(
                          message: 'Loading destinations...',
                        ),
                      DestinationListError(:final String message) =>
                        AppErrorView(
                          message: message,
                          onRetry: () =>
                              context.read<DestinationListCubit>().load(),
                        ),
                      DestinationListLoaded(
                        :final List<RideLocation> destinations
                      ) =>
                        ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: destinations.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final RideLocation destination =
                                destinations[index];
                            return DestinationTile(
                              destination: destination,
                              onRequest: () =>
                                  _request(context, destination),
                            );
                          },
                        ),
                    };
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _request(BuildContext context, RideLocation destination) {
    dependencies.analytics.track(
      'ride_destination_selected',
      {'destination': destination.name},
    );
    context.read<RideBookingCubit>().request(destination);
  }
}

class _PickupCard extends StatelessWidget {
  const _PickupCard();

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      child: Row(
        children: [
          Icon(Icons.my_location, color: AppColors.primary),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current location', style: AppTypography.title),
                SizedBox(height: 4),
                Text('Pickup point', style: AppTypography.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
