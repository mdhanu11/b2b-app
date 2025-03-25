import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../pages/location_viewmodel.dart';
import '../../domain/entities/place_prediction.dart';

class LocationPredictionsList extends StatelessWidget {
  final Function(LatLng) moveToLocation;

  const LocationPredictionsList({Key? key, required this.moveToLocation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.isLoading) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (viewModel.predictions.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.only(top: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: viewModel.predictions.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final PlacePrediction prediction = viewModel.predictions[index];
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                leading:
                    const Icon(Icons.location_on_outlined, color: Colors.grey),
                title: Text(
                  prediction.mainText ?? "Unknown location",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: prediction.secondaryText != null
                    ? Text(prediction.secondaryText!)
                    : null,
                onTap: () async {
                  // Get place ID safely
                  final placeId = prediction.placeId;
                  if (placeId == null || placeId.isEmpty) {
                    // Handle missing place ID
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Invalid location data")));
                    return;
                  }

                  // Fetch coordinates for the selected place
                  final LatLng? position =
                      await viewModel.fetchLatLngForPlace(placeId);

                  // If coordinates are successfully retrieved, move to the location
                  if (position != null) {
                    // Clear the predictions list
                    viewModel.clearSearch();

                    // Move the map to the selected location
                    moveToLocation(position);
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
