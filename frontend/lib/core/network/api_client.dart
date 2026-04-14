import 'package:dio/dio.dart';

import '../storage/token_storage.dart';
import 'dio_exceptions.dart';

class ApiClient {
  ApiClient({required String baseUrl}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
      contentType: 'application/json',
      headers: {
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(
      LogInterceptor(
        responseBody: true,
        requestBody: true,
        error: true,
        requestHeader: false,
        responseHeader: false,
      ),
    );

    // Add auth interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  late final Dio _dio;

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get<T>(path, queryParameters: queryParameters);
    } on DioException catch (exception) {
      throw DioExceptions.fromDioException(exception);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post<T>(path, data: data, queryParameters: queryParameters);
    } on DioException catch (exception) {
      throw DioExceptions.fromDioException(exception);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.put<T>(path, data: data, queryParameters: queryParameters);
    } on DioException catch (exception) {
      throw DioExceptions.fromDioException(exception);
    }
  }
}
