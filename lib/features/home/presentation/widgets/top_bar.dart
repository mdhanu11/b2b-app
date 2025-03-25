import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TopBar extends StatelessWidget {
  final VoidCallback onCityButtonPressed;

  const TopBar({
    super.key,
    required this.onCityButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.selectCity,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textGrey,
                    ),
                  ),
                  GestureDetector(
                    onTap: onCityButtonPressed,
                    child: Row(
                      children: [
                        Text(
                          "Riyadh",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textBlack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 6),
                        Image.asset('assets/images/drop_down.png'),
                      ],
                    ),
                  ),
                ],
              ),

              // Points Indicator
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.star, color: Colors.green, size: 16),
                    SizedBox(width: 4),
                    Text(
                      "15k",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 2.0),
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: TextField(
              decoration: InputDecoration(
                fillColor: AppColors.lightGrey,
                border: InputBorder.none,
                hintText: localizations.lookingForSomething,
                icon: Image.asset('assets/images/search.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
