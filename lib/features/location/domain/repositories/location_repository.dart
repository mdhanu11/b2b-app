import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../entities/place_prediction.dart';

abstract class LocationRepository {
  Future<LatLng> fetchCurrentLocation();
  Future<List<PlacePrediction>> fetchPlacePredictions(String query);
  Future<LatLng?> fetchLatLngFromPlaceId(String placeId);
  Future<LocationPermission> checkPermission();
  Future<LocationPermission> requestPermission();
  Future<Map<String, dynamic>?> fetchAddressFromLatLng(LatLng position);
}
