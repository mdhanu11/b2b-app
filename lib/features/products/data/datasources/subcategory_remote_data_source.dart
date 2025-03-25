import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';

class SubcategoryRemoteDataSource {
  final APIClient _apiClient;
  static const ApiType apiType = ApiType.emporix;

  SubcategoryRemoteDataSource(this._apiClient);

  Future<List<Map<String, dynamic>>> getSubcategories(
    String parentId, {
    int pageNumber = 1,
    int pageSize = 60,
  }) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.categories}/$parentId/subcategories',
        queryParameters: {
          'pageNumber': pageNumber,
          'pageSize': pageSize,
        },
        apiType: apiType,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load subcategories: ${response.statusCode}');
      }
    } catch (e) {
      // Log error
      throw Exception('Failed to fetch subcategories: $e');
    }
  }
}
