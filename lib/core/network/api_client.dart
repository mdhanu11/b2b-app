// lib/core/network/api_client.dart
import 'package:dio/dio.dart';
import 'dart:io';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../constants/api_constants.dart';
import 'dio_service.dart';

enum ApiType {
  emporix,
  talabat,
}

class APIClient {
  late final DioService _emporixDio;
  late final DioService _talabatDio;
  final AuthRepository _authRepository;
  String _currentLanguage = 'en';

  APIClient(this._authRepository) {
    // Initialize Emporix DioService
    _emporixDio = DioService(
      baseUrl: ApiConstants.emporixBaseUrl,
      defaultHeaders: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Initialize Talabat DioService
    _talabatDio = DioService(
      baseUrl: ApiConstants.talabatBaseUrl,
      defaultHeaders: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'lang': _currentLanguage,
      },
    );
  }

  // Debug method to inspect headers
  void logHeaders(ApiType apiType) {
    final dioService = _getDioService(apiType);
    print('Current headers for ${apiType.name}: ${dioService.headers}');
  }

  // Private helper method to process path with tenant
  Future<String> _processPath(String path, ApiType apiType) async {
    if (apiType == ApiType.emporix && path.contains('{tenant}')) {
      final authData = await _authRepository.getAuthData();

      if (authData == null || authData.tenant.isEmpty) {
        throw Exception('Emporix tenant is not available. Please login again.');
      }
      return path.replaceAll('{tenant}', authData.tenant);
    }
    return path;
  }

  // Set the language code for API requests
  void setLanguage(String languageCode) {
    _currentLanguage = languageCode;
    _emporixDio.setLanguage(languageCode);
    _talabatDio.setLanguage(languageCode);
  }

  // Get the appropriate DioService based on API type
  DioService _getDioService(ApiType apiType) {
    return apiType == ApiType.emporix ? _emporixDio : _talabatDio;
  }

  // Add auth token to requests
  Future<void> setAuthToken(ApiType apiType) async {
    final authData = await _authRepository.getAuthData();
    if (authData != null && authData.token.isNotEmpty) {
      _getDioService(apiType)
          .setHeader('Authorization', 'Bearer ${authData.token}');
    }
  }

  // Add custom headers to a specific API
  void addHeader(String key, String value, ApiType apiType) {
    _getDioService(apiType).setHeader(key, value);
    // Log headers after adding
    logHeaders(apiType);
  }

  // Clear a specific header
  void clearHeader(String key, ApiType apiType) {
    _getDioService(apiType).clearHeader(key);
  }

  // HTTP GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    ApiType apiType = ApiType.emporix,
    Map<String, dynamic>? additionalHeaders,
  }) async {
    await setAuthToken(apiType);

    // Add any additional headers
    if (additionalHeaders != null) {
      for (var entry in additionalHeaders.entries) {
        _getDioService(apiType).setHeader(entry.key, entry.value);
      }
    }

    // Add X-Version header for all GET requests
    _getDioService(apiType).setHeader('X-Version', 'v2');

    // Log the headers for debugging
    logHeaders(apiType);

    String processedPath = await _processPath(path, apiType);
    return _getDioService(apiType).get(
      processedPath,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  // HTTP POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    ApiType apiType = ApiType.emporix,
    Map<String, dynamic>? additionalHeaders,
  }) async {
    await setAuthToken(apiType);

    // Add any additional headers
    if (additionalHeaders != null) {
      for (var entry in additionalHeaders.entries) {
        _getDioService(apiType).setHeader(entry.key, entry.value);
      }
    }

    String processedPath = await _processPath(path, apiType);
    return _getDioService(apiType).post(
      processedPath,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  // HTTP PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    ApiType apiType = ApiType.emporix,
    Map<String, dynamic>? additionalHeaders,
  }) async {
    await setAuthToken(apiType);

    // Add any additional headers
    if (additionalHeaders != null) {
      for (var entry in additionalHeaders.entries) {
        _getDioService(apiType).setHeader(entry.key, entry.value);
      }
    }

    String processedPath = await _processPath(path, apiType);
    return _getDioService(apiType).put(
      processedPath,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  // HTTP PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    ApiType apiType = ApiType.emporix,
    Map<String, dynamic>? additionalHeaders,
  }) async {
    await setAuthToken(apiType);

    // Add any additional headers
    if (additionalHeaders != null) {
      for (var entry in additionalHeaders.entries) {
        _getDioService(apiType).setHeader(entry.key, entry.value);
      }
    }

    String processedPath = await _processPath(path, apiType);
    return _getDioService(apiType).patch(
      processedPath,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  // HTTP DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ApiType apiType = ApiType.emporix,
    Map<String, dynamic>? additionalHeaders,
  }) async {
    await setAuthToken(apiType);

    // Add any additional headers
    if (additionalHeaders != null) {
      for (var entry in additionalHeaders.entries) {
        _getDioService(apiType).setHeader(entry.key, entry.value);
      }
    }

    String processedPath = await _processPath(path, apiType);
    return _getDioService(apiType).delete(
      processedPath,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  // File upload methods
  Future<Response> uploadFile(
    String path, {
    required File file,
    required String paramName,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    ApiType apiType = ApiType.emporix,
    Map<String, dynamic>? additionalHeaders,
  }) async {
    await setAuthToken(apiType);

    // Add any additional headers
    if (additionalHeaders != null) {
      for (var entry in additionalHeaders.entries) {
        _getDioService(apiType).setHeader(entry.key, entry.value);
      }
    }

    String processedPath = await _processPath(path, apiType);
    return _getDioService(apiType).uploadFile(
      processedPath,
      file: file,
      paramName: paramName,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response> uploadFiles(
    String path, {
    required List<File> files,
    required String paramName,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    ApiType apiType = ApiType.emporix,
    Map<String, dynamic>? additionalHeaders,
  }) async {
    await setAuthToken(apiType);

    // Add any additional headers
    if (additionalHeaders != null) {
      for (var entry in additionalHeaders.entries) {
        _getDioService(apiType).setHeader(entry.key, entry.value);
      }
    }

    String processedPath = await _processPath(path, apiType);
    return _getDioService(apiType).uploadFiles(
      processedPath,
      files: files,
      paramName: paramName,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response> postFormData(
    String path, {
    required Map<String, dynamic> formData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    ApiType apiType = ApiType.emporix,
    Map<String, dynamic>? additionalHeaders,
  }) async {
    await setAuthToken(apiType);

    // Add any additional headers
    if (additionalHeaders != null) {
      for (var entry in additionalHeaders.entries) {
        _getDioService(apiType).setHeader(entry.key, entry.value);
      }
    }

    String processedPath = await _processPath(path, apiType);
    return _getDioService(apiType).postFormData(
      processedPath,
      formData: formData,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response> downloadFile(
    String path,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    ApiType apiType = ApiType.emporix,
    Map<String, dynamic>? additionalHeaders,
  }) async {
    await setAuthToken(apiType);

    // Add any additional headers
    if (additionalHeaders != null) {
      for (var entry in additionalHeaders.entries) {
        _getDioService(apiType).setHeader(entry.key, entry.value);
      }
    }

    String processedPath = await _processPath(path, apiType);
    return _getDioService(apiType).downloadFile(
      processedPath,
      savePath,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  // Set timeout durations
  void setTimeout({
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    ApiType apiType = ApiType.emporix,
  }) {
    _getDioService(apiType).setTimeout(
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
    );
  }

  // Set base URL (useful if you need to change environment)
  void setBaseUrl(String baseUrl, ApiType apiType) {
    _getDioService(apiType).setBaseUrl(baseUrl);
  }

  // Clear all headers
  void clearHeaders(ApiType apiType) {
    _getDioService(apiType).clearHeaders();
  }
}
