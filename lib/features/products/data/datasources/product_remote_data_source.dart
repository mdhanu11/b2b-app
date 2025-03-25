import 'package:algoliasearch/algoliasearch_lite.dart';
import 'package:muward_b2b/features/products/data/datasources/product_local_data_source.dart';
import 'package:muward_b2b/features/products/domain/entities/product.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';

class ProductRemoteDataSource {
  final APIClient _apiClient;
  final ProductLocalDataSource _localDataSource;
  late final SearchClient _client;

  ProductRemoteDataSource(this._apiClient, this._localDataSource) {
    _client = SearchClient(
      appId: ApiConstants.algoliaAppId,
      apiKey: ApiConstants.algoliaApiKey,
    );
  }

  // Fetch products using Algolia with subcategory ID
  Future<List<Product>> getProducts(
    String subcategoryId, {
    int pageNumber = 1,
    int pageSize = 20,
    bool forceRefresh = false,
  }) async {
    // Try to get cached products first if not forcing refresh and on first page
    if (!forceRefresh && pageNumber == 1) {
      final cachedProducts =
          await _localDataSource.getCachedProducts(subcategoryId);
      if (cachedProducts.isNotEmpty) {
        return cachedProducts;
      }
    }
    //TODO: As I am using B2C algolia index, i had to keep subcategory of that app.
    subcategoryId = 'c8803feb-9492-4aeb-bed9-046f627d00ec';
    try {
      // Create a search request
      final request = SearchForHits(
        indexName: ApiConstants.algoliaIndexName,
        query: '', // Empty query to get all results
        page: pageNumber - 1,
        hitsPerPage: pageSize,
        filters: 'category_ids:$subcategoryId',
      );

      // Execute the search
      final response = await _client.searchIndex(request: request);

      print(response);

      // Convert hits to products
      final products =
          response.hits.map((hit) => Product.fromAlgolia(hit)).toList();

      // Cache products if this is the first page
      if (pageNumber == 1) {
        await _localDataSource.cacheProducts(subcategoryId, products);
      }

      return products;
    } catch (e) {
      print('Algolia error: $e');

      // Try to get cached products if we haven't already
      if (forceRefresh && pageNumber == 1) {
        final cachedProducts =
            await _localDataSource.getCachedProducts(subcategoryId);
        if (cachedProducts.isNotEmpty) {
          return cachedProducts;
        }
      }

      // Try API as fallback
      return getProductsViaAPI(subcategoryId,
          pageNumber: pageNumber, pageSize: pageSize);
    }
  }

  // Search products by query text using Algolia
  Future<List<Product>> searchProducts(
    String query, {
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    try {
      // Create a search request
      final request = SearchForHits(
        indexName: ApiConstants.algoliaIndexName,
        query: query,
        page: pageNumber - 1,
        hitsPerPage: pageSize,
      );

      // Execute the search
      final response = await _client.searchIndex(request: request);

      // Convert hits to products
      return response.hits.map((hit) => Product.fromAlgolia(hit)).toList();
    } catch (e) {
      print('Algolia search error: $e');
      throw Exception('Failed to search products via Algolia: $e');
    }
  }

  // Fetch products by multiple subcategory IDs
  Future<List<Product>> getProductsBySubcategoryIds(
    List<String> subcategoryIds, {
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    try {
      // Build OR filter for multiple subcategory IDs
      final List<String> filterParts =
          subcategoryIds.map((id) => 'category_ids:$id').toList();
      final String filterString = filterParts.join(' OR ');

      // Create a search request
      final request = SearchForHits(
        indexName: ApiConstants.algoliaIndexName,
        query: '',
        page: pageNumber - 1,
        hitsPerPage: pageSize,
        filters: filterString,
      );

      // Execute the search
      final response = await _client.searchIndex(request: request);

      // Convert hits to products
      return response.hits.map((hit) => Product.fromAlgolia(hit)).toList();
    } catch (e) {
      print('Algolia getProductsBySubcategoryIds error: $e');
      throw Exception('Failed to fetch products by subcategory IDs: $e');
    }
  }

  // Fallback method to use the Emporix API if needed
  Future<List<Product>> getProductsViaAPI(
    String subcategoryId, {
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.products,
        queryParameters: {
          'subcategoryId': subcategoryId,
          'pageNumber': pageNumber,
          'pageSize': pageSize,
        },
        apiType: ApiType.emporix,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        final List<Map<String, dynamic>> productsJson =
            List<Map<String, dynamic>>.from(data);

        final products =
            productsJson.map((json) => Product.fromJson(json)).toList();

        // Cache the products if this is the first page
        if (pageNumber == 1) {
          await _localDataSource.cacheProducts(subcategoryId, products);
        }

        return products;
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('API fallback error: $e');
      throw Exception('Failed to fetch products via API: $e');
    }
  }

  // Make sure to dispose of the client when it's no longer needed
  void dispose() {
    _client.dispose();
  }
}
