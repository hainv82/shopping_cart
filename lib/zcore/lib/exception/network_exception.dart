import 'package:dio/dio.dart';
import 'package:exception_templates/exception_templates.dart';
import '../../sample_exception/src/sample_exception.dart';
import 'sample_error.dart';


class NetworkException<T> extends SampleException<T> {
  NetworkException(
      {String errorCode = '',
        T? error,
        StackTrace? stackTrace,
        String? message = 'Error in network'})
      : super(errorCode,
      error: error,
      stackTrace: stackTrace,
      time: DateTime.now(),
      message: message);

  @override
  // TODO: implement errorCode
  String get errorCode => 'network-${super.errorCode}';
}

class AuthenticationException extends NetworkException<DioError> {
  AuthenticationException({
    DioError? error,
    StackTrace? stackTrace,
    String? message = 'Hết hạn đăng nhập',
  }) : super(
      errorCode: SampleErrorCode.unauthorized,
      error: error,
      stackTrace: stackTrace,
      message: message);
}
