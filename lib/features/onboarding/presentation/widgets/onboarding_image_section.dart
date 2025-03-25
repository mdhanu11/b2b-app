import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnboardingImageSection extends StatefulWidget {
  const OnboardingImageSection({Key? key}) : super(key: key);

  @override
  State<OnboardingImageSection> createState() => _OnboardingImageSectionState();
}

class _OnboardingImageSectionState extends State<OnboardingImageSection> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(AssetImage('assets/images/shopping_bag.png'), context);
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return SizedBox(
      height: 300,
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(
            offset: Offset(isRTL ? 120 : -120, -20),
            child: Transform.rotate(
              angle: isRTL ? -0.3 : 0.3,
              child: Image.asset(
                'assets/images/shopping_bag.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
