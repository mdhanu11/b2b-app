import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muward_b2b/core/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final bool isPassword;
  final ValueChanged<String>? onChanged;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry contentPadding;
  final double height;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final Color backgroundColor;
  final bool hasPrefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.onChanged,
    this.textStyle,
    this.hintStyle,
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: 14.0,
      horizontal: 12.0,
    ),
    this.height = 50.0,
    this.inputFormatters,
    this.maxLength,
    this.backgroundColor = Colors.white,
    this.hasPrefixIcon = false,
    this.suffixIcon,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        obscureText: isPassword,
        onChanged: onChanged,
        readOnly: readOnly,
        inputFormatters: [
          if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
          if (inputFormatters != null) ...inputFormatters!,
        ],
        style: textStyle ??
            const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
        decoration: InputDecoration(
            filled: hasPrefixIcon,
            fillColor: backgroundColor,
            hintText: hintText,
            suffixIcon: suffixIcon,
            hintStyle: hintStyle ??
                const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
            contentPadding: contentPadding,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: AppColors.borderGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: AppColors.borderGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: AppColors.borderGrey),
            ),
            prefixIcon: hasPrefixIcon ? const Icon(Icons.search) : null),
      ),
    );
  }
}
