import '../entities/ride.dart';
import '../repositories/ride_repository.dart';

class GetRideStatus {
  const GetRideStatus(this._repository);

  final RideRepository _repository;

  Future<Ride> call(String rideId) => _repository.getRideStatus(rideId);
}
