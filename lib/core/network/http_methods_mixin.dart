import 'package:dio/dio.dart';
import 'dart:io';

/// A mixin containing common HTTP method implementations to avoid code duplication
mixin HttpMethodsMixin {
  // Abstract method that subclasses must implement to get the Dio instance
  Dio getDio();

  // Abstract method to process paths if needed
  Future<String> processPath(String path);

  // Abstract method to handle errors
  Exception handleError(DioException error);

  // HTTP GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    String processedPath = await processPath(path);
    try {
      return await getDio().get(
        processedPath,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw handleError(e);
    }
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
  }) async {
    String processedPath = await processPath(path);
    try {
      return await getDio().post(
        processedPath,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw handleError(e);
    }
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
  }) async {
    String processedPath = await processPath(path);
    try {
      return await getDio().put(
        processedPath,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw handleError(e);
    }
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
  }) async {
    String processedPath = await processPath(path);
    try {
      return await getDio().patch(
        processedPath,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  // HTTP DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    String processedPath = await processPath(path);
    try {
      return await getDio().delete(
        processedPath,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw handleError(e);
    }
  }
}
