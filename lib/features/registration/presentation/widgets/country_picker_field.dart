import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/services.dart';
import 'package:muward_b2b/core/constants/app_colors.dart';
import 'package:muward_b2b/core/widgets/custom_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CountryPickerField extends StatefulWidget {
  final String selectedCountryCode;
  final TextEditingController phoneController;
  final ValueChanged<String> onCountrySelected;

  const CountryPickerField({
    super.key,
    required this.selectedCountryCode,
    required this.phoneController,
    required this.onCountrySelected,
  });

  @override
  State<CountryPickerField> createState() => _CountryPickerFieldState();
}

class _CountryPickerFieldState extends State<CountryPickerField> {
  late FocusNode phoneFocusNode;

  @override
  void initState() {
    super.initState();
    phoneFocusNode = FocusNode();

    // Request focus on the phone TextField after the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      phoneFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      children: [
        // Country Picker
        GestureDetector(
          onTap: () {
            showCountryPicker(
              context: context,
              onSelect: (Country country) {
                widget.onCountrySelected('+${country.phoneCode}');
              },
            );
          },
          child: Container(
            width: 100,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderGrey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.selectedCountryCode,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 15),
                Image.asset(
                  'assets/images/drop_down.png',
                  width: 14,
                  height: 14,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Phone Number Field
        Expanded(
          child: CustomTextField(
            controller: widget.phoneController,
            hintText: localizations.enterPhoneNumber,
            focusNode: phoneFocusNode,
            maxLength: 15,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ),
      ],
    );
  }
}
