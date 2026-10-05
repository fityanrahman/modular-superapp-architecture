import '../entities/ride.dart';
import '../entities/ride_location.dart';

abstract interface class RideRepository {
  Future<List<RideLocation>> getPopularDestinations();

  Future<Ride> requestRide({required RideLocation destination});

  Future<Ride> getRideStatus(String rideId);
}
