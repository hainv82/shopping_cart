import 'package:dio/dio.dart';
import 'package:shopping_cart/zcore/lib/exception/network_exception.dart';

import 'package:shopping_cart/zcore/lib/exception/sample_error.dart';
import '../../manager/connection.dart';
import '../../network/interceptor/authentication_interceptor.dart';
import '../../sso/jwt_service.dart';

bool test = true;

class AppAuthenticationInterceptor extends AuthenticationInterceptor {
  @override
  void onResolve(DioError err, ErrorInterceptorHandler handler) async {
    var tokenResponse =
    await JwtService.refreshToken().catchError((e, s) => null);
    if (tokenResponse != null) {
      final requestOpts = err.response?.requestOptions;
      if (requestOpts != null) {
        requestOpts.headers['Authorization'] == await getToken();
        final _newResponse = await dio?.fetch(requestOpts).onError(
              (e, s) async {
            final DioError error;
            if (e is DioError) {
              error = e;
            } else {
              error = DioError(
                  requestOptions: requestOpts,
                  error: e,
                  type: DioErrorType.other);
            }
            return Response(requestOptions: requestOpts, data: error);
          },
        );
        if (_newResponse != null) {
          if (_newResponse.data is DioError) {
            return handler.next(_newResponse.data);
          } else if (_newResponse.statusCode != null &&
              _newResponse.statusCode! >= 200 &&
              _newResponse.statusCode! < 300) {
            return handler.resolve(_newResponse);
          }
        }
        return handler.next(DioError(
          requestOptions: requestOpts,
          response: _newResponse,
        ));
      }
    }
    return handler.next(err);
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (ConnectionManager.shared.connection == Connection.normal) {
      options.headers['Authorization'] = await getToken();
      handler.next(options);
    } else {
      throw NetworkException(errorCode: SampleErrorCode.noInternetAccess);
    }
  }

  Future<String> getToken() async {
    if (test == false) {
      test = true;
      return 'Bearer ${await JwtService.getToken}[hi]';
    } else {
      return 'Bearer ${await JwtService.getToken}';
    }
  }
}
