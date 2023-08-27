import 'package:dio/dio.dart';

import 'package:shopping_cart/zcore/lib/exception/network_exception.dart';
import 'package:shopping_cart/zcore/lib/exception/sample_error.dart';


class DefaultErrorHandlerInterceptor extends Interceptor {
  @override
  void onError(
      DioError err,
      ErrorInterceptorHandler handler,
      ) {
    String errorCode;
    switch (err.response?.statusCode) {
      case 400:
        errorCode = SampleErrorCode.badRequest;
        break;
      case 401:
        errorCode = SampleErrorCode.unauthorized;
        break;
      case 404:
        errorCode = SampleErrorCode.fileNotFound;
        break;
      case 405:
        errorCode = SampleErrorCode.methodNotAllowed;
        break;
      case 408:
        errorCode = SampleErrorCode.requestTimeOut;
        break;
      case 500:
        errorCode = SampleErrorCode.serverError;
        break;
      case 501:
        errorCode = SampleErrorCode.badGateway;
        break;
      default:
        errorCode = SampleErrorCode.connectionFail;
    }
    handler.next(DioError(
      requestOptions: err.requestOptions,
      error: NetworkException(errorCode: errorCode, error: err),
      response: err.response,
      type: err.type,
    ));
  }
}
