import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/blocs/location/location_bloc.dart';
import 'package:weather_app/blocs/weather/weather_bloc.dart';
import 'package:weather_app/screens/weather_screen.dart';
import 'package:weather_app/widgets/custom_background.dart';
import 'package:weather_app/widgets/custom_button.dart';
import 'package:weather_app/widgets/custom_text_field.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController textController = TextEditingController();
  bool obscurePassword = true;
  String? _errorMsg;
  @override
  Widget build(BuildContext context) {
    return CustomBackground(
        child: Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 1.8,
        child: BlocConsumer<LocationBloc, LocationState>(
          listener: (context, state) {
            if (state is LocationSuccess) {
              EasyLoading.dismiss();
              BlocProvider.of<WeatherBloc>(context)
                  .add(FetchWeather(state.location));
              Navigator.pushNamed(context, '/weather');
            } else if (state is LocationLoading) {
              EasyLoading.show();
            } else if (state is LocationError) {
              EasyLoading.dismiss();
              EasyLoading.showError(state.error);
            }
          },
          builder: (BuildContext context, LocationState state) {
            return Column(
              children: [
                Center(
                  child: Text(
                    'Welcome to Weather app',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize: 25,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'You can search weather from any city name, zip code or you can get the weather from current position.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize: 16,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: CustomTextField(
                                controller: textController,
                                hintText: 'City name or Zip code',
                                obscureText: false,
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: const Icon(CupertinoIcons.location),
                                errorMsg: _errorMsg,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please fill in this field';
                                  } else if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                                      .hasMatch(val)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                })),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CustomButton(
                              onPressed: () {
                                if (textController.text.isNotEmpty) {
                                  context
                                      .read<LocationBloc>()
                                      .add(FetchLocation(textController.text));
                                }
                              },
                              title: 'Search',
                            ),
                            CustomButton(
                                onPressed: () {
                                  context
                                      .read<LocationBloc>()
                                      .add(GetCurrentLocation());
                                },
                                title: 'Get current')
                          ],
                        )
                      ],
                    )),
              ],
            );
          },
        ),
      ),
    ));
  }
}
