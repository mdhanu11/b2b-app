import 'package:flutter/foundation.dart';
import 'package:muward_b2b/features/products/domain/entities/product.dart';
import 'package:muward_b2b/features/products/domain/entities/subcategory.dart';
import 'package:muward_b2b/features/products/domain/usecases/get_favorite_products_usecase.dart';
import 'package:muward_b2b/features/products/domain/usecases/get_products_by_subcategory_usecase.dart';
import 'package:muward_b2b/features/products/domain/usecases/toggle_favorite_product_usecase.dart';

class ProductViewModel extends ChangeNotifier {
  final GetProductsBySubcategoryUsecase _getProductsUseCase;
  final GetFavoriteProductIdsUseCase _getFavoriteProductIdsUseCase;
  final ToggleFavoriteProductUseCase _toggleFavoriteProductUseCase;

  // State variables
  List<Product> _products = [];
  Set<String> _favoriteProductIds = {};
  bool _isLoading = false;
  String? _error;
  Subcategory? _selectedSubcategory;

  // Getters
  List<Product> get products => _products;
  Set<String> get favoriteProductIds => _favoriteProductIds;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Subcategory? get selectedSubcategory => _selectedSubcategory;
  bool get hasError => _error != null;

  ProductViewModel({
    required GetProductsBySubcategoryUsecase getProductsUseCase,
    required GetFavoriteProductIdsUseCase getFavoriteProductIdsUseCase,
    required ToggleFavoriteProductUseCase toggleFavoriteProductUseCase,
  })  : _getProductsUseCase = getProductsUseCase,
        _getFavoriteProductIdsUseCase = getFavoriteProductIdsUseCase,
        _toggleFavoriteProductUseCase = toggleFavoriteProductUseCase {
    _loadFavoriteProductIds();
  }

  Future<void> _loadFavoriteProductIds() async {
    try {
      _favoriteProductIds = await _getFavoriteProductIdsUseCase.execute();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading favorite products: $e');
    }
  }

  Future<void> fetchProductsBySubcategory(Subcategory subcategory) async {
    _selectedSubcategory = subcategory;
    _isLoading = true;
    _error = null;
    notifyListeners();

    print('subcategory name ${subcategory.name}');

    try {
      _products = await _getProductsUseCase.call(subcategory.id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Product product) async {
    try {
      // Optimistically update UI
      if (_favoriteProductIds.contains(product.id)) {
        _favoriteProductIds.remove(product.id);
      } else {
        _favoriteProductIds.add(product.id);
      }
      notifyListeners();

      // Persist changes
      await _toggleFavoriteProductUseCase.execute(product.id);
    } catch (e) {
      // Revert UI changes if operation fails
      await _loadFavoriteProductIds();
      debugPrint('Error toggling favorite: $e');
    }
  }

  bool isFavorite(String productId) {
    return _favoriteProductIds.contains(productId);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
