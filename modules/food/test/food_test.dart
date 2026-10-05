import 'package:contracts/contracts.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food/data/datasources/food_fixtures.dart';
import 'package:food/data/datasources/food_remote_data_source.dart';
import 'package:food/data/repositories/food_repository_impl.dart';
import 'package:food/domain/entities/cart.dart';
import 'package:food/domain/entities/food_item.dart';
import 'package:food/domain/entities/restaurant.dart';
import 'package:food/domain/usecases/get_restaurants.dart';
import 'package:food/domain/usecases/place_food_order.dart';
import 'package:food/presentation/bloc/cart_cubit.dart';

class _SuccessPaymentLauncher implements PaymentLauncher {
  @override
  Future<PaymentResult> pay({
    required double amount,
    String? description,
  }) async {
    return PaymentResult.success(amount: amount, transactionId: 'TRX-TEST');
  }
}

class _FailingPaymentLauncher implements PaymentLauncher {
  @override
  Future<PaymentResult> pay({
    required double amount,
    String? description,
  }) async {
    return const PaymentResult.failure(message: 'Insufficient balance');
  }
}

void main() {
  late FoodRepositoryImpl repository;

  setUp(() {
    final FakeApiClient client = FakeApiClient(
      routes: foodMockRoutes(),
      latency: Duration.zero,
    );
    repository = FoodRepositoryImpl(FoodRemoteDataSourceImpl(client));
  });

  test('loads restaurants from the mock API', () async {
    final List<Restaurant> restaurants = await GetRestaurants(repository)();

    expect(restaurants, isNotEmpty);
    expect(restaurants.first.name, isNotEmpty);
  });

  test('places an order after a successful payment', () async {
    const FoodItem item = FoodItem(
      id: 'r1-m1',
      name: 'Nasi Goreng Special',
      description: 'Fried rice',
      price: 28000,
    );
    const Cart cart = Cart(
      restaurantId: 'r1',
      restaurantName: 'Nusantara Kitchen',
      items: [CartItem(item: item, quantity: 2)],
    );

    final PlaceFoodOrder usecase = PlaceFoodOrder(
      repository: repository,
      paymentLauncher: _SuccessPaymentLauncher(),
    );
    final result = await usecase(cart: cart);

    expect(result.isSuccess, isTrue);
    expect(result.order!.total, 56000);
    expect(result.order!.paymentTransactionId, 'TRX-TEST');
  });

  test('does not place an order when payment fails', () async {
    const FoodItem item = FoodItem(
      id: 'r1-m1',
      name: 'Nasi Goreng Special',
      description: 'Fried rice',
      price: 28000,
    );
    const Cart cart = Cart(
      restaurantId: 'r1',
      restaurantName: 'Nusantara Kitchen',
      items: [CartItem(item: item, quantity: 1)],
    );

    final PlaceFoodOrder usecase = PlaceFoodOrder(
      repository: repository,
      paymentLauncher: _FailingPaymentLauncher(),
    );
    final result = await usecase(cart: cart);

    expect(result.isSuccess, isFalse);
    expect(result.payment.message, 'Insufficient balance');
  });

  test('cart cubit adds, increments and removes items', () {
    final CartCubit cubit = CartCubit();
    const Restaurant restaurant = Restaurant(
      id: 'r1',
      name: 'Nusantara Kitchen',
      cuisine: 'Indonesian',
      rating: 4.8,
      deliveryEtaMinutes: 25,
    );
    const FoodItem item = FoodItem(
      id: 'r1-m1',
      name: 'Nasi Goreng Special',
      description: 'Fried rice',
      price: 28000,
    );

    cubit.add(item, restaurant: restaurant);
    cubit.add(item, restaurant: restaurant);

    expect(cubit.state.totalItems, 2);

    cubit.decrement(item);
    expect(cubit.state.totalItems, 1);

    cubit.removeItem(item);
    expect(cubit.state.isEmpty, isTrue);
  });
}
