import 'package:shopping_cart/qsoft/model/product_data.model.dart';

abstract class QSoftRepository{
  Future<ProductData> getProduct();
}