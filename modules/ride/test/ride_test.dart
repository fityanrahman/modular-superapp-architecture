import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ride/data/datasources/ride_fixtures.dart';
import 'package:ride/data/datasources/ride_remote_data_source.dart';
import 'package:ride/data/repositories/ride_repository_impl.dart';
import 'package:ride/domain/entities/ride.dart';
import 'package:ride/domain/entities/ride_location.dart';
import 'package:ride/domain/usecases/request_ride.dart';
import 'package:ride/presentation/bloc/ride_booking_cubit.dart';

void main() {
  late RideRepositoryImpl repository;

  setUp(() {
    final FakeApiClient client = FakeApiClient(
      routes: rideMockRoutes(),
      latency: Duration.zero,
    );
    repository = RideRepositoryImpl(RideRemoteDataSourceImpl(client));
  });

  test('loads popular destinations from the mock API', () async {
    final List<RideLocation> destinations =
        await repository.getPopularDestinations();

    expect(destinations, isNotEmpty);
    expect(destinations.first.name, isNotEmpty);
  });

  test('requests a ride with an assigned driver', () async {
    final List<RideLocation> destinations =
        await repository.getPopularDestinations();
    final Ride ride = await repository.requestRide(
      destination: destinations.first,
    );

    expect(ride.status, RideStatus.requesting);
    expect(ride.driver, isNotNull);
    expect(ride.fare, destinations.first.estimatedFare);
  });

  test('advances the ride status on refresh', () async {
    final List<RideLocation> destinations =
        await repository.getPopularDestinations();
    final Ride ride = await repository.requestRide(
      destination: destinations.first,
    );

    final Ride updated = await repository.getRideStatus(ride.id);

    expect(updated.status, isNot(RideStatus.requesting));
  });

  test('ride booking cubit emits an active ride', () async {
    final List<RideLocation> destinations =
        await repository.getPopularDestinations();
    final RideBookingCubit cubit = RideBookingCubit(RequestRide(repository));

    await cubit.request(destinations.first);

    expect(cubit.state, isA<RideBookingActive>());
    expect(
      (cubit.state as RideBookingActive).ride.destination,
      destinations.first,
    );
  });
}
