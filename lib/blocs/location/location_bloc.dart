import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/data/api_key.dart';
import 'package:weather_app/models/location_model.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<FetchLocation>(_fetchLocaiton);
    on<GetCurrentLocation>(_getCurrentLocation);
  }
  GeoCode geoCode = GeoCode(apiKey: ApiKey().locationKey);
  _fetchLocaiton(FetchLocation event, Emitter emit) async {
    emit(LocationLoading());
    try {
      print('City: ${event.city}');
      Coordinates coordinates =
          await geoCode.forwardGeocoding(address: event.city);
      emit(LocationSuccess(LocationModel(
          latitude: coordinates.latitude!, longitude: coordinates.longitude!)));
    } catch (e) {
      emit(const LocationError('Failed to fetch location'));
    }
  }

  _getCurrentLocation(GetCurrentLocation event, Emitter emit) async {
    emit(LocationLoading());
    try {
      Position position = await _determinePosition();

      emit(LocationSuccess(LocationModel(
          latitude: position.latitude, longitude: position.longitude)));
    } catch (err) {
      emit(const LocationError('Failed to fetch location'));
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
