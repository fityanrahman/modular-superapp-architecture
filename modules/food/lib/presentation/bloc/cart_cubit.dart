import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/cart.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/entities/restaurant.dart';

class CartCubit extends Cubit<Cart> {
  CartCubit() : super(const Cart());

  void add(FoodItem item, {required Restaurant restaurant}) {
    final List<CartItem> items = [...state.items];
    final int index = items.indexWhere((entry) => entry.item.id == item.id);

    if (index >= 0) {
      items[index] = items[index].copyWith(
        quantity: items[index].quantity + 1,
      );
    } else {
      items.add(CartItem(item: item, quantity: 1));
    }

    emit(
      Cart(
        restaurantId: restaurant.id,
        restaurantName: restaurant.name,
        items: items,
      ),
    );
  }

  void increment(FoodItem item) {
    final List<CartItem> items = [...state.items];
    final int index = items.indexWhere((entry) => entry.item.id == item.id);
    if (index < 0) {
      return;
    }
    items[index] = items[index].copyWith(
      quantity: items[index].quantity + 1,
    );
    _emitItems(items);
  }

  void decrement(FoodItem item) {
    final List<CartItem> items = [...state.items];
    final int index = items.indexWhere((entry) => entry.item.id == item.id);
    if (index < 0) {
      return;
    }

    if (items[index].quantity <= 1) {
      items.removeAt(index);
    } else {
      items[index] = items[index].copyWith(
        quantity: items[index].quantity - 1,
      );
    }

    _emitItems(items);
  }

  void removeItem(FoodItem item) {
    _emitItems(
      state.items.where((entry) => entry.item.id != item.id).toList(),
    );
  }

  void clear() => emit(const Cart());

  void _emitItems(List<CartItem> items) {
    emit(
      Cart(
        restaurantId: state.restaurantId,
        restaurantName: state.restaurantName,
        items: items,
      ),
    );
  }
}
