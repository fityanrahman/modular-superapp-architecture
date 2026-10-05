import 'package:contracts/contracts.dart';

import '../../domain/entities/cart.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/repositories/food_repository.dart';
import '../datasources/food_remote_data_source.dart';
import '../models/food_item_model.dart';
import '../models/restaurant_model.dart';

class FoodRepositoryImpl implements FoodRepository {
  FoodRepositoryImpl(this._remote);

  final FoodRemoteDataSource _remote;

  @override
  Future<List<Restaurant>> getRestaurants() async {
    final List<Map<String, dynamic>> rows = await _remote.fetchRestaurants();
    return rows.map(RestaurantModel.fromJson).toList();
  }

  @override
  Future<Restaurant> getRestaurantById(String id) async {
    final Map<String, dynamic> json = await _remote.fetchRestaurant(id);
    return RestaurantModel.fromJson(json);
  }

  @override
  Future<List<FoodItem>> getMenu(String restaurantId) async {
    final List<Map<String, dynamic>> rows = await _remote.fetchMenu(
      restaurantId,
    );
    return rows.map(FoodItemModel.fromJson).toList();
  }

  @override
  Future<Order> placeOrder({
    required Cart cart,
    required PaymentResult payment,
  }) async {
    final Map<String, dynamic> json = await _remote.submitOrder({
      'restaurantId': cart.restaurantId,
      'items': cart.items
          .map(
            (item) => {
              'id': item.item.id,
              'name': item.item.name,
              'quantity': item.quantity,
              'price': item.item.price,
            },
          )
          .toList(),
      'total': cart.subtotal,
      'paymentTransactionId': payment.transactionId,
    });

    return Order(
      id: json['id'] as String,
      restaurantId:
          (json['restaurantId'] as String?) ?? cart.restaurantId ?? 'unknown',
      items: cart.items,
      total: (json['total'] as num).toDouble(),
      paymentTransactionId:
          (json['paymentTransactionId'] as String?) ??
          payment.transactionId ??
          'unknown',
    );
  }
}
