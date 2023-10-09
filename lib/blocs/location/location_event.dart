part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class FetchLocation extends LocationEvent {
  final String city;

  const FetchLocation(this.city);

  @override
  List<Object> get props => [city];
}

class GetCurrentLocation extends LocationEvent {}
