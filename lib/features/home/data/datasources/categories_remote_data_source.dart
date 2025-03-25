// features/home/data/datasources/categories_remote_data_source.dart
import 'package:muward_b2b/core/constants/api_constants.dart';
import 'package:muward_b2b/core/network/api_client.dart';

class CategoriesRemoteDataSource {
  final APIClient _apiClient;
  static const ApiType apiType = ApiType.emporix;

  CategoriesRemoteDataSource(this._apiClient);

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.categories}?showRoots=true',
        apiType: apiType,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      // Log error
      throw Exception('Failed to fetch categories: $e');
    }
  }

  Future<Map<String, dynamic>> fetchCategoryById(String categoryId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.categories}/$categoryId',
        apiType: apiType,
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load category: ${response.statusCode}');
      }
    } catch (e) {
      // Log error
      throw Exception('Failed to fetch category: $e');
    }
  }
}
