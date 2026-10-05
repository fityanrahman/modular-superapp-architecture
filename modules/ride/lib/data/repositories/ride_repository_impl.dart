import 'package:core/core.dart';

import '../../domain/entities/driver.dart';
import '../../domain/entities/ride.dart';
import '../../domain/entities/ride_location.dart';
import '../../domain/repositories/ride_repository.dart';
import '../datasources/ride_remote_data_source.dart';
import '../models/ride_location_model.dart';

const List<Driver> _drivers = [
  Driver(
    name: 'Andi Saputra',
    vehicle: 'Toyota Avanza',
    plateNumber: 'B 1234 XYZ',
    rating: 4.9,
  ),
  Driver(
    name: 'Budi Hartono',
    vehicle: 'Honda Mobilio',
    plateNumber: 'B 5678 ABC',
    rating: 4.8,
  ),
  Driver(
    name: 'Citra Lestari',
    vehicle: 'Daihatsu Xenia',
    plateNumber: 'B 9012 DEF',
    rating: 4.7,
  ),
];

const RideLocation _pickup = RideLocation(
  name: 'Current location',
  address: 'Pickup point',
);

class RideRepositoryImpl implements RideRepository {
  RideRepositoryImpl(this._remote);

  final RideRemoteDataSource _remote;
  final Map<String, Ride> _rides = <String, Ride>{};
  int _counter = 0;

  @override
  Future<List<RideLocation>> getPopularDestinations() async {
    final List<Map<String, dynamic>> rows = await _remote.fetchDestinations();
    return rows.map(RideLocationModel.fromJson).toList();
  }

  @override
  Future<Ride> requestRide({required RideLocation destination}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _counter += 1;
    final Ride ride = Ride(
      id: 'RIDE-$_counter',
      pickup: _pickup,
      destination: destination,
      fare: destination.estimatedFare,
      status: RideStatus.requesting,
      driver: _drivers[_counter % _drivers.length],
    );
    _rides[ride.id] = ride;
    return ride;
  }

  @override
  Future<Ride> getRideStatus(String rideId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final Ride? ride = _rides[rideId];
    if (ride == null) {
      throw ApiException(
        'Ride not found: $rideId',
        path: '/ride/status/$rideId',
        statusCode: 404,
      );
    }
    final Ride updated = ride.copyWith(status: _nextStatus(ride.status));
    _rides[rideId] = updated;
    return updated;
  }

  RideStatus _nextStatus(RideStatus status) => switch (status) {
    RideStatus.requesting => RideStatus.driverAssigned,
    RideStatus.driverAssigned => RideStatus.driverArriving,
    RideStatus.driverArriving => RideStatus.inProgress,
    RideStatus.inProgress => RideStatus.completed,
    RideStatus.completed => RideStatus.completed,
    RideStatus.cancelled => RideStatus.cancelled,
  };
}
