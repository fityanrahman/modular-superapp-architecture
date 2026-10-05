import 'package:equatable/equatable.dart';

import 'driver.dart';
import 'ride_location.dart';

enum RideStatus {
  requesting,
  driverAssigned,
  driverArriving,
  inProgress,
  completed,
  cancelled;

  String get label => switch (this) {
        RideStatus.requesting => 'Finding a driver',
        RideStatus.driverAssigned => 'Driver assigned',
        RideStatus.driverArriving => 'Driver arriving',
        RideStatus.inProgress => 'On the way',
        RideStatus.completed => 'Completed',
        RideStatus.cancelled => 'Cancelled',
      };
}

class Ride extends Equatable {
  const Ride({
    required this.id,
    required this.pickup,
    required this.destination,
    required this.fare,
    required this.status,
    this.driver,
  });

  final String id;
  final RideLocation pickup;
  final RideLocation destination;
  final double fare;
  final RideStatus status;
  final Driver? driver;

  Ride copyWith({RideStatus? status, Driver? driver}) => Ride(
        id: id,
        pickup: pickup,
        destination: destination,
        fare: fare,
        status: status ?? this.status,
        driver: driver ?? this.driver,
      );

  @override
  List<Object?> get props => [id, pickup, destination, fare, status, driver];
}
