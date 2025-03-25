import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:muward_b2b/core/widgets/reusable_green_button.dart';
import 'package:muward_b2b/core/widgets/reusable_grey_button.dart';

class LocationPermissionDialog extends StatelessWidget {
  final VoidCallback onAllow;
  final VoidCallback onDeny;

  const LocationPermissionDialog({
    super.key,
    required this.onAllow,
    required this.onDeny,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLocationIcon(),
              const SizedBox(height: 16),
              _buildTitle(localizations),
              const SizedBox(height: 8),
              _buildSubtitle(localizations),
              const SizedBox(height: 24),
              _buildPrecisionOptions(localizations),
              const SizedBox(height: 24),
              _buildButtons(localizations, context),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the location icon at the top of the dialog
  Widget _buildLocationIcon() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.location_on,
        size: 48,
        color: Colors.green,
      ),
    );
  }

  /// Builds the title text for the dialog
  Widget _buildTitle(AppLocalizations localizations) {
    return Text(
      localizations.locationPermissionTitle,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  /// Builds the subtitle text for the dialog
  Widget _buildSubtitle(AppLocalizations localizations) {
    return Text(
      localizations.locationPermissionSubtitle,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey.shade600,
      ),
    );
  }

  /// Builds the precision options (Precise and Approximate)
  Widget _buildPrecisionOptions(AppLocalizations localizations) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: _buildOption(
            title: localizations.locationPermissionPreciseTitle,
            description: localizations.locationPermissionPreciseDescription,
            icon: Icons.gps_fixed,
            isSelected: true,
          ),
        ),
        Flexible(
          child: _buildOption(
            title: localizations.locationPermissionApproximateTitle,
            description: localizations.locationPermissionApproximateDescription,
            icon: Icons.gps_not_fixed,
            isSelected: false,
          ),
        ),
      ],
    );
  }

  /// Builds an individual option (Precise or Approximate)
  Widget _buildOption({
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
  }) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? Colors.green : Colors.grey.shade300,
              width: 2,
            ),
            color: isSelected ? Colors.green.shade50 : Colors.grey.shade100,
          ),
          child: Icon(
            icon,
            size: 36,
            color: isSelected ? Colors.green : Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.green : Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  /// Builds the Allow and Deny buttons at the bottom
  Widget _buildButtons(AppLocalizations localizations, BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ReusableGreenButton(
              onPressed: () {
                Navigator.pop(context);
                onAllow();
              },
              label: localizations.locationPermissionAllowButton),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ReusableGreyButton(
            onPressed: () {
              Navigator.pop(context);
              onDeny();
            },
            label: localizations.locationPermissionDenyButton,
          ),
        ),
      ],
    );
  }
}
