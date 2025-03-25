import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:muward_b2b/core/constants/app_routes.dart';
import '../../../../core/widgets/reusable_green_button.dart';
import '../../../../core/widgets/reusable_grey_button.dart';

class OnboardingButtonSection extends StatelessWidget {
  const OnboardingButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ReusableGreyButton(
            label: localizations.skipButton,
            onPressed: () {
              // Handle Skip button
            },
          ),
          const SizedBox(height: 20),
          ReusableGreenButton(
            label: localizations.getStartedButton,
            onPressed: () {
              Future.delayed(Duration(milliseconds: 200), () {
                Navigator.pushNamed(context, AppRoutes.registration);
              });
            },
          ),
        ],
      ),
    );
  }
}
