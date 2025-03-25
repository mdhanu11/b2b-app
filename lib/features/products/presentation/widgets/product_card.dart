import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final VoidCallback onToggleFavorite;
  final bool isFavorite;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onToggleFavorite,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!product.available) {
      return _buildUnavailableProductCard(context);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      // Use LayoutBuilder to ensure the card adapts to available space
      child: LayoutBuilder(builder: (context, constraints) {
        // Calculate image height (let's use 60% of total height for image)
        final imageHeight = constraints.maxHeight * 0.6;
        // The rest is for details
        final detailsHeight = constraints.maxHeight - imageHeight;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with fixed height
            SizedBox(
              height: imageHeight,
              child: _buildImageSection(),
            ),

            // Product details with fixed height and scrolling if needed
            SizedBox(
              height: detailsHeight,
              child: _buildProductDetails(context),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildUnavailableProductCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate image height (60% of total height)
          final imageHeight = constraints.maxHeight * 0.6;
          // The rest is for details
          final detailsHeight = constraints.maxHeight - imageHeight;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Unavailable product image with fixed height
              SizedBox(
                height: imageHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Opacity(
                          opacity: 0.5,
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.image_not_supported_outlined,
                                    size: 40, color: Colors.grey),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.05),
                      child: const Center(
                        child: Text(
                          'Out of Stock',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Grayed out product details with fixed height
              SizedBox(
                height: detailsHeight,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (product.weight.isNotEmpty)
                        Text(
                          product.weight,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Product image
        Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade100,
                  child: const Center(
                    child: Icon(Icons.image_not_supported_outlined,
                        size: 40, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
        ),

        // Favorite button
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                size: 18,
                color: isFavorite ? Colors.red : Colors.grey.shade600,
              ),
              onPressed: onToggleFavorite,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ),

        // Discount badge if applicable
        if (product.calculatedDiscountPercentage != null)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${product.calculatedDiscountPercentage}% OFF',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        // Add to cart button
        Positioned(
          bottom: 0,
          right: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.add, size: 18, color: Colors.blue),
              onPressed: onAddToCart,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Use minimum space needed
        children: [
          // Price section
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'SAR',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                product.price.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (product.originalPrice != null) ...[
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'SAR ${product.originalPrice!.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                      decoration: TextDecoration.lineThrough,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),

          // Product name - use Flexible to allow text to adjust
          const SizedBox(height: 4),
          Flexible(
            child: Text(
              product.name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Weight if available - use smaller font
          if (product.weight.isNotEmpty)
            Text(
              product.weight,
              style: TextStyle(
                fontSize: 10, // Smaller font
                color: Colors.grey.shade600,
              ),
            ),

          // Carton info if available - only show if space permits
          if (product.cartonInfo != null)
            Text(
              product.cartonInfo!,
              style: TextStyle(
                fontSize: 9, // Even smaller font
                color: Colors.grey.shade600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

          // Express or Promoted or Best Seller tag - build only if there's room
          Flexible(
            fit: FlexFit.loose,
            child: _buildProductTag(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductTag() {
    if (product.isExpress) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        margin: const EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
          color: Colors.amber.shade800,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'Express',
          style: TextStyle(
            color: Colors.white,
            fontSize: 9, // Smaller font size
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else if (product.isPromoted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        margin: const EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'Promoted',
          style: TextStyle(
            color: Colors.white,
            fontSize: 9, // Smaller font size
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else if (product.isBestSeller) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        margin: const EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'Best seller',
          style: TextStyle(
            color: Colors.black,
            fontSize: 9, // Smaller font size
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
