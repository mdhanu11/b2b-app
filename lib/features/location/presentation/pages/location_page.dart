import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/widgets/custom_app_ bar.dart';
import '../widgets/location_map.dart';
import '../widgets/location_bottom_sheet.dart';
import '../widgets/current_location_button.dart';
import 'location_viewmodel.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage>
    with WidgetsBindingObserver {
  GoogleMapController? _googleMapController;
  bool _permissionDialogShown = false;
  bool _permissionComplete = false;
  DateTime? _pausedTime;

  @override
  void initState() {
    super.initState();
    // Add observer to detect app lifecycle changes
    WidgetsBinding.instance.addObserver(this);

    // Delay to ensure build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initPermissionCheck();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Track when app is paused (backgrounded)
    if (state == AppLifecycleState.paused) {
      _pausedTime = DateTime.now();
    }

    // When app resumes from background
    if (state == AppLifecycleState.resumed && _pausedTime != null) {
      // Only refresh if the app was paused for at least 1 second
      // This helps identify returns from Settings vs. brief interruptions
      final now = DateTime.now();
      final pauseDuration = now.difference(_pausedTime!);

      if (pauseDuration.inSeconds >= 1) {
        // The user likely returned from Settings
        _refreshPermissions();
      }

      _pausedTime = null;
    }
  }

  // Refresh permissions when returning from settings
  Future<void> _refreshPermissions() async {
    print("DEBUG: Refreshing permissions after returning from settings");
    final viewModel = context.read<LocationViewModel>();

    // Re-check permission status
    await viewModel.checkInitialPermission();

    // If permission is now granted but was previously denied, refresh the map
    if (!viewModel.isPermissionDenied) {
      setState(() {
        _permissionComplete = true;
      });

      // Fetch current location if permission is now granted
      await viewModel.fetchCurrentLocation();

      // Try to move to current location
      if (viewModel.currentPosition != null && _googleMapController != null) {
        _googleMapController!.animateCamera(
          CameraUpdate.newLatLng(viewModel.currentPosition!),
        );
      }
    }
  }

  Future<void> _initPermissionCheck() async {
    final viewModel = context.read<LocationViewModel>();

    // Check permission once when the page loads
    await viewModel.checkInitialPermission();

    print("DEBUG: isPermissionDenied: ${viewModel.isPermissionDenied}");
    print(
        "DEBUG: isPermissionPermanentlyDenied: ${viewModel.isPermissionPermanentlyDenied}");
    print("DEBUG: _permissionDialogShown: $_permissionDialogShown");

    // Show the custom popup ONLY if permission is denied and not permanently denied
    if (viewModel.isPermissionDenied &&
        !viewModel.isPermissionPermanentlyDenied &&
        mounted &&
        !_permissionDialogShown) {
      setState(() {
        _permissionDialogShown = true;
      });
      _showPermissionDialog();
    } else {
      // Permission already granted or permanently denied, mark as complete
      setState(() {
        _permissionComplete = true;
      });

      // If permission is granted, fetch current location
      if (!viewModel.isPermissionDenied) {
        await viewModel.fetchCurrentLocation();
      }
    }
  }

  void _showPermissionDialog() {
    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(localizations.locationPermissionTitle),
          content: Text(localizations.locationPermissionSubtitle),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                final viewModel = context.read<LocationViewModel>();
                viewModel.setPermissionDenied();
                setState(() {
                  _permissionDialogShown = false;
                  _permissionComplete = true;
                });
              },
              child: Text(localizations.locationPermissionDenyButton),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                if (mounted) {
                  // Only request system permission after custom dialog approval
                  final viewModel = context.read<LocationViewModel>();
                  await viewModel.requestLocationPermission();

                  setState(() {
                    _permissionDialogShown = false;
                    _permissionComplete = true;
                  });
                }
              },
              child: Text(localizations.locationPermissionAllowButton),
            ),
          ],
        );
      },
    );
  }

  // Handle going to current location
  void _goToCurrentLocation() async {
    final viewModel = context.read<LocationViewModel>();

    // If permission is already granted, just go to current location without asking
    if (!viewModel.isPermissionDenied) {
      await viewModel.fetchCurrentLocation();

      // Move map to current location if available
      if (viewModel.currentPosition != null && _googleMapController != null) {
        _googleMapController!.animateCamera(
          CameraUpdate.newLatLng(viewModel.currentPosition!),
        );
      }
      return;
    }

    // Permission is denied - check if it's permanently denied
    if (viewModel.isPermissionPermanentlyDenied) {
      _showOpenSettingsDialog();
      return;
    }

    // Permission is denied but not permanently - request it once
    await viewModel.requestLocationPermission();

    // After request, try to use location if permission was granted
    if (!viewModel.isPermissionDenied) {
      await viewModel.fetchCurrentLocation();

      if (viewModel.currentPosition != null && _googleMapController != null) {
        _googleMapController!.animateCamera(
          CameraUpdate.newLatLng(viewModel.currentPosition!),
        );
      }
    }
  }

  // Show a dialog guiding users to open app settings for permission
  void _showOpenSettingsDialog() {
    final localizations = AppLocalizations.of(context)!;
    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(localizations.locationAccessRequired),
          content: Text(isIOS
              ? localizations.enableLocationIOS
              : localizations.enableLocationAndroid),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(localizations.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                // Track when we're opening settings
                _pausedTime = DateTime.now();

                // Open app settings
                context.read<LocationViewModel>().openLocationSettings();
              },
              child: Text(localizations.openSettings),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Remove the observer when disposing the widget
    WidgetsBinding.instance.removeObserver(this);

    if (_googleMapController != null) {
      _googleMapController!.dispose();
      _googleMapController = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
          title: localizations.storeLocation,
          onBackPressed: () {
            Navigator.pop(context);
          }),
      body: Stack(
        children: [
          // Only render the map when permission flow is complete
          if (_permissionComplete)
            LocationMap(
              onMapCreated: (controller) {
                // Save controller reference
                _googleMapController = controller;
              },
              onLocationChanged: (position) {
                // LocationMap now handles updating the selected address
                final viewModel = context.read<LocationViewModel>();
                viewModel.fetchAddressForMapPosition(position);
              },
            ),

          // Show a loading indicator while permission is being handled
          if (!_permissionComplete)
            const Center(
              child: CircularProgressIndicator(),
            ),

          // Always show the bottom sheet if permissions complete
          if (_permissionComplete)
            LocationBottomSheet(
              moveToLocation: (position) {},
            ),

          // Add the current location button above the bottom sheet
          if (_permissionComplete)
            CurrentLocationButton(
              onPressed: _goToCurrentLocation,
            ),
        ],
      ),
    );
  }
}
