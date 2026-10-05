import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/ride_location.dart';
import '../../domain/usecases/get_popular_destinations.dart';

sealed class DestinationListState extends Equatable {
  const DestinationListState();

  @override
  List<Object?> get props => [];
}

class DestinationListLoading extends DestinationListState {
  const DestinationListLoading();
}

class DestinationListLoaded extends DestinationListState {
  const DestinationListLoaded(this.destinations);

  final List<RideLocation> destinations;

  @override
  List<Object?> get props => [destinations];
}

class DestinationListError extends DestinationListState {
  const DestinationListError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class DestinationListCubit extends Cubit<DestinationListState> {
  DestinationListCubit(this._getPopularDestinations)
      : super(const DestinationListLoading());

  final GetPopularDestinations _getPopularDestinations;

  Future<void> load() async {
    emit(const DestinationListLoading());
    try {
      final List<RideLocation> destinations = await _getPopularDestinations();
      emit(DestinationListLoaded(destinations));
    } catch (error) {
      emit(DestinationListError(error.toString()));
    }
  }
}
