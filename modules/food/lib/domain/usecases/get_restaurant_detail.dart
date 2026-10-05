import '../entities/restaurant.dart';
import '../repositories/food_repository.dart';

class GetRestaurantDetail {
  const GetRestaurantDetail(this._repository);

  final FoodRepository _repository;

  Future<Restaurant> call(String id) => _repository.getRestaurantById(id);
}
