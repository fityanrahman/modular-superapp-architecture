import 'package:contracts/contracts.dart';

import '../entities/cart.dart';
import '../entities/food_item.dart';
import '../entities/order.dart';
import '../entities/restaurant.dart';

abstract interface class FoodRepository {
  Future<List<Restaurant>> getRestaurants();

  Future<Restaurant> getRestaurantById(String id);

  Future<List<FoodItem>> getMenu(String restaurantId);

  Future<Order> placeOrder({
    required Cart cart,
    required PaymentResult payment,
  });
}
