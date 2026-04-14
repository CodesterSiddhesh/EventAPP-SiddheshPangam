import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  DioExceptions.fromDioException(DioException dioException)
      : message = _mapException(dioException);

  final String message;

  static String _mapException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Request timed out. Please try again later.';
      case DioExceptionType.badResponse:
        final statusCode = exception.response?.statusCode;
        final responseData = exception.response?.data;

        // Try to extract error message from response body
        String errorMessage = _extractErrorMessage(responseData);

        if (errorMessage.isNotEmpty) {
          return errorMessage;
        }

        // Handle specific status codes
        switch (statusCode) {
          case 400:
            return 'Bad request. Please check your input.';
          case 401:
            return 'Invalid credentials. Please check your email and password.';
          case 403:
            return 'Access forbidden. You do not have permission.';
          case 404:
            return 'Service not found. Please try again later.';
          case 405:
            return 'Method not allowed. The server does not support this request method.';
          case 422:
            return 'Validation error. Please check your input data.';
          case 500:
            return 'Server error. Please try again later.';
          default:
            final statusMessage = exception.response?.statusMessage;
            return 'Server error ($statusCode): ${statusMessage ?? 'Unknown error'}';
        }
      case DioExceptionType.connectionError:
        return 'Unable to connect to the server. Please check your network.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.unknown:
      default:
        return exception.message ?? 'Unexpected error occurred.';
    }
  }

  static String _extractErrorMessage(dynamic responseData) {
    if (responseData == null) return '';

    try {
      if (responseData is Map<String, dynamic>) {
        // Check for common error message fields
        if (responseData.containsKey('message')) {
          return responseData['message'].toString();
        }
        if (responseData.containsKey('error')) {
          final error = responseData['error'];
          if (error is String) {
            return error;
          }
          if (error is Map<String, dynamic> && error.containsKey('message')) {
            return error['message'].toString();
          }
        }
        if (responseData.containsKey('errors')) {
          final errors = responseData['errors'];
          if (errors is Map<String, dynamic>) {
            // Get first error message
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              return firstError.first.toString();
            }
            return firstError.toString();
          }
        }
      }
    } catch (e) {
      // If parsing fails, return empty string to use fallback
      return '';
    }

    return '';
  }

  @override
  String toString() => message;
}
