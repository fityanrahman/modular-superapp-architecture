import '../entities/restaurant.dart';
import '../repositories/food_repository.dart';

class GetRestaurants {
  const GetRestaurants(this._repository);

  final FoodRepository _repository;

  Future<List<Restaurant>> call() => _repository.getRestaurants();
}
