import 'package:flutter/material.dart';
import 'package:muward_b2b/core/constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RfqBanner extends StatelessWidget {
  const RfqBanner({
    super.key,
    this.onGetQuotePressed,
  });

  final VoidCallback? onGetQuotePressed;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Stack(
        children: [
          _buildBackgroundRays(isRtl),
          _buildBannerContent(context, localizations, isRtl),
        ],
      ),
    );
  }

  Widget _buildBackgroundRays(bool isRtl) {
    return Positioned(
      right: isRtl ? null : -220,
      left: isRtl ? -220 : null,
      child: Transform.rotate(
        angle: isRtl ? 0.85 : -0.85,
        child: Image.asset(
          'assets/images/rfq_rays.png',
          width: 700.0,
          height: 200.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildBannerContent(
    BuildContext context,
    AppLocalizations localizations,
    bool isRtl,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        left: isRtl ? 8 : 16,
        right: isRtl ? 16 : 8,
        top: 16,
        bottom: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isRtl) _buildImage(),
          Expanded(
            child: _buildTextContent(context, localizations),
          ),
          if (!isRtl) _buildImage(),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Image.asset(
      'assets/images/rfq_img.png',
      width: 80.0,
      height: 80.0,
      fit: BoxFit.contain,
    );
  }

  Widget _buildTextContent(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.unlockBetterPricing,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          localizations.getBestDeals,
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 12.0),
        // Simple approach to ensure button visibility
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextButton(
            onPressed: onGetQuotePressed ?? () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: const Size(100, 30),
            ),
            child: Text(
              localizations.getQuote,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
