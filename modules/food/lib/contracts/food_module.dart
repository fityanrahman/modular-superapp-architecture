import 'package:contracts/contracts.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../data/datasources/food_remote_data_source.dart';
import '../data/repositories/food_repository_impl.dart';
import '../domain/repositories/food_repository.dart';
import '../domain/usecases/get_menu.dart';
import '../domain/usecases/get_restaurant_detail.dart';
import '../domain/usecases/get_restaurants.dart';
import '../domain/usecases/place_food_order.dart';
import '../presentation/food_dependencies.dart';
import '../presentation/food_flow.dart';

class FoodModule implements ModuleLauncher {
  FoodModule({
    required ApiClient apiClient,
    required PaymentLauncher paymentLauncher,
    AnalyticsService? analytics,
    AppLogger? logger,
  })  : _analytics = analytics ?? const NoopAnalyticsService(),
        _logger = logger ?? AppLogger(tag: 'Food') {
    final FoodRepository repository = FoodRepositoryImpl(
      FoodRemoteDataSourceImpl(apiClient),
    );

    _dependencies = FoodDependencies(
      getRestaurants: GetRestaurants(repository),
      getRestaurantDetail: GetRestaurantDetail(repository),
      getMenu: GetMenu(repository),
      placeFoodOrder: PlaceFoodOrder(
        repository: repository,
        paymentLauncher: paymentLauncher,
      ),
      analytics: _analytics,
      logger: _logger,
    );

    _logger.info('Food module initialised');
  }

  final AnalyticsService _analytics;
  final AppLogger _logger;
  late final FoodDependencies _dependencies;

  @override
  String get moduleId => 'food';

  @override
  String get title => 'Food';

  @override
  IconData get icon => Icons.restaurant;

  @override
  Widget buildRoot(BuildContext context) =>
      FoodFlow(dependencies: _dependencies);
}
