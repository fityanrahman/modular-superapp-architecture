import 'package:contracts/contracts.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/make_payment.dart';

sealed class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentIdle extends PaymentState {
  const PaymentIdle();
}

class PaymentProcessing extends PaymentState {
  const PaymentProcessing();
}

class PaymentSuccess extends PaymentState {
  const PaymentSuccess(this.result);

  final PaymentResult result;

  @override
  List<Object?> get props => [result];
}

class PaymentFailure extends PaymentState {
  const PaymentFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit(this._makePayment) : super(const PaymentIdle());

  final MakePayment _makePayment;

  Future<void> pay({required double amount, String? description}) async {
    emit(const PaymentProcessing());
    final PaymentResult result = await _makePayment(
      amount: amount,
      description: description,
    );
    if (result.success) {
      emit(PaymentSuccess(result));
    } else {
      emit(PaymentFailure(result.message));
    }
  }
}
