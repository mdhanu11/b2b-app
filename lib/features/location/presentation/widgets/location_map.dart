import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../pages/location_viewmodel.dart';
import '../widgets/location_search_field.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationMap extends StatefulWidget {
  final Function(GoogleMapController) onMapCreated;
  final Function(LatLng) onLocationChanged;

  const LocationMap({
    Key? key,
    required this.onMapCreated,
    required this.onLocationChanged,
  }) : super(key: key);

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> with WidgetsBindingObserver {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  bool _mapInitialized = false;
  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Add a local state variable to control predictions visibility
  bool _showPredictions = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _determinePosition();

    // Add focus listener to control predictions visibility
    _searchFocusNode.addListener(_onFocusChange);

    // Listen to text changes to show/hide predictions
    searchController.addListener(_onSearchTextChanged);
  }

  void _onFocusChange() {
    // When focus is lost, ensure predictions are hidden
    if (!_searchFocusNode.hasFocus) {
      setState(() {
        _showPredictions = false;
      });
    }
  }

  void _onSearchTextChanged() {
    // Only show predictions when there's text and the field has focus
    setState(() {
      _showPredictions =
          searchController.text.isNotEmpty && _searchFocusNode.hasFocus;
    });

    // Update the search predictions
    if (searchController.text.isNotEmpty) {
      context
          .read<LocationViewModel>()
          .fetchPlacePredictions(searchController.text);
    } else {
      context.read<LocationViewModel>().clearSearch();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkPosition();
  }

  void _checkPosition() {
    final viewModel = context.read<LocationViewModel>();
    if (viewModel.currentPosition != null && _currentPosition == null) {
      _currentPosition = viewModel.currentPosition;
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mapController?.dispose();
    _searchFocusNode.removeListener(_onFocusChange);
    searchController.removeListener(_onSearchTextChanged);
    searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  /// Move camera to a specific position
  void _moveCamera(LatLng position) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(position),
    );
  }

  /// Fetches the user's current location and moves the map there
  Future<void> _determinePosition() async {
    final viewModel = context.read<LocationViewModel>();

    if (viewModel.isPermissionPermanentlyDenied) {
      print(
          "DEBUG: Skipping location request because permission is permanently denied.");
      return;
    }

    if (!await Geolocator.isLocationServiceEnabled()) {
      print("DEBUG: Location services are disabled.");
      return;
    }

    if (viewModel.isPermissionDenied) {
      print("DEBUG: Skipping location request because permission was denied.");
      return;
    }

    try {
      await viewModel.fetchCurrentLocation();
      if (viewModel.currentPosition != null) {
        setState(() {
          _currentPosition = viewModel.currentPosition;
        });
        _moveCamera(viewModel.currentPosition!);
        widget.onLocationChanged(viewModel.currentPosition!);
      }
    } catch (e) {
      print("DEBUG: Error fetching location: $e");
    }
  }

  /// **Encapsulates Google Map Widget**
  Widget _buildGoogleMap() {
    final viewModel = context.read<LocationViewModel>();

    // Calculate visible height (subtract bottom sheet height)
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = MediaQuery.of(context).padding.top + kToolbarHeight;
    final bottomSheetHeight = screenHeight * 0.21;
    final searchBarHeight = 60.0; // Approximate height of search bar

    // Important: We won't show the blue dot for current location,
    // since we're using our own centered marker for both current and selected locations
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _currentPosition!,
        zoom: 14.0,
      ),
      myLocationEnabled: false, // Turn off the built-in blue dot
      myLocationButtonEnabled: false,
      compassEnabled: true,
      zoomControlsEnabled: false,
      padding: EdgeInsets.only(
        top: searchBarHeight,
        bottom: bottomSheetHeight,
      ),
      onMapCreated: (GoogleMapController controller) {
        if (!_mapInitialized) {
          _mapController = controller;
          _mapInitialized = true;
          widget.onMapCreated(controller);
        }
      },
      onCameraMove: (position) {
        _currentPosition = position.target;
      },
      onCameraIdle: () {
        if (_currentPosition != null && mounted) {
          widget.onLocationChanged(_currentPosition!);
          viewModel.fetchAddressForMapPosition(_currentPosition!);
        }
      },
      // Add tap handler to dismiss predictions when tapping on map
      onTap: (_) {
        if (_showPredictions) {
          setState(() {
            _showPredictions = false;
          });
          _searchFocusNode.unfocus();
        }
      },
    );
  }

  /// **Encapsulates the Selected Location Marker**
  Widget _buildCenterMarker() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20), // Offset for the pin point
        child: Icon(
          Icons.location_on,
          size: 42,
          color: Colors.red,
        ),
      ),
    );
  }

  /// **Encapsulates Search Field & Predictions List**
  Widget _buildSearchSection() {
    return Positioned(
      top: 20,
      left: 16,
      right: 16,
      child: Column(
        children: [
          // Search field
          Consumer<LocationViewModel>(
            builder: (context, viewModel, _) {
              return LocationSearchField(
                controller: searchController,
                focusNode: _searchFocusNode,
                onTextCleared: () {
                  viewModel.clearSearch();
                  setState(() {
                    _showPredictions = false;
                  });
                  _searchFocusNode.unfocus();
                },
              );
            },
          ),

          // Predictions list - now controlled by local state
          Consumer<LocationViewModel>(
            builder: (context, viewModel, _) {
              // Only show predictions when _showPredictions is true AND we have predictions
              if (!_showPredictions || viewModel.predictions.isEmpty) {
                return const SizedBox.shrink();
              }

              return Container(
                constraints: BoxConstraints(maxHeight: 250),
                margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: viewModel.predictions.length,
                  itemBuilder: (context, index) {
                    final prediction = viewModel.predictions[index];
                    return ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(prediction.mainText ?? "Unknown"),
                      subtitle: prediction.secondaryText != null
                          ? Text(prediction.secondaryText!)
                          : null,
                      onTap: () async {
                        // Clear the search field and hide predictions immediately
                        searchController.clear();
                        setState(() {
                          _showPredictions = false;
                        });
                        viewModel.clearSearch();
                        _searchFocusNode.unfocus();

                        if (prediction.placeId != null) {
                          final LatLng? position = await viewModel
                              .fetchLatLngForPlace(prediction.placeId!);
                          if (position != null && mounted) {
                            setState(() {
                              _currentPosition = position;
                            });

                            _moveCamera(position);
                            widget.onLocationChanged(position);
                          }
                        }
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// **Builds the current location button**
  Widget _buildCurrentLocationButton() {
    return Positioned(
      right: 16,
      bottom: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () async {
              // Hide search predictions when pressing location button
              setState(() {
                _showPredictions = false;
              });
              _searchFocusNode.unfocus();

              final viewModel = context.read<LocationViewModel>();

              if (!viewModel.isPermissionDenied) {
                await viewModel.fetchCurrentLocation();
                if (viewModel.currentPosition != null &&
                    _mapController != null) {
                  _mapController!.animateCamera(
                    CameraUpdate.newLatLng(viewModel.currentPosition!),
                  );
                }
              } else {
                await viewModel.requestLocationPermission();
                if (!viewModel.isPermissionDenied) {
                  await _determinePosition();
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              child: const Icon(
                Icons.my_location,
                color: Colors.blue,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Selector<LocationViewModel, LatLng?>(
      selector: (_, viewModel) => viewModel.currentPosition,
      builder: (context, currentPosition, _) {
        if (currentPosition == null) {
          _currentPosition = LocationViewModel.defaultLocation;
        } else {
          _currentPosition = currentPosition;
        }

        // Use a Stack to overlay the search field on top of the map
        return Stack(
          children: [
            // Map as the base layer
            _buildGoogleMap(),

            // Centered marker
            _buildCenterMarker(),

            // Search field and predictions overlay
            _buildSearchSection(),

            // Current location button
            _buildCurrentLocationButton(),
          ],
        );
      },
    );
  }
}
