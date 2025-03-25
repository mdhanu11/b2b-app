import '../repositories/location_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FetchAddressFromLatLngUseCase {
  final LocationRepository repository;

  FetchAddressFromLatLngUseCase(this.repository);

  Future<Map<String, dynamic>?> call(LatLng position) async {
    return repository.fetchAddressFromLatLng(position);
  }
}
