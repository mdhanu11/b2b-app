import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/providers/locale_provider.dart';
import '../../../../core/services/locale_service.dart';
import '../../domain/entities/place_prediction.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_service.dart';
import '../datasources/place_service.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationService locationService;
  final PlacesService placesService;
  final LocaleService _localeService = LocaleService();

  LocationRepositoryImpl({
    required this.locationService,
    required this.placesService,
  });

  @override
  Future<LatLng> fetchCurrentLocation() async {
    final position = await locationService.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }

  @override
  Future<LocationPermission> checkPermission() async {
    return await locationService.checkPermission();
  }

  @override
  Future<LocationPermission> requestPermission() async {
    return await locationService.requestPermission();
  }

  @override
  Future<List<PlacePrediction>> fetchPlacePredictions(String query) {
    final languageCode = _localeService.currentLocale.languageCode;
    return placesService.fetchPredictions(query, languageCode);
  }

  @override
  Future<LatLng?> fetchLatLngFromPlaceId(String placeId) {
    final languageCode = _localeService.currentLocale.languageCode;
    return placesService.fetchLatLng(placeId, languageCode);
  }

  @override
  Future<Map<String, dynamic>?> fetchAddressFromLatLng(LatLng position) async {
    try {
      final languageCode = _localeService.currentLocale.languageCode;
      return await placesService.getAddressFromLatLng(position, languageCode);
    } catch (e) {
      print("Error in repository fetchAddressFromLatLng: $e");
      return null;
    }
  }
}
