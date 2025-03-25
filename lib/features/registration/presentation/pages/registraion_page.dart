import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:muward_b2b/core/constants/app_colors.dart';
import 'package:muward_b2b/core/widgets/custom_app_ bar.dart';
import 'package:muward_b2b/core/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/reusable_green_button.dart';
import '../../../../core/widgets/reusable_grey_button.dart';
import '../provider/registration_provider.dart';
import '../widgets/country_picker_field.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String selectedCountryCode = '+966';
  bool isNextButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_updateNextButtonState);
    nameController.addListener(_updateNextButtonState);
  }

  @override
  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void _updateNextButtonState() {
    setState(() {
      isNextButtonEnabled =
          phoneController.text.isNotEmpty && nameController.text.isNotEmpty;
    });
  }

  void _selectCountry(String countryCode) {
    setState(() {
      selectedCountryCode = countryCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              _buildHeader(localizations),
              const SizedBox(height: 16),
              _buildCountryPickerField(),
              const SizedBox(height: 25),
              _buildFullNameField(localizations),
              const SizedBox(height: 10),
              _buildNextButton(localizations),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the header section with title and subtitle
  Widget _buildHeader(AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.enterYourDetails,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textBlack1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            localizations.enterDetailsSubtext,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textGrey1,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the country picker field with phone number input
  Widget _buildCountryPickerField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: CountryPickerField(
        selectedCountryCode: selectedCountryCode,
        phoneController: phoneController,
        onCountrySelected: _selectCountry,
      ),
    );
  }

  /// Builds the full name input field
  Widget _buildFullNameField(AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.fullName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textBlack2,
            ),
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: nameController,
            hintText: localizations.enterYourName,
          ),
        ],
      ),
    );
  }

  /// Builds the next button, dynamically switching between green and grey
  Widget _buildNextButton(AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: isNextButtonEnabled
            ? ReusableGreenButton(
                label: localizations.nextButton,
                onPressed: () {
                  _onNextPressed();
                },
              )
            : ReusableGreyButton(
                label: localizations.nextButton,
                onPressed: () {},
              ),
      ),
    );
  }

  void _onNextPressed() {
    final provider = Provider.of<RegistrationProvider>(context, listen: false);
    provider
        .savePersonalDetails(
      name: nameController.text,
      phoneNumber: phoneController.text,
      countryCode: selectedCountryCode,
    )
        .then((_) {
      Navigator.pushNamed(context, AppRoutes.location);
    });
  }
}
