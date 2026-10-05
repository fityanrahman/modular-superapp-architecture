import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/restaurant.dart';
import '../../domain/usecases/get_restaurants.dart';

sealed class RestaurantListState extends Equatable {
  const RestaurantListState();

  @override
  List<Object?> get props => [];
}

class RestaurantListLoading extends RestaurantListState {
  const RestaurantListLoading();
}

class RestaurantListLoaded extends RestaurantListState {
  const RestaurantListLoaded(this.restaurants);

  final List<Restaurant> restaurants;

  @override
  List<Object?> get props => [restaurants];
}

class RestaurantListError extends RestaurantListState {
  const RestaurantListError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class RestaurantListCubit extends Cubit<RestaurantListState> {
  RestaurantListCubit(this._getRestaurants)
      : super(const RestaurantListLoading());

  final GetRestaurants _getRestaurants;

  Future<void> load() async {
    emit(const RestaurantListLoading());
    try {
      final List<Restaurant> restaurants = await _getRestaurants();
      emit(RestaurantListLoaded(restaurants));
    } catch (error) {
      emit(RestaurantListError(error.toString()));
    }
  }
}
