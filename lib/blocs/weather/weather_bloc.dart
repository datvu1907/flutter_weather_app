import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/data/api_key.dart';
import 'package:weather_app/models/location_model.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<FetchWeather>(_fetchWeather);
  }

  void _fetchWeather(FetchWeather event, Emitter emit) async {
    emit(WeatherLoading());
    try {
      WeatherFactory wf =
          WeatherFactory(ApiKey().weatherKey, language: Language.ENGLISH);

      Weather weather = await wf.currentWeatherByLocation(
        event.location.latitude,
        event.location.longitude,
      );
      emit(WeatherSuccess(weather));
    } catch (error) {
      emit(WeatherError());
    }
  }
}
