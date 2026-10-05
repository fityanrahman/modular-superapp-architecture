import '../entities/ride_location.dart';
import '../repositories/ride_repository.dart';

class GetPopularDestinations {
  const GetPopularDestinations(this._repository);

  final RideRepository _repository;

  Future<List<RideLocation>> call() => _repository.getPopularDestinations();
}
