import 'package:shopping_cart/helper/app_config.dart';
import 'package:shopping_cart/helper/qsoft_resource.dart';
import 'package:shopping_cart/qsoft/model/product_data.model.dart';
import 'package:shopping_cart/qsoft/repository/qsoft_repo.dart';
import 'package:shopping_cart/zcore/gateway2/api_gateway2.dart';
import 'package:shopping_cart/zcore/gateway2/app_gateway2.dart';

class QSoftRepoImplement extends QSoftRepository {
  @override
  Future<ProductData> getProduct() async {
    final api = AppGateway2(
        endpoint: ePointProduct(), prefix: baseHost(), method: HTTPMethod.get);
    var res=await api.execute();
    final data=ProductData.fromJson(res.data);
    return data;
  }
}
