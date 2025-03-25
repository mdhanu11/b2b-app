import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../domain/entities/product.dart';
import 'product_card.dart';
import 'product_skeleton.dart'; // Import the new skeleton widget

class ProductsGrid extends StatelessWidget {
  final List<Product> products;
  final Set<String> favoriteProductIds;
  final Function(Product) onAddToCart;
  final Function(Product) onToggleFavorite;
  final bool isLoading;

  const ProductsGrid({
    super.key,
    required this.products,
    this.favoriteProductIds = const {},
    required this.onAddToCart,
    required this.onToggleFavorite,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Show empty state if not loading and no products
    if (!isLoading && products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category_outlined,
                size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              localizations.noProductsAvailable,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    // Use LayoutBuilder to ensure grid adapts to available space
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate width based on available space and desired padding
        final horizontalPadding = 16.0;
        final crossAxisSpacing = 16.0;
        final screenWidth = constraints.maxWidth;
        final availableWidth =
            screenWidth - (horizontalPadding * 2) - crossAxisSpacing;
        final itemWidth = availableWidth / 2; // 2 items per row

        // Set an appropriate child aspect ratio based on content
        // This ratio controls the height relative to width (width/height)
        const childAspectRatio =
            0.75; // Taller cards (width is 0.75 times the height)

        return GridView.builder(
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: 16.0,
          ),
          // If loading, show skeleton items (6 placeholders)
          itemCount: isLoading ? 6 : products.length,
          itemBuilder: (context, index) {
            // Return skeleton items while loading
            if (isLoading) {
              return SkeletonLoading(
                child: ProductSkeleton(),
              );
            }

            // Otherwise, return actual product cards
            final product = products[index];
            return ProductCard(
              product: product,
              isFavorite: favoriteProductIds.contains(product.id),
              onAddToCart: () => onAddToCart(product),
              onToggleFavorite: () => onToggleFavorite(product),
            );
          },
        );
      },
    );
  }
}
