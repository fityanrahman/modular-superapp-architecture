import 'package:contracts/contracts.dart';

import '../entities/cart.dart';
import '../entities/order.dart';
import '../repositories/food_repository.dart';

class PlaceFoodOrder {
  const PlaceFoodOrder({
    required FoodRepository repository,
    required PaymentLauncher paymentLauncher,
  })  : _repository = repository,
        _paymentLauncher = paymentLauncher;

  final FoodRepository _repository;
  final PaymentLauncher _paymentLauncher;

  Future<PlaceOrderResult> call({required Cart cart}) async {
    final PaymentResult payment = await _paymentLauncher.pay(
      amount: cart.subtotal,
      description: 'Food order at ${cart.restaurantName ?? 'restaurant'}',
    );

    if (!payment.success) {
      return PlaceOrderResult(payment: payment);
    }

    final Order order = await _repository.placeOrder(
      cart: cart,
      payment: payment,
    );
    return PlaceOrderResult(payment: payment, order: order);
  }
}
