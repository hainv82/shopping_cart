import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shopping_cart/qsoft/model/product.model.dart';

part 'product_data.model.g.dart';

@JsonSerializable()
class ProductData extends Equatable{
  @JsonKey(name: 'listProduct')
  final List<Product> listProduct;

  const ProductData({required this.listProduct});

  static ProductData fromJson(Map<String, dynamic> json) => _$ProductDataFromJson(json);
  @override
  List<Object?> get props => [listProduct];

}

