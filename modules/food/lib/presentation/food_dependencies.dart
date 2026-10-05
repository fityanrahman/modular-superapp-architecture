import 'package:core/core.dart';

import '../domain/usecases/get_menu.dart';
import '../domain/usecases/get_restaurant_detail.dart';
import '../domain/usecases/get_restaurants.dart';
import '../domain/usecases/place_food_order.dart';

class FoodDependencies {
  const FoodDependencies({
    required this.getRestaurants,
    required this.getRestaurantDetail,
    required this.getMenu,
    required this.placeFoodOrder,
    required this.analytics,
    required this.logger,
  });

  final GetRestaurants getRestaurants;
  final GetRestaurantDetail getRestaurantDetail;
  final GetMenu getMenu;
  final PlaceFoodOrder placeFoodOrder;
  final AnalyticsService analytics;
  final AppLogger logger;
}
