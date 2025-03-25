import 'package:dio/dio.dart';
import 'dart:io';

/// A mixin containing error handling logic for Dio exceptions
mixin ErrorHandlingMixin {
  // Helper method to handle Dio exceptions
  Exception handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Connection timeout');
      case DioExceptionType.sendTimeout:
        return Exception('Send timeout');
      case DioExceptionType.receiveTimeout:
        return Exception('Receive timeout');
      case DioExceptionType.badCertificate:
        return Exception('Bad certificate');
      case DioExceptionType.badResponse:
        // Handle different HTTP status codes
        switch (error.response?.statusCode) {
          case 400:
            return Exception('Bad request: ${error.response?.data}');
          case 401:
            return Exception('Unauthorized: ${error.response?.data}');
          case 403:
            return Exception('Forbidden: ${error.response?.data}');
          case 404:
            return Exception('Not found: ${error.response?.data}');
          case 500:
            return Exception('Server error: ${error.response?.data}');
          default:
            return Exception(
                'HTTP error ${error.response?.statusCode}: ${error.response?.data}');
        }
      case DioExceptionType.cancel:
        return Exception('Request canceled');
      case DioExceptionType.connectionError:
        return Exception('Connection error: ${error.message}');
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return Exception('No internet connection');
        }
        return Exception('Unknown error: ${error.message}');
    }
  }
}
