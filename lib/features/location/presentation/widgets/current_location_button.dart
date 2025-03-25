import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/location_viewmodel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CurrentLocationButton extends StatelessWidget {
  final Function() onPressed;

  const CurrentLocationButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: MediaQuery.of(context).size.height * 0.25 + 16,
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
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.all(12),
              child: const Icon(
                Icons.my_location,
                color: Colors.green,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
