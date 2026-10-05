import '../entities/food_item.dart';
import '../repositories/food_repository.dart';

class GetMenu {
  const GetMenu(this._repository);

  final FoodRepository _repository;

  Future<List<FoodItem>> call(String restaurantId) =>
      _repository.getMenu(restaurantId);
}
