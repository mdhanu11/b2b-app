import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/constants/app_colors.dart';

class OnboardingTextSection extends StatelessWidget {
  const OnboardingTextSection({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.headline1,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: AppColors.textBlack,
            ),
          ),
          Text(
            localizations.headline2,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: AppColors.textBlack,
            ),
          ),
          Text(
            localizations.headline3,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            localizations.subText,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
