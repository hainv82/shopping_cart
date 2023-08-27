import 'package:dio/dio.dart';

abstract class AuthenticationInterceptor extends QueuedInterceptor {
  AuthenticationInterceptor();

  Dio? dio;

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (authenticatedCatcher(err)) {
      onResolve(err, handler);
    }else {
      handler.next(err);
    }
  }

  void onResolve(DioError err, ErrorInterceptorHandler handler);

  bool authenticatedCatcher(DioError err) {
    return err.response?.statusCode == 401;
  }
}
