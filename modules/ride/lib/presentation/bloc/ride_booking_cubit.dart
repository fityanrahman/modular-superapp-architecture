import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/ride.dart';
import '../../domain/entities/ride_location.dart';
import '../../domain/usecases/request_ride.dart';

sealed class RideBookingState extends Equatable {
  const RideBookingState();

  @override
  List<Object?> get props => [];
}

class RideBookingIdle extends RideBookingState {
  const RideBookingIdle();
}

class RideBookingRequesting extends RideBookingState {
  const RideBookingRequesting();
}

class RideBookingActive extends RideBookingState {
  const RideBookingActive(this.ride);

  final Ride ride;

  @override
  List<Object?> get props => [ride];
}

class RideBookingFailure extends RideBookingState {
  const RideBookingFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class RideBookingCubit extends Cubit<RideBookingState> {
  RideBookingCubit(this._requestRide) : super(const RideBookingIdle());

  final RequestRide _requestRide;

  Future<void> request(RideLocation destination) async {
    emit(const RideBookingRequesting());
    try {
      final Ride ride = await _requestRide(destination);
      emit(RideBookingActive(ride));
    } catch (error) {
      emit(RideBookingFailure(error.toString()));
    }
  }

  void reset() => emit(const RideBookingIdle());
}
