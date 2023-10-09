part of 'location_bloc.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

final class LocationInitial extends LocationState {}

final class LocationLoading extends LocationState {}

final class LocationSuccess extends LocationState {
  final LocationModel location;

  const LocationSuccess(this.location);
  @override
  List<Object> get props => [location];
}

final class LocationError extends LocationState {
  final String error;

  const LocationError(this.error);
  @override
  List<Object> get props => [error];
}
