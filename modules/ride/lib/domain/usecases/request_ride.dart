import '../entities/ride.dart';
import '../entities/ride_location.dart';
import '../repositories/ride_repository.dart';

class RequestRide {
  const RequestRide(this._repository);

  final RideRepository _repository;

  Future<Ride> call(RideLocation destination) =>
      _repository.requestRide(destination: destination);
}
