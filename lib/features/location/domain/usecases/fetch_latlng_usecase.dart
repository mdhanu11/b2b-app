import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/repositories/location_repository.dart';

class FetchLatLngUseCase {
  final LocationRepository repository;

  FetchLatLngUseCase(this.repository);

  Future<LatLng?> call(String placeId) {
    return repository.fetchLatLngFromPlaceId(placeId);
  }
}
