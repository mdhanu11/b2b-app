import 'package:dio/dio.dart';
import 'package:muward_b2b/core/network/api_client.dart';

extension AlgoliaAPIClient on APIClient {
  Dio _getAlgoliaDio(String baseUrl, Map<String, dynamic> headers) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: headers,
    ));

    return dio;
  }

  // Method to make direct Algolia requests
  Future<Response> algoliaPost(
    String baseUrl,
    String path, {
    required Map<String, dynamic> headers,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final dio = _getAlgoliaDio(baseUrl, headers);

    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return response;
    } catch (e) {
      if (e is DioException) {
        // Handle DioError
        throw Exception('Algolia request failed: ${e.message}');
      }
      // Re-throw other errors
      rethrow;
    } finally {
      // Clean up Dio instance
      dio.close();
    }
  }
}
