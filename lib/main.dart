import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:weather_app/blocs/location/location_bloc.dart';
import 'package:weather_app/blocs/weather/weather_bloc.dart';
import 'package:weather_app/screens/location_screen.dart';
import 'package:weather_app/screens/weather_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationBloc>(create: (context) => LocationBloc()),
        BlocProvider<WeatherBloc>(create: (context) => WeatherBloc()),
      ],
      child: MaterialApp(
          theme: ThemeData(
              colorScheme: const ColorScheme.light(
                  background: Colors.white,
                  onBackground: Colors.black,
                  primary: Color.fromRGBO(206, 147, 216, 1),
                  onPrimary: Colors.black,
                  secondary: Color.fromRGBO(244, 143, 177, 1),
                  onSecondary: Colors.white,
                  tertiary: Color.fromRGBO(255, 204, 128, 1),
                  error: Colors.red,
                  outline: Color(0xFF424242))),
          builder: EasyLoading.init(),
          routes: {
            '/location': (context) => const LocationScreen(),
            '/weather': (context) => const WeatherScreen(),
          },
          home: const LocationScreen()),
    );
  }
}
