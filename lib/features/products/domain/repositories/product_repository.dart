import 'package:muward_b2b/features/products/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProductsBySubcategory(String subcategoryId);
  Future<List<Product>> searchProducts(String query);
  Future<Set<String>> getFavoriteProductIds();
  Future<void> toggleFavoriteProduct(String productId);
  Future<List<Product>> getMockProducts();
}
