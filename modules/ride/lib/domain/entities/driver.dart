import 'package:equatable/equatable.dart';

class Driver extends Equatable {
  const Driver({
    required this.name,
    required this.vehicle,
    required this.plateNumber,
    required this.rating,
  });

  final String name;
  final String vehicle;
  final String plateNumber;
  final double rating;

  @override
  List<Object?> get props => [name, vehicle, plateNumber, rating];
}
