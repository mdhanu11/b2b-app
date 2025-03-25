import 'package:flutter/material.dart';
import 'package:muward_b2b/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/language_switcher.dart';
import '../widgets/onboarding_button_section.dart';
import '../widgets/onboarding_image_section.dart';
import '../widgets/onboarding_text_section.dart';
import 'package:muward_b2b/core/providers/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // **Main Onboarding Content**
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      OnboardingImageSection(),
                      SizedBox(height: 10),
                      OnboardingTextSection(),
                      SizedBox(height: 30),
                      OnboardingButtonSection(),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            },
          ),

          Positioned.directional(
            textDirection: Directionality.of(context),
            top: 70,
            end: 20,
            child: const LanguageSwitcher(),
          ),
        ],
      ),
    );
  }
}
