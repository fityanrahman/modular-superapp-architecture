import 'package:equatable/equatable.dart';

class RideLocation extends Equatable {
  const RideLocation({
    required this.name,
    required this.address,
    this.estimatedFare = 0,
  });

  final String name;
  final String address;
  final double estimatedFare;

  @override
  List<Object?> get props => [name, address, estimatedFare];
}
