part of 'weather_bloc.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class FetchWeather extends WeatherEvent {
  final LocationModel location;

  const FetchWeather(this.location);

  @override
  List<Object> get props => [location];
}
