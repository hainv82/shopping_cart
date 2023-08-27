import 'package:shopping_cart/zcore/gateway2/api_gateway2.dart';
import 'package:shopping_cart/zcore/gateway2/custom_interceptor.dart';

class AppGateway2 extends ApiGateway2 {
  AppGateway2({
    required String endpoint,
    required String prefix,
    required HTTPMethod method,
    data,
    Map<String, dynamic>? params,
    Map<String, dynamic>? header,
    String? contentType,
  }) : super(
            endpoint: endpoint,
            prefix: prefix,
            method: method,
            data: data,
            params: params,
            headers: header);

  @override
  void addConfigureInterceptors() {
    super.addConfigureInterceptors();
    dio.interceptors.add(CustomInterceptors());
  }
}
