import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../repositories/location_repository.dart';

class FetchCurrentLocationUseCase {
  final LocationRepository repository;

  FetchCurrentLocationUseCase(this.repository);

  Future<LatLng> call() async {
    return await repository.fetchCurrentLocation();
  }

  /// Check location permission
  Future<LocationPermission> checkPermission() async {
    return await repository.checkPermission();
  }

  /// Request location permission
  Future<LocationPermission> requestPermission() async {
    print("DEBUG: requestPermission() is being called!");
    return await repository.requestPermission();
  }
}
