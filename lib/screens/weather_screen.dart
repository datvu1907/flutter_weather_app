import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/blocs/weather/weather_bloc.dart';
import 'package:weather_app/widgets/custom_background.dart';

class WeatherScreen extends StatefulWidget {
  // final LocationModel location;
  const WeatherScreen({
    super.key,
  });

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Widget getWeatherIcon(int code) {
    switch (code) {
      case >= 200 && < 300:
        return Image.asset('assets/1.png');
      case >= 300 && < 400:
        return Image.asset('assets/2.png');
      case >= 500 && < 600:
        return Image.asset('assets/3.png');
      case >= 600 && < 700:
        return Image.asset('assets/4.png');
      case >= 700 && < 800:
        return Image.asset('assets/5.png');
      case == 800:
        return Image.asset('assets/6.png');
      case > 800 && <= 804:
        return Image.asset('assets/7.png');
      default:
        return Image.asset('assets/7.png');
    }
  }

  String getTime() {
    var now = DateTime.now();

    var hour = now.hour;

    if (hour >= 6 && hour < 12) {
      return 'Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Afternoon';
    } else if (hour >= 17 && hour < 20) {
      return 'Evening';
    } else {
      return 'Night';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(child: BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherSuccess) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Text(
                    '📍 ${state.weather.areaName}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Good ${getTime()}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                getWeatherIcon(state.weather.weatherConditionCode!),
                Center(
                  child: Text(
                    '${state.weather.temperature!.celsius!.round()}°C',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize: 55,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Center(
                  child: Text(
                    state.weather.weatherMain!.toUpperCase(),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize: 25,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: Text(
                    DateFormat('EEEE dd •')
                        .add_jm()
                        .format(state.weather.date!),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize: 16,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    ));
  }
}
