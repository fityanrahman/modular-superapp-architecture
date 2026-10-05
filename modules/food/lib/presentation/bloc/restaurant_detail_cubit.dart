import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/food_item.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/usecases/get_menu.dart';
import '../../domain/usecases/get_restaurant_detail.dart';

sealed class RestaurantDetailState extends Equatable {
  const RestaurantDetailState();

  @override
  List<Object?> get props => [];
}

class RestaurantDetailLoading extends RestaurantDetailState {
  const RestaurantDetailLoading();
}

class RestaurantDetailLoaded extends RestaurantDetailState {
  const RestaurantDetailLoaded({required this.restaurant, required this.menu});

  final Restaurant restaurant;
  final List<FoodItem> menu;

  @override
  List<Object?> get props => [restaurant, menu];
}

class RestaurantDetailError extends RestaurantDetailState {
  const RestaurantDetailError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class RestaurantDetailCubit extends Cubit<RestaurantDetailState> {
  RestaurantDetailCubit({
    required String restaurantId,
    required GetRestaurantDetail getRestaurantDetail,
    required GetMenu getMenu,
  })  : _restaurantId = restaurantId,
        _getRestaurantDetail = getRestaurantDetail,
        _getMenu = getMenu,
        super(const RestaurantDetailLoading());

  final String _restaurantId;
  final GetRestaurantDetail _getRestaurantDetail;
  final GetMenu _getMenu;

  Future<void> load() async {
    emit(const RestaurantDetailLoading());
    try {
      final Restaurant restaurant = await _getRestaurantDetail(_restaurantId);
      final List<FoodItem> menu = await _getMenu(_restaurantId);
      emit(RestaurantDetailLoaded(restaurant: restaurant, menu: menu));
    } catch (error) {
      emit(RestaurantDetailError(error.toString()));
    }
  }
}
