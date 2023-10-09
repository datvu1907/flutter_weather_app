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
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WeatherScreen(
                          location: state.location,
                        )),
              );
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
                            SizedBox(
                              // width: MediaQuery.of(context).size.width * 0.3,
                              child: TextButton(
                                  onPressed: () {
                                    // if (_formKey.currentState!.validate()) {
                                    //   context.read<SignInBloc>().add(SignInRequired(
                                    //       emailController.text, passwordController.text));
                                    // }
                                    context.read<LocationBloc>().add(
                                        FetchLocation(textController.text));
                                  },
                                  style: TextButton.styleFrom(
                                      elevation: 3.0,
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(60))),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 5),
                                    child: Text(
                                      'Search',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )),
                            ),
                            SizedBox(
                              child: TextButton(
                                  onPressed: () {
                                    context
                                        .read<LocationBloc>()
                                        .add(GetCurrentLocation());
                                  },
                                  style: TextButton.styleFrom(
                                      elevation: 3.0,
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(60))),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 5),
                                    child: Text(
                                      'Get current',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )),
                            )
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
