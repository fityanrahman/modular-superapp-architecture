import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/ride.dart';
import '../../domain/usecases/get_ride_status.dart';

sealed class RideStatusState extends Equatable {
  const RideStatusState();

  @override
  List<Object?> get props => [];
}

class RideStatusLoading extends RideStatusState {
  const RideStatusLoading();
}

class RideStatusLoaded extends RideStatusState {
  const RideStatusLoaded(this.ride);

  final Ride ride;

  @override
  List<Object?> get props => [ride];
}

class RideStatusError extends RideStatusState {
  const RideStatusError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class RideStatusCubit extends Cubit<RideStatusState> {
  RideStatusCubit({
    required String rideId,
    required GetRideStatus getRideStatus,
    Ride? initialRide,
  }) : _rideId = rideId,
       _getRideStatus = getRideStatus,
       super(
         initialRide == null
             ? const RideStatusLoading()
             : RideStatusLoaded(initialRide),
       );

  final String _rideId;
  final GetRideStatus _getRideStatus;

  Future<void> load() async {
    emit(const RideStatusLoading());
    try {
      final Ride ride = await _getRideStatus(_rideId);
      emit(RideStatusLoaded(ride));
    } catch (error) {
      emit(RideStatusError(error.toString()));
    }
  }
}
