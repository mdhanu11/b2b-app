import 'package:flutter/material.dart';
import 'package:muward_b2b/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../products/presentation/subcategory_view_model.dart';
import '../../domain/entities/home_category.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryGrid extends StatelessWidget {
  final List<HomeCategory> categories;

  const CategoryGrid({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLanguageCode = localeProvider.locale.languageCode;
    final localizations = AppLocalizations.of(context)!;
    final isRTL = currentLanguageCode == 'ar';

    // Create empty rows
    List<List<HomeCategory>> rows = [[], [], []];

    // Distribute categories into rows
    for (int i = 0; i < categories.length; i++) {
      rows[i % 3].add(categories[i]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            localizations.shopByCategory,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 15),
        _buildCategoryGridView(context, rows, currentLanguageCode, isRTL),
      ],
    );
  }

  Widget _buildCategoryGridView(BuildContext context,
      List<List<HomeCategory>> rows, String languageCode, bool isRTL) {
    // Safety check for empty rows
    if (rows.isEmpty || rows[0].isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      // For RTL, reverse the primary scroll direction
      reverse: isRTL,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Generate columns in the right order
        children: List.generate(rows[0].length, (columnIndex) {
          // For RTL, we need to reverse the column order
          final adjustedColumnIndex =
              isRTL ? rows[0].length - 1 - columnIndex : columnIndex;

          return Padding(
            // Adjust padding for RTL
            padding: isRTL
                ? const EdgeInsets.only(left: 15.0)
                : const EdgeInsets.only(right: 15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(rows.length, (rowIndex) {
                if (rowIndex >= rows.length ||
                    adjustedColumnIndex >= rows[rowIndex].length) {
                  return const SizedBox(height: 120);
                }

                final category = rows[rowIndex][adjustedColumnIndex];
                return _buildCategoryTile(context, category, languageCode);
              }),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCategoryTile(
      BuildContext context, HomeCategory category, String languageCode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: () {
          print(category.name);
          Future.delayed(Duration(milliseconds: 200), () {
            navigateToProductList(context, category.id, category.name);
          });
        },
        child: Column(
          children: [
            _buildCategoryImage(category.getImageUrl(languageCode)),
            const SizedBox(height: 4),
            _buildCategoryName(category.getLocalizedName(languageCode)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryImage(String imageUrl) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000), // 8% opacity black
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                          child: SizedBox(
                            width: 10.0,
                            height: 10.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 40,
                        );
                      },
                    )
                  : const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 40,
                    ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: const Color(0x1A9E9E9E), width: 1),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryName(String name) {
    return SizedBox(
      width: 88,
      height: 40,
      child: Center(
        child: Text(
          name,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  void navigateToProductList(
      BuildContext context, String categoryId, String categoryName) {
    // Set the category in the ViewModel
    context.read<SubcategoryViewModel>().setCategory(categoryId, categoryName);

    // Navigate to the product list page
    Navigator.of(context).pushNamed(AppRoutes.products);
  }
}
