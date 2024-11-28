import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    const baseUrl = String.fromEnvironment('API_ENDPOINT');
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(milliseconds: 15000),
        receiveTimeout: const Duration(milliseconds: 15000),
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          //Add token
          // options.headers["Authorization"] = 'Bearer your_token_here';

          // Modify or inspect the request before it's sent
          if (kDebugMode) {
            print("Request sent to: ${options.uri}");
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Modify or inspect the response before it's returned
          if (kDebugMode) print("Response received: ${response.data}");
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          // if(error.response?.statusCode == 401 && ) {

          // }
          // Handle or inspect errors before they are returned
          if (kDebugMode) print("Error occurred: ${error.message}");
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
