import 'package:equatable/equatable.dart';

import 'food_item.dart';

class CartItem extends Equatable {
  const CartItem({required this.item, required this.quantity});

  final FoodItem item;
  final int quantity;

  double get subtotal => item.price * quantity;

  CartItem copyWith({int? quantity}) =>
      CartItem(item: item, quantity: quantity ?? this.quantity);

  @override
  List<Object?> get props => [item, quantity];
}

class Cart extends Equatable {
  const Cart({
    this.restaurantId,
    this.restaurantName,
    this.items = const [],
  });

  final String? restaurantId;
  final String? restaurantName;
  final List<CartItem> items;

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold(0, (sum, item) => sum + item.subtotal);

  @override
  List<Object?> get props => [restaurantId, restaurantName, items];
}
