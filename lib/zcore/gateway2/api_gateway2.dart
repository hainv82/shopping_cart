import 'package:dio/dio.dart';
import 'package:shopping_cart/zcore/gateway2/custom_interceptor.dart';

import 'package:shopping_cart/zcore/lib/exception/network_exception.dart';
import 'package:shopping_cart/zcore/lib/exception/sample_error.dart';

enum HTTPMethod { get, post, put, delete, patch }

class ApiGateway2 {
  final int timeout;
  late Dio _dioInstance;
  final String endpoint;
  final String prefix;
  final HTTPMethod method;
  final String? contentType;
  final Map<String, dynamic>? headers;
  final Map<String, dynamic>? params;
  final dynamic data;

  ApiGateway2({this.timeout = 30000,
    required this.endpoint,
    required this.prefix,
    required this.method,
    this.contentType,
    this.headers,
    this.params,
    this.data,
    BaseOptions? options}) {
    final _options = options?.copyWith(baseUrl: prefix + endpoint,
        connectTimeout: timeout,
        headers: headers,
        contentType: contentType) ?? BaseOptions(baseUrl: prefix + endpoint,
        connectTimeout: timeout,
        headers: headers,
        contentType: contentType);

    _dioInstance = Dio(_options);
    addConfigureInterceptors();
  }

  Dio get dio => _dioInstance;

  void addConfigureInterceptors() {
    _dioInstance.interceptors.add(CustomInterceptors());
  }
  Future<Response> execute() {
    switch (method) {
      case HTTPMethod.get:
        return _dioInstance
            .get(
          prefix+endpoint,
          queryParameters: params,
        )
            .catchError(_errorWrapper);
      case HTTPMethod.post:
        return _dioInstance
            .post(
          prefix+endpoint,
          data: data,
          queryParameters: params,
        )
            .catchError(_errorWrapper);
      case HTTPMethod.put:
        return _dioInstance
            .put(
          prefix+endpoint,
          data: data,
        )
            .catchError(_errorWrapper);
      case HTTPMethod.delete:
        return _dioInstance
            .delete(
          prefix+endpoint,
          queryParameters: params,
        )
            .catchError(_errorWrapper);
      case HTTPMethod.patch:
        return _dioInstance
            .patch(
          prefix+endpoint,
          data: data,
        )
            .catchError(_errorWrapper);
    }
  }

  Future<Response> _errorWrapper(dynamic error) {
    if (error is DioError) {
      if (error.error is NetworkException) {
        throw error.error;
      } else {
        throw NetworkException(
            errorCode: SampleErrorCode.connectionFail,
            error: error,
            message: 'error with url: ${error.response?.requestOptions.path}');
      }
    } else {
      throw NetworkException(
          errorCode: SampleErrorCode.connectionFail,
          error: error,
          message: 'error with url: ${prefix+endpoint}');
    }
  }
}
