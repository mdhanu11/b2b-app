import 'dart:convert';
import 'package:muward_b2b/core/utils/shared_prefs_helper.dart';
import 'package:muward_b2b/features/products/domain/entities/product.dart';

class ProductLocalDataSource {
  // Keys for SharedPreferences
  static const String _productsCacheKeyPrefix = 'CACHED_PRODUCTS_';
  static const String _favoriteProductsKey = 'FAVORITE_PRODUCT_IDS';

  ProductLocalDataSource();

  Future<List<Product>> getCachedProducts(String subcategoryId) async {
    final String key = _productsCacheKeyPrefix + subcategoryId;
    final String? jsonString = await SharedPrefsHelper.getString(key);

    if (jsonString != null && jsonString.isNotEmpty) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    }

    return [];
  }

  Future<void> cacheProducts(
      String subcategoryId, List<Product> products) async {
    final String key = _productsCacheKeyPrefix + subcategoryId;
    final List<Map<String, dynamic>> jsonList =
        products.map((product) => product.toJson()).toList();

    await SharedPrefsHelper.setString(key, json.encode(jsonList));
  }

  Future<Set<String>> getFavoriteProductIds() async {
    final List<String>? favorites =
        await SharedPrefsHelper.getStringList(_favoriteProductsKey);
    return favorites?.toSet() ?? <String>{};
  }

  Future<void> saveFavoriteProductIds(Set<String> favoriteIds) async {
    await SharedPrefsHelper.setStringList(
      _favoriteProductsKey,
      favoriteIds.toList(),
    );
  }
}
