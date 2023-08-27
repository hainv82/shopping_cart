// import 'package:core_ui/exceptions/network_exception.dart';
import 'package:dio/dio.dart';

import 'package:shopping_cart/zcore/lib/exception/network_exception.dart';
import 'package:shopping_cart/zcore/lib/exception/sample_error.dart';
// import 'package:sample_exception/sample_exception.dart';

class AppInterceptor extends QueuedInterceptor {
  AppInterceptor();

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    String errorCode;
    switch (err.response?.statusCode) {
      case 400:
        errorCode = SampleErrorCode.badRequest;
        break;
      case 401:
        errorCode = SampleErrorCode.unauthorized;
        handler.next(DioError(
          requestOptions: err.requestOptions,
          error: AuthenticationException(
              error: err,
              message: 'error with url: ${err.response?.requestOptions.path}'),
          response: err.response,
          type: err.type,
        ));
        return;
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
      error: NetworkException(
          errorCode: errorCode,
          error: err,
          message: 'error with url: ${err.response?.requestOptions.path}'),
      response: err.response,
      type: err.type,
    ));
  }
}
