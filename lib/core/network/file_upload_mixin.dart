// lib/core/network/mixins/file_upload_mixin.dart
import 'package:dio/dio.dart';
import 'dart:io';

mixin FileUploadMixin {
  // Abstract method that subclasses must implement to get the Dio instance
  Dio getDio();

  // Abstract method to process paths if needed
  Future<String> processPath(String path);

  // Abstract method to handle errors
  Exception handleError(DioException error);

  // Upload a single file with form data
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
  }) async {
    String processedPath = await processPath(path);
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        paramName: await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
        if (data != null) ...data,
      });

      return await getDio().post(
        processedPath,
        data: formData,
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

  // Upload multiple files with form data
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
  }) async {
    try {
      List<MultipartFile> multipartFiles = [];

      for (var file in files) {
        String fileName = file.path.split('/').last;
        multipartFiles.add(
          await MultipartFile.fromFile(
            file.path,
            filename: fileName,
          ),
        );
      }

      Map<String, dynamic> formMap = {};
      if (data != null) {
        formMap.addAll(data);
      }

      formMap[paramName] = multipartFiles;
      FormData formData = FormData.fromMap(formMap);

      String processedPath = await processPath(path);

      return await getDio().post(
        processedPath,
        data: formData,
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

  // Submit form data (useful for forms with both text fields and files)
  Future<Response> postFormData(
    String path, {
    required Map<String, dynamic> formData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      // Convert the form data map to FormData object
      FormData dioFormData = FormData();

      for (var entry in formData.entries) {
        if (entry.value is File) {
          File file = entry.value as File;
          String fileName = file.path.split('/').last;
          dioFormData.files.add(
            MapEntry(
              entry.key,
              await MultipartFile.fromFile(
                file.path,
                filename: fileName,
              ),
            ),
          );
        } else if (entry.value is List<File>) {
          List<File> files = entry.value as List<File>;
          for (var file in files) {
            String fileName = file.path.split('/').last;
            dioFormData.files.add(
              MapEntry(
                '${entry.key}[]', // Add array notation for multiple files
                await MultipartFile.fromFile(
                  file.path,
                  filename: fileName,
                ),
              ),
            );
          }
        } else {
          dioFormData.fields.add(MapEntry(entry.key, entry.value.toString()));
        }
      }

      String processedPath = await processPath(path);

      return await getDio().post(
        processedPath,
        data: dioFormData,
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

  // Download a file and save it to a local path
  Future<Response> downloadFile(
    String path,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    String processedPath = await processPath(path);
    try {
      return await getDio().download(
        processedPath,
        savePath,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw handleError(e);
    }
  }
}
