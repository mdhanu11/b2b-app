import 'package:muward_b2b/features/products/data/datasources/product_local_data_source.dart';
import 'package:muward_b2b/features/products/data/datasources/product_remote_data_source.dart';
import 'package:muward_b2b/features/products/domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  final ProductLocalDataSource _localDataSource;

  ProductRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<Product>> getProductsBySubcategory(
    String subcategoryId, {
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    try {
      print('ProductRepositoryImpl');
      // Try to get from remote
      final products = await _remoteDataSource.getProducts(subcategoryId,
          pageNumber: pageNumber, pageSize: pageSize, forceRefresh: true);

      // Cache the results if successful and it's the first page
      if (products.isNotEmpty && pageNumber == 1) {
        await _localDataSource.cacheProducts(subcategoryId, products);
      }

      return products;
    } catch (e) {
      // If remote fails and it's the first page, try to get from cache
      if (pageNumber == 1) {
        final cachedProducts =
            await _localDataSource.getCachedProducts(subcategoryId);
        if (cachedProducts.isNotEmpty) {
          return cachedProducts;
        }
      }

      // Re-throw the exception if we couldn't get from cache or it's not the first page
      rethrow;
    }
  }

  @override
  Future<List<Product>> searchProducts(
    String query, {
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    return await _remoteDataSource.searchProducts(
      query,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  @override
  Future<Set<String>> getFavoriteProductIds() async {
    return await _localDataSource.getFavoriteProductIds();
  }

  @override
  Future<void> toggleFavoriteProduct(String productId) async {
    final favorites = await _localDataSource.getFavoriteProductIds();

    if (favorites.contains(productId)) {
      favorites.remove(productId);
    } else {
      favorites.add(productId);
    }

    await _localDataSource.saveFavoriteProductIds(favorites);
  }

  @override
  Future<List<Product>> getMockProducts() {
    // Implement this method based on your requirements
    // For example, return some hardcoded products for testing
    throw UnimplementedError();
  }
}
