import 'package:contracts/contracts.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/cart.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/place_food_order.dart';

sealed class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

class CheckoutIdle extends CheckoutState {
  const CheckoutIdle();
}

class CheckoutProcessing extends CheckoutState {
  const CheckoutProcessing();
}

class CheckoutSuccess extends CheckoutState {
  const CheckoutSuccess({required this.order, required this.payment});

  final Order order;
  final PaymentResult payment;

  @override
  List<Object?> get props => [order, payment];
}

class CheckoutFailure extends CheckoutState {
  const CheckoutFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit(this._placeFoodOrder) : super(const CheckoutIdle());

  final PlaceFoodOrder _placeFoodOrder;

  Future<void> submit(Cart cart) async {
    emit(const CheckoutProcessing());
    final PlaceOrderResult result = await _placeFoodOrder(cart: cart);
    if (result.isSuccess) {
      emit(CheckoutSuccess(order: result.order!, payment: result.payment));
    } else {
      emit(CheckoutFailure(result.payment.message));
    }
  }
}
