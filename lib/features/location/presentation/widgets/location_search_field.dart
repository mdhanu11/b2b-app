import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../pages/location_viewmodel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationSearchField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback? onTextCleared;

  const LocationSearchField({
    Key? key,
    required this.controller,
    required this.focusNode,
    this.onTextCleared,
  }) : super(key: key);

  @override
  State<LocationSearchField> createState() => _LocationSearchFieldState();
}

class _LocationSearchFieldState extends State<LocationSearchField> {
  // Debounce timer to avoid excessive API calls
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final viewModel = Provider.of<LocationViewModel>(context, listen: false);

    return CustomTextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      hintText: localizations.searchPlaceholder,
      hasPrefixIcon: true,
      suffixIcon: widget.controller.text.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                widget.controller.clear();
                viewModel.clearSearch();
                if (widget.onTextCleared != null) {
                  widget.onTextCleared!();
                }
              },
            )
          : null,
      backgroundColor: Colors.white,
      onChanged: (query) {
        // Cancel any previous debounce timer
        if (_debounce?.isActive ?? false) _debounce!.cancel();

        // Handle empty query specially
        if (query.isEmpty) {
          viewModel.clearSearch();
          return;
        }

        // Set up a new debounce timer for non-empty queries
        _debounce = Timer(const Duration(milliseconds: 500), () {
          viewModel.fetchPlacePredictions(query);
        });
      },
    );
  }
}
