import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/location_viewmodel.dart';

class SelectedLocationDisplay extends StatelessWidget {
  const SelectedLocationDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationViewModel>(
      builder: (context, viewModel, _) {
        final selectedAddress = viewModel.selectedLocationName;

        if (selectedAddress == null || selectedAddress.isEmpty) {
          return Container(
            height: 70,
            child: const Center(
              child: Text(
                "Select a location on the map",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.green,
                size: 24,
              ),
              const SizedBox(width: 12),
              // Use Expanded to ensure the text wraps properly
              Expanded(
                child: Text(
                  selectedAddress,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4, // Increased line height for better readability
                  ),
                  // Make sure text wraps when it's too long
                  softWrap: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
