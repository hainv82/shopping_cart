import 'package:dio/dio.dart';

class DefaultResponseHandlerInterceptor extends Interceptor {
  @override
  void onResponse(
      Response response,
      ResponseInterceptorHandler handler,
      ) {
    handler.next(response);
  }
}
