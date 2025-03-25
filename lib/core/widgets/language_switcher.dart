import 'package:flutter/material.dart';
import 'package:muward_b2b/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:muward_b2b/core/providers/locale_provider.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Consumer instead of Provider.of to ensure rebuilds
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        final bool isEnglish = localeProvider.locale.languageCode == 'en';
        print(
            'Building LanguageSwitcher. Current locale: ${localeProvider.locale.languageCode}');

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: const [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
            children: [
              _buildAnimatedLanguageOption(
                context: context,
                localeProvider: localeProvider,
                isSelected: isEnglish,
                label: "EN",
                flagEmoji: "🇬🇧",
                locale: const Locale('en'),
                alignment: Alignment.centerLeft,
              ),
              _buildAnimatedLanguageOption(
                context: context,
                localeProvider: localeProvider,
                isSelected: !isEnglish,
                label: "عربي",
                flagEmoji: "🇸🇦",
                locale: const Locale('ar'),
                alignment: Alignment.centerRight,
              ),
            ],
          ),
        );
      },
    );
  }

  /// **Smooth Animated Language Toggle Option**
  Widget _buildAnimatedLanguageOption({
    required BuildContext context,
    required LocaleProvider localeProvider,
    required bool isSelected,
    required String label,
    required String flagEmoji,
    required Locale locale,
    required Alignment alignment,
  }) {
    return GestureDetector(
      onTap: () {
        print('Tapped on ${locale.languageCode}');
        localeProvider.setLocale(locale);
        print('After setLocale: ${localeProvider.locale.languageCode}');
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedAlign(
              alignment: isSelected ? Alignment.center : Alignment.centerLeft,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              child: Text(
                flagEmoji,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(width: 6),
            AnimatedOpacity(
              opacity: isSelected ? 1.0 : 0.6,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
