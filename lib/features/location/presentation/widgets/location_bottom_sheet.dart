import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/reusable_green_button.dart';
import '../../../registration/presentation/provider/registration_provider.dart';
import '../pages/location_viewmodel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationBottomSheet extends StatefulWidget {
  final Function(LatLng) moveToLocation;

  const LocationBottomSheet({Key? key, required this.moveToLocation})
      : super(key: key);

  @override
  State<LocationBottomSheet> createState() => _LocationBottomSheetState();
}

class _LocationBottomSheetState extends State<LocationBottomSheet> {
  // Constants for the draggable sheet sizing
  static const double _initialChildSize = 0.28;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return DraggableScrollableSheet(
      initialChildSize: _initialChildSize,
      minChildSize: _initialChildSize,
      maxChildSize: _initialChildSize,
      snap: true,
      snapSizes: const [],
      builder: (context, scrollController) {
        return _buildBottomSheetContainer(
            context, scrollController, localizations);
      },
    );
  }

  Widget _buildBottomSheetContainer(BuildContext context,
      ScrollController scrollController, AppLocalizations localizations) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDragIndicator(),
            _buildTitle(localizations),
            _buildContentArea(scrollController, localizations),
            _buildConfirmButton(localizations),
          ],
        ),
      ),
    );
  }

  Widget _buildDragIndicator() {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildTitle(AppLocalizations localizations) {
    return Consumer<LocationViewModel>(builder: (context, viewModel, child) {
      // Only hide the title when location is out of range
      if (viewModel.isLocationOutOfRange) {
        return const SizedBox.shrink(); // Empty widget when out of range
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            localizations.deliveringOrderTo,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildContentArea(
      ScrollController scrollController, AppLocalizations localizations) {
    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Consumer<LocationViewModel>(
              builder: (context, viewModel, _) {
                print(
                    "DEBUG: isLocationOutOfRange in UI: ${viewModel.isLocationOutOfRange}");
                return _buildLocationStatus(viewModel, localizations);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationStatus(
      LocationViewModel viewModel, AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 12),
        if (viewModel.isLocationOutOfRange)
          _buildSimpleOutOfRangeError(localizations)
        else if (viewModel.mainLocationComponent != null)
          _buildSelectedLocation(viewModel)
        else
          _buildSelectLocationPrompt(localizations),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSimpleOutOfRangeError(AppLocalizations localizations) {
    print('_buildSimpleOutOfRangeError');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            localizations.sorryNotDelivering,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            localizations.pleaseSelectLocationInSaudiArabia,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedLocation(LocationViewModel viewModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.location_on,
          color: Colors.green,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                viewModel.mainLocationComponent!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                viewModel.subLocationComponent ?? "",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectLocationPrompt(AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        localizations.selectLocationOnMap,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildConfirmButton(AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 5.0),
      child: Consumer<LocationViewModel>(
        builder: (context, viewModel, _) {
          final hasSelectedLocation = !viewModel.isLocationOutOfRange &&
              viewModel.selectedLocationName != null;
          return SizedBox(
            width: double.infinity,
            child: ReusableGreenButton(
              label: localizations.confirmAddress,
              onPressed: hasSelectedLocation
                  ? () => _handleAddressConfirmation(context, viewModel)
                  : null,
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleAddressConfirmation(
      BuildContext context, LocationViewModel viewModel) async {
    final addressModel = viewModel.getFormattedAddress();

    if (addressModel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Unable to format address, please try again.')),
      );
      return;
    }

    // Get the RegistrationProvider
    final registrationProvider =
        Provider.of<RegistrationProvider>(context, listen: false);

    try {
      // Show loading indicator
      _showLoadingDialog(context);

      // Save the location details
      await registrationProvider.saveLocationDetails(
        googleAddress: addressModel.googleAddress,
        city: addressModel.city,
        state: addressModel.state,
        country: addressModel.country,
      );

      // Dismiss loading dialog
      if (context.mounted) Navigator.pop(context);

      // Check for errors and navigate
      if (registrationProvider.error == null) {
        if (context.mounted) {
          Navigator.pushNamed(context, AppRoutes.businessDetails);
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(registrationProvider.error!)),
          );
        }
      }
    } catch (e) {
      // Dismiss loading dialog if it's showing
      if (context.mounted) Navigator.pop(context);

      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving address: $e')),
        );
      }
    }
  }

  // Helper method to show loading dialog
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
