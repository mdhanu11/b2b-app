import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/utils/shared_prefs_helper.dart';
import '../../../../core/widgets/custom_app_ bar.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../../../../core/widgets/reusable_green_button.dart';
import '../../../../core/widgets/reusable_grey_button.dart';
import '../provider/registration_provider.dart';

class BusinessDetailsPage extends StatefulWidget {
  const BusinessDetailsPage({super.key});

  @override
  State<BusinessDetailsPage> createState() => _BusinessDetailsState();
}

class _BusinessDetailsState extends State<BusinessDetailsPage> {
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController crController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isSubmitButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    nationalIdController.addListener(_validateForm);
    birthdayController.addListener(_validateForm);
    crController.addListener(_validateForm);
    emailController.addListener(_validateForm);
  }

  @override
  void dispose() {
    nationalIdController.dispose();
    birthdayController.dispose();
    crController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      isSubmitButtonEnabled = nationalIdController.text.isNotEmpty &&
          birthdayController.text.isNotEmpty &&
          crController.text.isNotEmpty &&
          emailController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final registrationProvider = Provider.of<RegistrationProvider>(context);

    // Show loading indicator if provider is loading
    if (registrationProvider.isLoading) {
      return Scaffold(
        appBar: CustomAppBar(
          title: localizations.createAccount,
          onBackPressed: () {
            Navigator.pop(context);
          },
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.createAccount,
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _buildHeader(localizations),
                        const SizedBox(height: 16),
                        _buildNationalIdField(localizations),
                        const SizedBox(height: 16),
                        _buildDateField(localizations),
                        const SizedBox(height: 16),
                        _buildCrNumberField(localizations),
                        const SizedBox(height: 16),
                        _buildEmailField(localizations),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _buildSubmitButton(context, localizations),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.enterBusinessDetails,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textBlack1,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildNationalIdField(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.nationalId,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textBlack2,
          ),
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: nationalIdController,
          hintText: localizations.enterIqamaNumber,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
      ],
    );
  }

  Widget _buildDateField(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.dateOfBirth,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textBlack2,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              birthdayController.text =
                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
              _validateForm();
            }
          },
          child: AbsorbPointer(
            child: CustomTextField(
              controller: birthdayController,
              hintText: localizations.selectDob,
              readOnly: true,
              suffixIcon: Icon(
                Icons.calendar_today,
                color: AppColors.textGrey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCrNumberField(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.crNumber,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textBlack2,
          ),
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: crController,
          hintText: localizations.enterCrNumber,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
      ],
    );
  }

  Widget _buildEmailField(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.email,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textBlack2,
          ),
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: emailController,
          hintText: localizations.enterEmail,
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  Widget _buildSubmitButton(
      BuildContext context, AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: isSubmitButtonEnabled
            ? ReusableGreenButton(
                label: localizations.createAccountButton,
                onPressed: () {
                  _handleSubmit(context, localizations);
                },
              )
            : ReusableGreyButton(
                label: localizations.createAccountButton,
                onPressed: () {},
              ),
      ),
    );
  }

  void _handleSubmit(
      BuildContext context, AppLocalizations localizations) async {
    // Get provider with listen: false to avoid rebuild
    final registrationProvider =
        Provider.of<RegistrationProvider>(context, listen: false);

    // Format date for API (YYYY-MM-DD)
    final dateParts = birthdayController.text.split('/');
    final formattedDate = dateParts.length == 3
        ? "${dateParts[2]}-${dateParts[1]}-${dateParts[0]}"
        : birthdayController.text;

    try {
      // Save business details
      await registrationProvider.saveBusinessDetails(
        email: emailController.text,
        company: "Riyad Cafe", //TODO: Change this company name later
        crNumber: crController.text,
        nationalId: nationalIdController.text,
        dob: formattedDate,
      );

      // Submit registration to API
      final success = await registrationProvider.submitRegistration();

      if (success) {
        await SharedPrefsHelper.setBool(AppConstants.successPopupKey, true);
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.home,
            (route) => false,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(localizations.registrationFailed)));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }
}
