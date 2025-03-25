import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/subcategory.dart';
import '../product_view_model.dart';
import '../subcategory_view_model.dart';
import '../widgets/product_grid.dart';
import '../widgets/product_skeleton.dart';
import '../widgets/subcategory_tabs.dart';
import '../widgets/top_bar.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  bool _selectionComplete = false;

  void _onSearchPressed() {
    // Navigate to search page
  }

  void _addToCart(Product product) {
    final localizations = AppLocalizations.of(context)!;

    // Add product to cart
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations.addedToCart(product.name)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // Set loading state immediately for skeleton display
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // Set ProductViewModel to loading immediately
      final productViewModel =
          Provider.of<ProductViewModel>(context, listen: false);
      productViewModel.setLoading(true);

      // Use a delay to ensure everything is initialized
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        _selectFirstSubcategory();
      });
    });
  }

  void _selectFirstSubcategory() {
    if (_selectionComplete) return;

    final subcategoryViewModel =
        Provider.of<SubcategoryViewModel>(context, listen: false);
    final productViewModel =
        Provider.of<ProductViewModel>(context, listen: false);

    // Check if we have the necessary data
    if (subcategoryViewModel.categoryId == null) return;

    if (subcategoryViewModel.subcategories.isNotEmpty) {
      _selectionComplete = true;
      final firstSubcategory = subcategoryViewModel.subcategories.first;

      // Execute the selection
      subcategoryViewModel.selectSubcategory(firstSubcategory);
      productViewModel.fetchProductsBySubcategory(firstSubcategory);

      debugPrint("Auto-selected subcategory: ${firstSubcategory.name}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final subcategoryViewModel = context.watch<SubcategoryViewModel>();
    final productViewModel = context.watch<ProductViewModel>();
    final localizations = AppLocalizations.of(context)!;

    // If subcategories loaded but selection hasn't happened
    if (!_selectionComplete &&
        subcategoryViewModel.subcategories.isNotEmpty &&
        subcategoryViewModel.categoryId != null) {
      // Schedule selection for after this build
      Future.microtask(() => _selectFirstSubcategory());
    }

    // If category info is missing, return to previous page
    if (subcategoryViewModel.categoryId == null ||
        subcategoryViewModel.categoryName == null) {
      // Added a short delay before popping to avoid build issues
      Future.microtask(() => Navigator.pop(context));
      return Scaffold(
        body: SafeArea(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return SkeletonLoading(
                child: ProductSkeleton(),
              );
            },
          ),
        ),
      );
    }

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: TopBar(
          title: subcategoryViewModel.categoryName!,
          onSearchPressed: _onSearchPressed,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subcategory tabs
            SubcategoryTabsWidget(
              parentCategoryId: subcategoryViewModel.categoryId!,
              onSubcategorySelected: (subcategory) {
                subcategoryViewModel.selectSubcategory(subcategory);
                productViewModel.fetchProductsBySubcategory(subcategory);
              },
              onSubcategoriesLoaded: (subcategories) {
                if (!_selectionComplete && subcategories.isNotEmpty) {
                  Future.microtask(() => _selectFirstSubcategory());
                }
              },
            ),

            // Display selected subcategory products
            if (subcategoryViewModel.selectedSubcategory != null)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                child: Text(
                  subcategoryViewModel.selectedSubcategory!.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // Handle errors at the product level
            if (productViewModel.hasError)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.error_outline,
                        color: Theme.of(context).colorScheme.error),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        productViewModel.error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (subcategoryViewModel.selectedSubcategory != null) {
                          productViewModel.fetchProductsBySubcategory(
                              subcategoryViewModel.selectedSubcategory!);
                        }
                      },
                      child: Text(localizations.retry),
                    ),
                  ],
                ),
              ),

            // Show the product grid or skeleton regardless of subcategory selection
            Expanded(
              child: Builder(
                builder: (context) {
                  // Force loading state for immediate skeleton display
                  if (!_selectionComplete || productViewModel.isLoading) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return SkeletonLoading(
                          child: ProductSkeleton(),
                        );
                      },
                    );
                  }

                  // Once loaded, show actual products
                  return subcategoryViewModel.selectedSubcategory != null
                      ? ProductsGrid(
                          products: productViewModel.products,
                          favoriteProductIds:
                              productViewModel.favoriteProductIds,
                          onAddToCart: _addToCart,
                          onToggleFavorite: productViewModel.toggleFavorite,
                          isLoading: false, // We're handling loading ourselves
                        )
                      : Center(
                          child: Text(
                            localizations.noSubcategoriesAvailable,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
