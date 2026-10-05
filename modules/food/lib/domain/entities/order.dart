import 'package:contracts/contracts.dart';
import 'package:equatable/equatable.dart';

import 'cart.dart';

class Order extends Equatable {
  const Order({
    required this.id,
    required this.restaurantId,
    required this.items,
    required this.total,
    required this.paymentTransactionId,
  });

  final String id;
  final String restaurantId;
  final List<CartItem> items;
  final double total;
  final String paymentTransactionId;

  @override
  List<Object?> get props => [
    id,
    restaurantId,
    items,
    total,
    paymentTransactionId,
  ];
}

class PlaceOrderResult {
  const PlaceOrderResult({required this.payment, this.order});

  final PaymentResult payment;
  final Order? order;

  bool get isSuccess => order != null && payment.success;
}
