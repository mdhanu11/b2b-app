import 'package:flutter/material.dart';
import 'package:muward_b2b/core/constants/app_colors.dart';

class ReusableGreyButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final ButtonStyle? buttonStyle;

  const ReusableGreyButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.buttonStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: buttonStyle ??
          ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.lightGrey,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
      child: Text(label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          )),
    );
  }
}
