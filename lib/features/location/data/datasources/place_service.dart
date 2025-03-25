import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/place_prediction.dart';

class PlacesService {
  final String apiKey;

  PlacesService({required this.apiKey});

  Future<List<PlacePrediction>> fetchPredictions(
      String query, String languageCode) async {
    print('fetchPredictions $query with language: $languageCode');

    final response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&language=$languageCode&components=country:sa&key=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return (json['predictions'] as List)
          .map((item) => PlacePrediction(
                placeId: item['place_id'],
                mainText: item['structured_formatting']['main_text'],
                secondaryText: item['structured_formatting']['secondary_text'],
              ))
          .toList();
    } else {
      throw Exception('Failed to fetch predictions');
    }
  }

  Future<LatLng?> fetchLatLng(String placeId, String languageCode) async {
    print('fetchLatLng with language: $languageCode');
    final response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&language=$languageCode&key=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final location = json['result']['geometry']['location'];
      return LatLng(location['lat'], location['lng']);
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> fetchPlaceDetails(
      String placeId, String languageCode) async {
    final response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&language=$languageCode&key=$apiKey&fields=geometry,formatted_address,address_components,name',
      ),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final result = json['result'];
      final location = result['geometry']['location'];

      return {
        'latLng': LatLng(location['lat'], location['lng']),
        'formatted_address': result['formatted_address'],
        'address_components': result['address_components'],
        'name': result['name'],
      };
    } else {
      throw Exception('Failed to fetch place details');
    }
  }

  Future<String?> getPlaceIdFromLatLng(LatLng position) async {
    final response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey&region=sa',
      ),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['results'] != null && json['results'].isNotEmpty) {
        // Filter for results in Saudi Arabia
        final saResults = (json['results'] as List).where((result) {
          final addressComponents = result['address_components'] as List;
          return addressComponents.any((component) {
            final types = component['types'] as List;
            return types.contains('country') && component['short_name'] == 'SA';
          });
        }).toList();

        if (saResults.isNotEmpty) {
          return saResults[0]['place_id'];
        } else {
          return null; // Silently return null for non-Saudi locations
        }
      } else {
        return null; // No results found, return null instead of error
      }
    } else {
      return null; // API error, return null instead of error
    }
  }

  Future<Map<String, dynamic>?> getAddressFromLatLng(
      LatLng position, String languageCode) async {
    try {
      // First get placeId (this method now filters for Saudi Arabia)
      final placeId = await getPlaceIdFromLatLng(position);

      // If placeId is null (not in Saudi Arabia), return null
      if (placeId == null) {
        return null;
      }

      // Then get place details
      final placeDetails = await fetchPlaceDetails(placeId, languageCode);

      // Return formatted address
      return placeDetails;
    } catch (e) {
      print("Error in PlacesService.getAddressFromLatLng: $e");
      return null; // Return null instead of error message
    }
  }
}
