import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../registration/domain/entities/registration_model.dart';
import '../../domain/entities/place_prediction.dart';
import '../../domain/usecases/fetch_address_from_latlng_usecase.dart';
import '../../domain/usecases/fetch_current_location_usecase.dart';
import '../../domain/usecases/fetch_place_predictions_usecase.dart';
import '../../domain/usecases/fetch_latlng_usecase.dart';

class LocationViewModel extends ChangeNotifier {
  final FetchCurrentLocationUseCase fetchCurrentLocationUseCase;
  final FetchPlacePredictionsUseCase fetchPlacePredictionsUseCase;
  final FetchLatLngUseCase fetchLatLngForPlaceUseCase;
  final FetchAddressFromLatLngUseCase fetchAddressFromLatLngUseCase;

  static const LatLng defaultLocation = LatLng(24.7136, 46.6753);
  bool isPermissionPermanentlyDenied = false;

  LatLng? currentPosition; // Current position of the map or user
  List<PlacePrediction> predictions = []; // Predictions for search queries
  bool isLoading = false; // Global loading indicator
  bool isPermissionDenied = false; // Permission status
  bool placesListLoading = false; // Loading for places list
  String? currentAddress;
  bool isLocationOutOfRange = false;

  LatLng? selectedLocation;
  String? selectedLocationName;
  String? mainLocationComponent;
  String? subLocationComponent;

  String? errorMessage;

  Map<String, String>? addressComponents;

  LocationViewModel({
    required this.fetchCurrentLocationUseCase,
    required this.fetchPlacePredictionsUseCase,
    required this.fetchLatLngForPlaceUseCase,
    required this.fetchAddressFromLatLngUseCase,
  });

  /// Check initial location permission
  Future<void> checkInitialPermission() async {
    try {
      final permission = await Geolocator.checkPermission();
      print("DEBUG: checkInitialPermission() -> Permission: $permission");

      if (permission == LocationPermission.deniedForever) {
        isPermissionDenied = true;
        isPermissionPermanentlyDenied = true;
      } else if (permission == LocationPermission.denied) {
        isPermissionDenied = true;
      } else {
        isPermissionDenied = false;
      }

      notifyListeners();
    } catch (e) {
      errorMessage = "Error checking permissions: $e";
      notifyListeners();
    }
  }

  /// Request location permission (but don't check first)
  Future<void> requestLocationPermission() async {
    print("DEBUG: requestLocationPermission() called.");

    isLoading = true;
    notifyListeners();

    try {
      // Always call requestPermission() to trigger system popup
      final newPermission =
          await fetchCurrentLocationUseCase.requestPermission();

      print("DEBUG: New permission status: $newPermission");

      if (newPermission == LocationPermission.always ||
          newPermission == LocationPermission.whileInUse) {
        isPermissionDenied = false;
        isPermissionPermanentlyDenied = false;
        await fetchCurrentLocation(); // Fetch location on success
      } else if (newPermission == LocationPermission.deniedForever) {
        isPermissionDenied = true;
        isPermissionPermanentlyDenied = true;
        print("DEBUG: Permission denied forever. Direct user to settings.");
      } else {
        isPermissionDenied = true;
        print("DEBUG: Permission denied, but not permanently.");
      }

      errorMessage = null;
    } catch (e) {
      errorMessage = "Error requesting permissions: $e";
      isPermissionDenied = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> openLocationSettings() async {
    try {
      // Use the static method without name conflict
      bool result = await openAppSettings();
      print('Settings opened: $result');
    } catch (e) {
      print('Error opening settings: $e');
    }
  }

  void setPermissionDenied() {
    isPermissionDenied = true;
    isPermissionPermanentlyDenied = true;
    currentPosition = defaultLocation;
    notifyListeners();
  }

  /// Fetch the current location of the user
  Future<void> fetchCurrentLocation() async {
    isLoading = true;
    notifyListeners();

    try {
      currentPosition = await fetchCurrentLocationUseCase();
      errorMessage = null;
    } catch (e) {
      print('Error fetching location: $e');
      errorMessage = "Failed to get current location";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch place predictions for a search query
  /// The query parameter can now be null or empty
  Future<void> fetchPlacePredictions(String? query) async {
    // Handle null or empty query
    if (query == null || query.isEmpty) {
      predictions = []; // Clear predictions when query is empty
      notifyListeners();
      return;
    }

    // Only search if query has minimum length
    if (query.length < 2) {
      // Don't search with very short queries
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      predictions = await fetchPlacePredictionsUseCase(query);
      errorMessage = null;
    } catch (e) {
      print('Error fetching place predictions: $e');
      errorMessage = "Error fetching place predictions: $e";
      predictions = []; // Clear predictions on error
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch LatLng for a selected place ID
  Future<LatLng?> fetchLatLngForPlace(String placeId) async {
    isLoading = true;
    predictions = [];
    notifyListeners();

    try {
      final LatLng? latLng = await fetchLatLngForPlaceUseCase(placeId);
      if (latLng != null) {
        currentPosition = latLng;

        // Also fetch and update the address for this location
        await fetchAddressForMapPosition(latLng);
      }
      errorMessage = null;
      return latLng; // Return the fetched LatLng
    } catch (e) {
      print('Error fetching LatLng for place: $e');
      errorMessage = "Error fetching location details";
      return null; // Return null in case of error
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAddressForMapPosition(LatLng position) async {
    isLoading = true;
    notifyListeners();

    try {
      // Get the place details from your use case
      final placeDetails = await fetchAddressFromLatLngUseCase(position);

      if (placeDetails != null) {
        // Extract the formatted address
        final String formattedAddress = placeDetails['formatted_address'];
        currentAddress = formattedAddress;

        // Split the address into main and sub components for display
        List<String> addressParts = formattedAddress.split(',');
        mainLocationComponent =
            addressParts.isNotEmpty ? addressParts[0].trim() : "";
        subLocationComponent = addressParts.length > 1
            ? addressParts.sublist(1).join(',').trim()
            : "";

        // Update the state
        selectedLocation = position;
        selectedLocationName = formattedAddress;

        // Parse address components
        addressComponents =
            parseAddressComponentsFromPlaceDetails(placeDetails);

        isLocationOutOfRange = false;
      } else {
        // Handle case where address is null or empty
        selectedLocation = position; // Still keep the position
        selectedLocationName = null;
        mainLocationComponent = null;
        subLocationComponent = null;
        addressComponents = null;

        // Set error states for out-of-range locations
        isLocationOutOfRange = true;
      }

      errorMessage = null;
    } catch (e) {
      print("Error fetching address: $e");
      errorMessage = "Error fetching address";
      currentAddress = "Error fetching address.";
      isLocationOutOfRange = false;
      selectedLocationName = null;
      mainLocationComponent = null;
      subLocationComponent = null;
      addressComponents = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Method to clear search results
  void clearSearch() {
    predictions = [];
    notifyListeners();
  }

  Map<String, String> parseAddressComponentsFromPlaceDetails(
      Map<String, dynamic> placeDetails) {
    final Map<String, String> result = {};

    if (placeDetails.containsKey('address_components')) {
      final List addressComponents = placeDetails['address_components'];

      for (var component in addressComponents) {
        final List types = component['types'];

        // Extract city (locality or administrative_area_level_2)
        if (types.contains('locality')) {
          result['city'] = component['long_name'];
        } else if (types.contains('administrative_area_level_2') &&
            !result.containsKey('city')) {
          result['city'] = component['long_name'];
        }

        // Extract state/province (administrative_area_level_1)
        if (types.contains('administrative_area_level_1')) {
          result['state'] = component['long_name'];
        }

        // Extract country
        if (types.contains('country')) {
          result['country'] = component['short_name'];
        }
      }
    }

    print('result  $result');
    return result;
  }

  AddressModel? getFormattedAddress() {
    if (selectedLocation != null && selectedLocationName != null) {
      // Use the full address as googleAddress
      String googleAddress = selectedLocationName ?? '';

      // Try to extract address components from parsed data
      String city = '';
      String state = '';
      String country = '';

      // Use addressComponents map if available
      if (addressComponents != null) {
        city = addressComponents!['city'] ?? '';
        state = addressComponents!['state'] ?? '';
        country = addressComponents!['country'] ?? '';
      } else {
        // Fallback to main/sub components if addressComponents not available
        city = mainLocationComponent ?? '';

        // Try to extract state and country from subLocationComponent
        if (subLocationComponent != null) {
          List<String> components = subLocationComponent!.split(',');
          if (components.length >= 2) {
            state = components[0].trim();
            country = components.last.trim();
          } else if (components.length == 1) {
            country = components[0].trim();
          }
        }
      }

      print(addressComponents);
      // Create and return AddressModel
      return AddressModel(
        googleAddress: googleAddress,
        city: city,
        state: state,
        country: country,
      );
    }
    return null;
  }
}
