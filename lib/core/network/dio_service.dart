import 'package:dio/dio.dart';
import 'error_handling_mixin.dart';
import 'file_upload_mixin.dart';
import 'http_methods_mixin.dart';

class DioService with ErrorHandlingMixin, HttpMethodsMixin, FileUploadMixin {
  late final Dio _dio;
  String _language = 'en';

  DioService({
    required String baseUrl,
    Map<String, dynamic>? defaultHeaders,
    bool enableLogging = true,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(milliseconds: 15000),
        receiveTimeout: const Duration(milliseconds: 15000),
        headers: defaultHeaders ??
            {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'lang': _language,
            },
      ),
    );

    // Add logging interceptor if enabled
    if (enableLogging) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: true,
      ));
    }
  }

  // Get the Dio instance directly if needed (used by mixins)
  @override
  Dio getDio() => _dio;

  // Get current headers
  Map<String, dynamic> get headers => _dio.options.headers;

  // Process path implementation for mixins
  @override
  Future<String> processPath(String path) async {
    // By default, no processing is needed at this level
    return path;
  }

  // Error handling implementation for mixins
  @override
  Exception handleError(DioException error) {
    return handleDioError(error);
  }

  // Header management
  void setHeader(String key, String value) {
    _dio.options.headers[key] = value;
    // Log the header being set for debugging
    print('Setting header $key: $value');
    print('Current headers: ${_dio.options.headers}');
  }

  void clearHeader(String key) {
    _dio.options.headers.remove(key);
  }

  void setLanguage(String languageCode) {
    _language = languageCode;
    _dio.options.headers['lang'] = languageCode;
  }

  void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  void clearHeaders() {
    _dio.options.headers.clear();
    // Reset default headers
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'lang': _language,
    };
  }

  void setTimeout({
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  }) {
    if (connectTimeout != null) {
      _dio.options.connectTimeout = connectTimeout;
    }
    if (receiveTimeout != null) {
      _dio.options.receiveTimeout = receiveTimeout;
    }
    if (sendTimeout != null) {
      _dio.options.sendTimeout = sendTimeout;
    }
  }
}
