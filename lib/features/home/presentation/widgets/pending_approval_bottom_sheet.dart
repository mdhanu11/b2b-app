import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:muward_b2b/core/constants/app_colors.dart';
import 'package:muward_b2b/core/widgets/reusable_green_button.dart';

class PendingApprovalBottomSheet extends StatelessWidget {
  const PendingApprovalBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return FractionallySizedBox(
      widthFactor: 1.0,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 30),
            Lottie.asset(
              'assets/animations/pending_approval.json',
              width: 120,
              height: 120,
              repeat: false,
            ),
            const SizedBox(height: 30),
            Text(
              localizations.accountPendingApprovalTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlack,
              ),
            ),
            Text(
              localizations.accountPendingApprovalStatus,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.yellow,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              localizations.accountPendingApprovalMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textBlack2,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ReusableGreenButton(
                  label: localizations.exploreNowButton,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
